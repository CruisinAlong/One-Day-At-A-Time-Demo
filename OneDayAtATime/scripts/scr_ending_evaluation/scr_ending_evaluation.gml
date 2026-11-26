/// Builds a per-stat verdict ("above", "at", or "below" the 50 baseline)
/// and stores a human-readable summary on obj_game_controller so the
/// ending screen (Draw_64.gml) can display how the player did on each
/// of the three stats. This is the "normal" ending path, triggered once
/// max_days is reached without an early_game_end() having already fired.
function scr_ending_evaluation() {
    with (obj_game_controller) {
        game_over = true;

        var _p = stat_get("productivity");
        var _h = stat_get("happiness");
        var _r = stat_get("relaxation");

        ending_stat_summary = [
            { label: "PRODUCTIVITY", value: _p, verdict: stat_verdict(_p) },
            { label: "HAPPINESS",    value: _h, verdict: stat_verdict(_h) },
            { label: "RELAXATION",   value: _r, verdict: stat_verdict(_r) }
        ];

        ending_name = "Day " + string(max_days) + " Complete";
        ending_description = "Here's how your " + string(max_days) + " days went:";

        show_debug_message("[Ending Evaluation] P:" + string(_p) + " H:" + string(_h) + " R:" + string(_r));
    }
}


/// Returns "above", "at", or "below" depending on how _value compares
/// to the 50 baseline.
function stat_verdict(_value) {
    if (_value > 50) return "above";
    if (_value < 50) return "below";
    return "at";
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