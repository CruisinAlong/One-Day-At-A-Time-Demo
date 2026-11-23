/// obj_quadrant_panel - Draw Event
/// Draws only hover/invalid-drop feedback outlines over this quadrant's zone.

var _ctrl = obj_game_controller;

var _hovering = false;
with (obj_task_card) {
    if (is_dragging) {
        var _cx = x + sprite_width / 2;
        var _cy = y + sprite_height / 2;
        if (point_in_rectangle(_cx, _cy, other.zone_x, other.zone_y,
                other.zone_x + other.zone_w, other.zone_y + other.zone_h)) {
            _hovering = true;
        }
    }
}

if (_hovering) {
    var _cap = _ctrl.quadrant_capacity[$ quadrant_key];
    var _count = array_length(_ctrl.quadrant_tasks[$ quadrant_key]);
    var _ok = (_count < _cap) || (quadrant_key == "q4" && !_ctrl.q4_choice_active);
    draw_set_color(_ok ? c_lime : c_red);
    draw_rectangle_border_width(zone_x, zone_y, zone_x + zone_w, zone_y + zone_h, 4);
}

if (_ctrl.invalid_drop_flash > 0 && _ctrl.invalid_drop_quadrant == quadrant_key) {
    draw_set_color(c_red);
    draw_rectangle_border_width(zone_x, zone_y, zone_x + zone_w, zone_y + zone_h, 4);
}

draw_set_color(c_white);