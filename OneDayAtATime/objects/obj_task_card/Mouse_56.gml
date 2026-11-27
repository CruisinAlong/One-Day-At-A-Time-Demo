/// obj_task_card - Global Left Released Event
/// Ends the drag and attempts to drop the card on a quadrant or back into
/// the available tasks area. If the mouse barely moved since the press
/// (a click rather than a drag) and this card belongs to the available
/// pool, show the task preview popup instead of treating it as a drop.

if (is_dragging) {
    is_dragging = false;
    depth = 0;

    var _move_dist = point_distance(drag_start_x, drag_start_y, mouse_x, mouse_y);
    var _CLICK_THRESHOLD = 6;

    if (_move_dist <= _CLICK_THRESHOLD) {
        if (home_quadrant == "available") {
            obj_game_controller.task_preview_active = true;
            obj_game_controller.task_preview_task = task;
            spawn_task_preview_close_button();
        }
        sync_task_cards();
        exit;
    }

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