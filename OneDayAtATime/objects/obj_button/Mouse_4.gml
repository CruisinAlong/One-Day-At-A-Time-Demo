/// obj_button - Left Pressed Event
/// Resolves whichever action this button represents.

switch (button_action) {
    case "discard":
        discard_task_q4(obj_game_controller.q4_choice_task);
        obj_game_controller.q4_choice_active = false;
        obj_game_controller.q4_choice_task = noone;
        sync_task_cards();
        destroy_transient_buttons();
        break;

    case "defer":
        defer_task_q4(obj_game_controller.q4_choice_task);
        obj_game_controller.q4_choice_active = false;
        obj_game_controller.q4_choice_task = noone;
        sync_task_cards();
        destroy_transient_buttons();
        break;

    case "complete_deferred":
        complete_deferred_task(task);
        spawn_day_review_ui(); 
        break;

    case "review_prev_page":
        obj_game_controller.review_page = max(0, obj_game_controller.review_page - 1);
        spawn_day_review_ui();
        break;

    case "review_next_page":
        obj_game_controller.review_page += 1;
        spawn_day_review_ui();
        break;

    case "continue_day":
        obj_game_controller.day_review_active = false;
        destroy_transient_buttons();
        advance_to_next_day();
        break;

    case "end_day":
        end_day_and_review();
        break;
}