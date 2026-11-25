/// obj_button - Create Event

button_action = ""; // "discard" | "defer" | "complete_deferred" | "continue_day" | "end_day"
label = "";
task = noone;          // set when this button represents a specific deferred task
persistent_ui = false; // true = survives destroy_transient_buttons() (e.g. the END DAY button)
depth = -11000; 