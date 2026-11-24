/// obj_button - Left Pressed Event
/// Resolves the Q4 choice and cleans up both buttons.
/// This event is kept functional and ready for another developer
/// to call spawn_q4_popup_buttons() (scr_card_sync) whenever the Q4
/// resolution flow is wired into the day-progression system.

if (button_action == "discard") {
    discard_task_q4(obj_game_controller.q4_choice_task);
} else if (button_action == "defer") {
    defer_task_q4(obj_game_controller.q4_choice_task);
}

obj_game_controller.q4_choice_active = false;
obj_game_controller.q4_choice_task = noone;

sync_task_cards();

with (obj_button) instance_destroy();