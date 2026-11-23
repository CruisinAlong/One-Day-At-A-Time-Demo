/// obj_button - Draw Event

draw_self();
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + sprite_width / 2, y + sprite_height / 2, label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);