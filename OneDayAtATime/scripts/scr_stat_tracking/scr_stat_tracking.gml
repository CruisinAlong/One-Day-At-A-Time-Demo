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


/// Modifies a stat by _amount, clamped between 0 and 100.
/// Other systems (task resolution, future events, etc.) should call this
/// rather than setting the variables directly.
function stat_modify(_stat_name, _amount) {
    with (obj_game_controller) {
        switch (_stat_name) {
            case "productivity":
                productivity = clamp(productivity + _amount, 0, 100);
                break;
            case "happiness":
                happiness = clamp(happiness + _amount, 0, 100);
                break;
            case "relaxation":
                relaxation = clamp(relaxation + _amount, 0, 100);
                break;
            default:
                show_debug_message("stat_modify: unknown stat name " + string(_stat_name));
        }
    }
}