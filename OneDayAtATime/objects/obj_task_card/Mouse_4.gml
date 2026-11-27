/// obj_task_card - Left Pressed Event
/// Begins dragging this card, unless the Q4 choice popup is active.

if (!obj_game_controller.q4_choice_active) {
    is_dragging = true;
    drag_offset_x = mouse_x - x;
    drag_offset_y = mouse_y - y;
    drag_start_x = mouse_x;
    drag_start_y = mouse_y;
    depth = -1000; 
}