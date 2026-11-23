/// obj_task_card - Global Left Released Event
/// Ends the drag and attempts to drop the card on a quadrant or back into
/// the available tasks area.

if (is_dragging) {
    is_dragging = false;
    depth = 0;

    var _target_key = "";
    var _cx = x + sprite_width / 2;
    var _cy = y + sprite_height / 2;

    with (obj_quadrant_panel) {
        if (point_in_rectangle(_cx, _cy, zone_x, zone_y, zone_x + zone_w, zone_y + zone_h)) {
            _target_key = quadrant_key;
        }
    }

    if (_target_key != "") {
        var _placed = assign_task_to_quadrant(task, _target_key);
        if (!_placed) {
            obj_game_controller.invalid_drop_flash = 20;
            obj_game_controller.invalid_drop_quadrant = _target_key;
        }
    } else {
        var _lay = obj_game_controller.layout;
        var _area_bottom = _lay.task_area_y + (_lay.card_h + _lay.card_gap_y) * 4;
        var _area_right = _lay.task_area_x + (_lay.card_w + _lay.card_gap_x) * _lay.card_cols;
        if (point_in_rectangle(_cx, _cy, _lay.task_area_x, _lay.task_area_y, _area_right, _area_bottom)) {
            if (home_quadrant != "available") {
                return_task_to_available(task);
            }
        }
    }

    sync_task_cards();
}