/// obj_button - Draw Event

if (button_action == "discard") {
    image_blend = make_color_rgb(150, 50, 50); 
} else if (button_action == "defer") {
    image_blend = make_color_rgb(50, 100, 150); 
} else {
    image_blend = c_white;
}

draw_self();
image_blend = c_white; 

draw_set_color(c_black); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + sprite_width / 2, y + sprite_height / 2, label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);