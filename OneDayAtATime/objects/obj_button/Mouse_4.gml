/// obj_button - Left Pressed Event
/// Resolves the Q4 choice and cleans up both buttons.

if (button_action == "discard") {
    discard_task_q4(obj_game_controller.q4_choice_task);
} else if (button_action == "defer") {
    defer_task_q4(obj_game_controller.q4_choice_task);
}

obj_game_controller.q4_choice_active = false;
obj_game_controller.q4_choice_task = noone;

sync_task_cards();

with (obj_button) instance_destroy();