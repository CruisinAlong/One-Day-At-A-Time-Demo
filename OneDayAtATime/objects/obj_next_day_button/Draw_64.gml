var _has_tasks = false;

with (obj_game_controller)
{
	if(game_day == max_days){
		if (array_length(quadrant_tasks.q1) > 0 &&
			array_length(quadrant_tasks.q2) > 0 &&
			array_length(quadrant_tasks.q3) > 0 )
		{
			_has_tasks = true;
		}
	}
	else{
		if (array_length(quadrant_tasks.q1) > 0 &&
			array_length(quadrant_tasks.q2) > 0 &&
			array_length(quadrant_tasks.q3) > 0 &&
			array_length(quadrant_tasks.q4) > 0)
		{
			_has_tasks = true;
		}
	}
}

if (_has_tasks && !obj_game_controller.game_over)
{
	draw_set_color(c_white);
	draw_rectangle(x, y, x + button_w, y + button_h, false);

	draw_set_color(c_black);
	draw_rectangle(x, y, x + button_w, y + button_h, true);

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(x + button_w / 2, y + button_h / 2, "NEXT DAY");

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
