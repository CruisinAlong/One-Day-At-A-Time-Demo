/// obj_game_controller - Step Event
/// Drag-and-drop input is handled by obj_task_card's own events.
/// This just counts down the invalid-drop visual feedback timer.

if (invalid_drop_flash > 0) invalid_drop_flash -= 1;