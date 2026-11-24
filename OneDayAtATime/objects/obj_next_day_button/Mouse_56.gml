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

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (_has_tasks && !obj_game_controller.game_over &&
    point_in_rectangle(_mx, _my, x, y, x + button_w, y + button_h))
{
	with (obj_game_controller)
    {
        if (!game_over)
        {
            // Apply task effects and process quadrant assignments
            process_day_tasks();

            // Check if the current day is the final day
            if (game_day >= max_days)
            {
                game_over = true;
                ending_name = "Completed";
                ending_description = "You completed all four days.";

                show_debug_message("=== GAME COMPLETED ===");
            }
            else
            {
                game_day += 1;

                show_debug_message("=== ADVANCING TO DAY " + string(game_day) + " ===");
            }
        }
    }

    if (!obj_game_controller.game_over)
    {
        game_start_new_day();
    }
}