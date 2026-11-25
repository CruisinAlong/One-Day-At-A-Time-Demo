/// Game logic module: task assignment, quadrant capacity management, and
/// task repositioning.


/// Game logic module: task assignment, quadrant capacity management, and
/// task repositioning.

#macro DAILY_TASK_POOL_SIZE 4

/// Sets up available tasks for the current day: pulls back any scheduled
/// (Q3) or deferred (Q4) tasks from the previous day first, then tops up
/// the available pool with fresh tasks from the database so the total
/// number of available tasks always stays at DAILY_TASK_POOL_SIZE,
/// regardless of how many tasks were carried over. Clears quadrant
/// assignments. Does NOT advance game_day automatically - advance_to_next_day()
/// (below) is responsible for incrementing game_day before calling this.
function game_start_new_day() {
    with (obj_game_controller) {
        show_debug_message("=== [game_start_new_day] START Day " + string(game_day) + " ===");

        quadrant_tasks.q1 = [];
        quadrant_tasks.q2 = [];
        quadrant_tasks.q3 = [];
        quadrant_tasks.q4 = [];

        available_tasks = [];
        retrieve_carried_over_tasks();

        var _carried_over_count = array_length(available_tasks);
        var _fresh_needed = max(0, DAILY_TASK_POOL_SIZE - _carried_over_count);

        var _db = TaskDatabaseClone();
        var _db_len = array_length(_db);
        for (var i = 0; i < _fresh_needed; i++) {
            var _index = (game_day - 1) * DAILY_TASK_POOL_SIZE + i;
            _index = _index mod _db_len;
            array_push(available_tasks, _db[_index]);
        }

        show_debug_message("[game_start_new_day] Carried-over: " + string(_carried_over_count) + ", Fresh added: " + string(_fresh_needed));
        show_debug_message("[game_start_new_day] Total available_tasks: " + string(array_length(available_tasks)));
        show_debug_message("=== [game_start_new_day] END ===");
    }

    sync_task_cards();
}


/// Called when the player finishes the end-of-day review (presses
/// "NEXT DAY"). Advances game_day and, if the final day hasn't been
/// reached, starts the new day. If max_days has been exceeded, flags
/// game_over - ending evaluation (scr_ending_evaluation) is left for
/// another developer to wire in.
function advance_to_next_day() {
    with (obj_game_controller) {
        game_day += 1;

        if (game_day > max_days) {
            game_over = true;
            show_debug_message("[Day Progression] Final day reached. game_over = true.");
            return;
        }
    }

    game_start_new_day();
}


/// Returns the index of _task inside _array (matched by id), or -1.
function task_array_find_index(_array, _task) {
    for (var i = 0; i < array_length(_array); i++)
    {
        if (_array[i].taskId == _task.taskId)
        {
            return i;
        }
    }

    return -1;
}


/// Returns true if the given quadrant ("q1".."q4") has room
/// for another task based on its configurable capacity.
function quadrant_has_space(_key) {
    with (obj_game_controller) {
        var _count = array_length(quadrant_tasks[$ _key]);
        var _cap = quadrant_capacity[$ _key];
        return (_count < _cap);
    }
}


/// Removes _task from available_tasks and every quadrant array.
/// Does not touch scheduled/deferred/discarded storage.
function remove_task_from_all_locations(_task) {
    with (obj_game_controller) {
        var _i = task_array_find_index(available_tasks, _task);
        if (_i != -1) array_delete(available_tasks, _i, 1);

        var _keys = ["q1", "q2", "q3", "q4"];
        for (var k = 0; k < array_length(_keys); k++) {
            var _key = _keys[k];
            var _arr = quadrant_tasks[$ _key];
            var _idx = task_array_find_index(_arr, _task);
            if (_idx != -1) {
                array_delete(_arr, _idx, 1);
                quadrant_tasks[$ _key] = _arr;
            }
        }
    }
}


/// Attempts to move _task into quadrant _key. Returns true on
/// success, false if the quadrant is full. All four quadrants behave the
/// same at drop time - the task simply sits in its slot. Q4's discard/defer
/// popup (scr_task_scheduling: discard_task_q4 / defer_task_q4 /
/// spawn_q4_popup_buttons) is intentionally NOT triggered here - that flow
/// is now driven by the END DAY / end-of-day review system instead.
/// Q3 assignment still immediately schedules the task for the next day
/// since that's just bookkeeping with no UI interruption.
/// Tasks carried over from a previous day's Q3 (marked locked_to_q1q2 by
/// retrieve_carried_over_tasks) are rejected outright if the player tries
/// to drop them into Q3 or Q4 again - they must be resolved via Q1/Q2.
function assign_task_to_quadrant(_task, _key) {
    with (obj_game_controller) {

        if ((_key == "q3" || _key == "q4")
            && variable_struct_exists(_task, "locked_to_q1q2")
            && _task.locked_to_q1q2) {
            return false;
        }

        if (!quadrant_has_space(_key)) return false;

        remove_task_from_all_locations(_task);

        _task.status = "assigned";
        _task.assignedQuadrant = _key;

        var _arr = quadrant_tasks[$ _key];
        array_push(_arr, _task);
        quadrant_tasks[$ _key] = _arr;

        if (_key == "q3")
        {
            schedule_task_q3(_task);
        }

        return true;
    }
}

/// Removes _task from wherever it is and returns it to the
/// available tasks area, resetting its status/assignedQuadrant.
function return_task_to_available(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);
        _task.status = "available";
        _task.assignedQuadrant = "";
        array_push(available_tasks, _task);
    }
}

// ---------------------------------------------------------
// LAYOUT / HIT-TESTING HELPERS (shared by Step input and Draw rendering)
// ---------------------------------------------------------


/// Returns {x, y, w, h} for one quarter of the single matrix
/// frame (split evenly by the cross-divider lines).
function get_quadrant_rect(_key) {
    with (obj_game_controller) {
        var _half_w = layout.matrix_w / 2;
        var _half_h = layout.matrix_h / 2;
        var _col = (_key == "q2" || _key == "q4") ? 1 : 0;
        var _row = (_key == "q3" || _key == "q4") ? 1 : 0;
        var _x = layout.matrix_x + _col * _half_w;
        var _y = layout.matrix_y + _row * _half_h;
        return { x: _x, y: _y, w: _half_w, h: _half_h };
    }
}


/// Returns the rect for the task card at _index within quadrant _key,
/// out of _total cards currently in that quadrant. The whole vertical
/// stack of _total cards is centered as a single block within the
/// quadrant, rather than centering only the first card.
function get_quadrant_card_rect(_key, _index, _total) {
    with (obj_game_controller) {
        var _q = get_quadrant_rect(_key);
        var _gap = 8;
        var _stack_h = (_total * layout.quad_card_h) + ((_total - 1) * _gap);
        var _x = _q.x + (_q.w - layout.quad_card_w) / 2;
        var _y = _q.y + (_q.h - _stack_h) / 2 + _index * (layout.quad_card_h + _gap);
        return { x: _x, y: _y, w: layout.quad_card_w, h: layout.quad_card_h };
    }
}


/// Returns the rect for the available-task card at _index,
/// arranged in a grid (card_cols columns) on the right side of the screen.
function get_available_card_rect(_index) {
    with (obj_game_controller) {
        var _col = _index mod layout.card_cols;
        var _row = _index div layout.card_cols;
        var _x = layout.task_area_x + _col * (layout.card_w + layout.card_gap_x);
        var _y = layout.task_area_y + _row * (layout.card_h + layout.card_gap_y);
        return { x: _x, y: _y, w: layout.card_w, h: layout.card_h };
    }
}