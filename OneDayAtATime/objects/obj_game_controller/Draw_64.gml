/// obj_game_controller - Draw Event
/// Draws the stat panel box and the single Eisenhower Matrix frame
/// (outer border + cross-divider lines). Task cards and quadrant hover
/// feedback draw themselves via their own objects.

draw_set_font(-1);

// ===========================================================
// STAT PANEL (bordered box, top-left)
// ===========================================================
var _sx = layout.stat_panel_x;
var _sy = layout.stat_panel_y;
var _sw = layout.stat_panel_w;
var _sh = layout.stat_panel_h;

draw_set_color(c_white);
draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
draw_set_color(c_black);
draw_rectangle_border_width(_sx, _sy, _sx + _sw, _sy + _sh, 2);

var _stats = [
    { label: "HAPPINESS",   value: stat_get("happiness"),    color: c_yellow },
    { label: "PRODUCTIVITY",value: stat_get("productivity"), color: c_aqua },
    { label: "RELAXATION",  value: stat_get("relaxation"),   color: c_lime }
];

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
for (var i = 0; i < array_length(_stats); i++) {
    var _ly = _sy + 20 + i * layout.stat_line_gap;
    var _s = _stats[i];

    draw_set_color(_s.color);
    draw_circle(_sx + 18, _ly, 8, false);

    draw_set_color(c_black);
    draw_text(_sx + 36, _ly, _s.label + " : " + string(_s.value) + "/100");
}
draw_set_valign(fa_top);

// ===========================================================
// EISENHOWER MATRIX FRAME (single bordered box + cross divider)
// ===========================================================
var _mx = layout.matrix_x;
var _my = layout.matrix_y;
var _mw = layout.matrix_w;
var _mh = layout.matrix_h;

draw_set_color(c_white);
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
draw_set_color(c_black);
draw_rectangle_border_width(_mx, _my, _mx + _mw, _my + _mh, 2);

// Cross divider lines
draw_line_width(_mx, _my + _mh / 2, _mx + _mw, _my + _mh / 2, 2);
draw_line_width(_mx + _mw / 2, _my, _mx + _mw / 2, _my + _mh, 2);

// Corner indicator dots (one per quadrant, colored, matches mockup)
draw_set_color(quadrant_colors.q1);
draw_circle(_mx + 14, _my + 14, 7, false);
draw_set_color(quadrant_colors.q2);
draw_circle(_mx + _mw - 14, _my + 14, 7, false);
draw_set_color(quadrant_colors.q3);
draw_circle(_mx + 14, _my + _mh - 14, 7, false);
draw_set_color(quadrant_colors.q4);
draw_circle(_mx + _mw - 14, _my + _mh - 14, 7, false);

draw_set_color(c_white);
draw_text(layout.task_area_x, layout.task_area_y - 26, "Available Tasks");

// ===========================================================
// Q4 DISCARD / DEFER CHOICE POPUP (background + text only;
// buttons are real obj_button instances drawn on top)
// ===========================================================
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