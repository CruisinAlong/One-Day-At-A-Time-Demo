/// obj_button - Step Event
/// The persistent END DAY button hides itself while the day-review panel
/// is open, so only one day-progression action is ever visible/clickable
/// at a time (the panel's own CLOSE & NEXT DAY button).

if (button_action == "end_day") {
    visible = !obj_game_controller.day_review_active;
}

if (button_action == "end_day") {
	visible = !obj_game_controller.game_over;
}
