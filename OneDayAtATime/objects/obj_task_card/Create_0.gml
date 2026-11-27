/// obj_task_card - Create Event
/// Represents a single draggable task card. task/home_quadrant are set
/// externally right after instance_create_layer() by sync_task_cards().

task = undefined;          // the task struct this card represents
home_quadrant = "available"; // "available" | "q1" | "q2" | "q3" | "q4"
is_dragging = false;
drag_offset_x = 0;
drag_offset_y = 0;
drag_start_x = 0;          // mouse position at press, used to distinguish
drag_start_y = 0;          // a click (preview popup) from an actual drag

depth = 0;