/// Stat tracking module.
/// Stats are stored on obj_game_controller as instance variables and
/// accessed/modified ONLY through these functions, so other systems have a
/// single clean integration point.

/// stats_init()
/// Initializes all three statistics to 50. Call once at game start.
function stats_init() {
    with (obj_game_controller) {
        productivity = 50;
        happiness = 50;
        relaxation = 50;
    }
}


/// Returns the current value of a stat by name.
///  One of "productivity", "happiness", "relaxation"
function stat_get(_stat_name) {
    switch (_stat_name) {
        case "productivity": return obj_game_controller.productivity;
        case "happiness":    return obj_game_controller.happiness;
        case "relaxation":   return obj_game_controller.relaxation;
        default:
            show_debug_message("stat_get: unknown stat name " + string(_stat_name));
            return 0;
    }
}


/// Returns _value formatted with an explicit "+" sign for positive
/// numbers and "-" for negative (0 shows as "+0"), used for displaying
/// stat deltas in task popups (e.g. "+15", "-5").
function stat_format_delta(_value) {
    if (_value >= 0) return "+" + string(_value);
    return string(_value);
}


/// Modifies a stat by _amount, clamped between 0 and 100.
/// Other systems (task resolution, future events, etc.) should call this
/// rather than setting the variables directly.
function stat_modify(_stat_name, _amount) {
    with (obj_game_controller) {
        switch (_stat_name) {
            case "productivity":
                productivity = clamp(productivity + _amount, 0, 100);
				stat_check_thresholds("productivity", productivity);
                break;
            case "happiness":
                happiness = clamp(happiness + _amount, 0, 100);
				stat_check_thresholds("happiness", happiness);
                break;
            case "relaxation":
                relaxation = clamp(relaxation + _amount, 0, 100);
				stat_check_thresholds("relaxation", relaxation);
                break;
            default:
                show_debug_message("stat_modify: unknown stat name " + string(_stat_name));
        }
    }
}

function stat_apply_task(_task) {
    stat_modify("productivity", _task.currentP);
    stat_modify("happiness", _task.currentH);
    stat_modify("relaxation", _task.currentR);
}

//for now debug text
function stat_check_thresholds(_stat_name, _value) {
	switch (_stat_name) {
		case "productivity":
			if (_value <= 40) {
				show_debug_message("PRODUCTIVITY: 40 threshold reached!");
			}

			if (_value <= 25) {
				show_debug_message("PRODUCTIVITY: 25 threshold reached!");
			}

			if (_value <= 15) early_game_end("productivity")
			break;

		case "happiness":
			if (_value <= 40) {
				show_debug_message("HAPPINESS: 40 threshold reached!");
			}

			if (_value <= 25) {
				 show_debug_message("HAPPINESS: 25 threshold reached!");
			}

			if (_value <= 15) early_game_end("happiness")
			break;

		case "relaxation":
			if (_value <= 40) {
				show_debug_message("RELAXATION: 40 threshold reached!");
			}

			if (_value <= 25) {
				show_debug_message("RELAXATION: 25 threshold reached!");
			}

			if (_value <= 15) early_game_end("relaxation");
			break;
    }
}