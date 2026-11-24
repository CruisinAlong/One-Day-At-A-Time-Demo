function scr_ending_evaluation(){

}

function early_game_end(_stat_name){
	switch (_stat_name){
		case "productivity":
			show_debug_message("PRODUCTIVITY: bad end");
			game_over = true;
            ending_name = "Burnout";
            ending_description = "failed skul";
			break;

		case "happiness":
			show_debug_message("HAPPINESS: bad end");
			game_over = true;
            ending_name = "Depression";
            ending_description = "is sad";
			break;

		case "relaxation":
			show_debug_message("RELAXATION: bad end");
			game_over = true;
            ending_name = "urm idk yet";
            ending_description = "not so chill";
			break;
	}
}