/// Destroys all existing obj_task_card instances and respawns
/// them to match the current available_tasks / quadrant_tasks data. Call
/// this any time those arrays change (assignment, return-to-available,
/// Q4 discard/defer, new day start).
function sync_task_cards() {
    with (obj_task_card) instance_destroy();

    with (obj_game_controller) {
        for (var i = 0; i < array_length(available_tasks); i++) {
            var _r = get_available_card_rect(i);
            var _inst = instance_create_layer(_r.x, _r.y, "Instances", obj_task_card);
            _inst.task = available_tasks[i];
            _inst.home_quadrant = "available";
        }

        var _keys = ["q1", "q2", "q3", "q4"];
        for (var k = 0; k < array_length(_keys); k++) {
            var _key = _keys[k];
            var _arr = quadrant_tasks[$ _key];
            var _total = array_length(_arr);
            for (var j = 0; j < _total; j++) {
                var _cr = get_quadrant_card_rect(_key, j, _total);
                var _inst2 = instance_create_layer(_cr.x, _cr.y, "Instances", obj_task_card);
                _inst2.task = _arr[j];
                _inst2.home_quadrant = _key;
            }
        }
    }
}


/// Spawns the DISCARD and DEFER button instances for the Q4
/// choice popup. Called automatically when a task is assigned to Q4.
function spawn_q4_popup_buttons() {
    with (obj_button) instance_destroy();

    var _btn_w = 160;
    var _btn_h = 50;
    var _popup_cx = room_width / 2;
    var _popup_cy = room_height / 2;
    var _btn_y = _popup_cy + 50;

    var _discard = instance_create_layer(_popup_cx - _btn_w - 15, _btn_y, "Instances", obj_button);
    _discard.button_action = "discard";
    _discard.label = "DISCARD";

    var _defer = instance_create_layer(_popup_cx + 15, _btn_y, "Instances", obj_button);
    _defer.button_action = "defer";
    _defer.label = "DEFER";
}