/// obj_game_controller - Draw GUI Event
/// Always runs after every normal Draw event
/// overlay sits on top of the matrix, quadrants, and task cards.

if (q4_choice_active && q4_choice_task != noone) {
    var _pw = 500;
    var _ph = 220;
    var _px = (room_width - _pw) / 2;
    var _py = (room_height - _ph) / 2;

    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(45, 45, 55));
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_color(c_white);
    draw_rectangle_border_width(_px, _py, _px + _pw, _py + _ph, 2);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_px + _pw / 2, _py + 20, "Not Urgent & Not Important");
    draw_text(_px + _pw / 2, _py + 50, "\"" + q4_choice_task.name + "\"");
    draw_text(_px + _pw / 2, _py + 80, "Discard it permanently, or defer it to the next day?");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}