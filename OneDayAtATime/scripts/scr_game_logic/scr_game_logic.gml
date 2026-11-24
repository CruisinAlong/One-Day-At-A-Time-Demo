/// Game logic module: task assignment, quadrant capacity management, and
/// task repositioning.


/// Sets up available tasks for the current day: generates four
/// fresh predefined tasks from the database and pulls back any scheduled
/// (Q3) or deferred (Q4) tasks from the previous day. Clears quadrant
/// assignments. Does NOT advance game_day automatically - another developer
/// is responsible for calling this as part of the four-day progression system.
function game_start_new_day() {
    with (obj_game_controller) {
        show_debug_message("=== [game_start_new_day] START Day " + string(game_day) + " ===");

        quadrant_tasks.q1 = [];
        quadrant_tasks.q2 = [];
        quadrant_tasks.q3 = [];
        quadrant_tasks.q4 = [];

        var _db = task_database_clone();
        var _db_len = array_length(_db);
        var _new_tasks = [];
        for (var i = 0; i < 4; i++) {
            var _index = (game_day - 1) * 4 + i;
            _index = _index mod _db_len;
            array_push(_new_tasks, _db[_index]);
        }

        available_tasks = _new_tasks;
        retrieve_carried_over_tasks();

        show_debug_message("[game_start_new_day] Total available_tasks: " + string(array_length(available_tasks)));
        show_debug_message("=== [game_start_new_day] END ===");
    }

    sync_task_cards();
}


/// Returns the index of _task inside _array (matched by id), or -1.
function task_array_find_index(_array, _task) {
    for (var i = 0; i < array_length(_array); i++) {
        if (_array[i].id == _task.id) return i;
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
/// belongs to the day-progression system being built by another developer.
/// Q3 assignment still immediately schedules the task for the next day
/// since that's just bookkeeping with no UI interruption.
function assign_task_to_quadrant(_task, _key) {
    with (obj_game_controller) {
        if (!quadrant_has_space(_key)) return false;

        remove_task_from_all_locations(_task);
        _task.status = "assigned";
        _task.assigned_quadrant = _key;

        var _arr = quadrant_tasks[$ _key];
        array_push(_arr, _task);
        quadrant_tasks[$ _key] = _arr;

        if (_key == "q3") {
            schedule_task_q3(_task);
        }

        return true;
    }
}


/// Removes _task from wherever it is and returns it to the
/// available tasks area, resetting its status/assigned_quadrant.
function return_task_to_available(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);
        _task.status = "available";
        _task.assigned_quadrant = "";
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


/// Returns the rect for the task card at _index within quadrant _key.
function get_quadrant_card_rect(_key, _index) {
    with (obj_game_controller) {
        var _q = get_quadrant_rect(_key);
        var _x = _q.x + (_q.w - layout.quad_card_w) / 2;
        var _y = _q.y + (_q.h - layout.quad_card_h) / 2 + _index * (layout.quad_card_h + 8);
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