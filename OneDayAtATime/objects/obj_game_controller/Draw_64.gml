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
    draw_text(_px + _pw / 2, _py + 50, "\"" + q4_choice_task.currentTitle + "\"");
    draw_text(_px + _pw / 2, _py + 80, "Discard it permanently, or defer it to the next day?");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (day_review_active) {
    var _panel = get_day_review_panel_rect();
    var _px2 = _panel.x;
    var _py2 = _panel.y;
    var _pw2 = _panel.w;
    var _ph2 = _panel.h;

    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(45, 45, 55));
    draw_rectangle(_px2, _py2, _px2 + _pw2, _py2 + _ph2, false);
    draw_set_color(c_white);
    draw_rectangle_border_width(_px2, _py2, _px2 + _pw2, _py2 + _ph2, 2);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_px2 + _pw2 / 2, _py2 + 20, "Day " + string(game_day) + " Complete");
    draw_set_halign(fa_left);
    draw_text(_px2 + 40, _py2 + 60, "Deferred tasks - address what you can before the next day begins:");

    var _count = array_length(deferred_tasks);

    if (_count == 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_px2 + _pw2 / 2, _py2 + _ph2 / 2, "No deferred tasks remain. You're all caught up!");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    } else {
        var _task = deferred_tasks[review_page];
        var _text_x = _px2 + 40;
        var _text_w = _pw2 - 80;
        var _text_top = _py2 + 100;

        draw_set_halign(fa_center);
        draw_text(_px2 + _pw2 / 2, _py2 + _ph2 - 130, "Task " + string(review_page + 1) + " / " + string(_count));
        draw_set_halign(fa_left);

        draw_set_color(c_white);
        draw_text(_text_x, _text_top, "\"" + _task.currentTitle + "\"");
        draw_set_color(c_silver);
        draw_text_ext(_text_x, _text_top + 30, _task.currentDesc, 22, _text_w);
        draw_set_color(c_white);
    }

    draw_set_valign(fa_top);
}