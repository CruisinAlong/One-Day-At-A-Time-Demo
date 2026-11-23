/// Game logic module: task assignment, quadrant capacity management, and
/// task repositioning. Q3 scheduling / Q4 discard-defer storage live in
/// scr_task_scheduling.gml and are called from here at the right moments.

/// @function game_start_new_day()
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

function task_array_find_index(_array, _task) {
    for (var i = 0; i < array_length(_array); i++) {
        if (_array[i].id == _task.id) return i;
    }
    return -1;
}

function quadrant_has_space(_key) {
    with (obj_game_controller) {
        var _count = array_length(quadrant_tasks[$ _key]);
        var _cap = quadrant_capacity[$ _key];
        return (_count < _cap);
    }
}

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

function assign_task_to_quadrant(_task, _key) {
    with (obj_game_controller) {
        if (_key == "q4") {
            if (q4_choice_active) return false;

            remove_task_from_all_locations(_task);
            _task.status = "pending_choice";
            _task.assigned_quadrant = "q4";
            q4_choice_active = true;
            q4_choice_task = _task;
            spawn_q4_popup_buttons();
            return true;
        }

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

function return_task_to_available(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);
        _task.status = "available";
        _task.assigned_quadrant = "";
        array_push(available_tasks, _task);
    }
}

/// @function get_quadrant_rect(_key)
/// @description Returns {x, y, w, h} for one quarter of the single matrix
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

function get_quadrant_card_rect(_key, _index) {
    with (obj_game_controller) {
        var _q = get_quadrant_rect(_key);
        var _x = _q.x + (_q.w - layout.quad_card_w) / 2;
        var _y = _q.y + (_q.h - layout.quad_card_h) / 2 + _index * (layout.quad_card_h + 8);
        return { x: _x, y: _y, w: layout.quad_card_w, h: layout.quad_card_h };
    }
}

/// @function get_available_card_rect(_index)
/// @description Returns the rect for the available-task card at _index,
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