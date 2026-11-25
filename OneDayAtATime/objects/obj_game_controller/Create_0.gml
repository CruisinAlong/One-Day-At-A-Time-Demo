/// obj_game_controller - Create Event
/// Central controller: holds all game state and runs initialization.

depth = 100;
visible = true;

// ---------------------------------------------------------
// STATISTICS (managed through scr_stat_tracking functions)
// ---------------------------------------------------------
stats_init();

// ---------------------------------------------------------
// BACKLOG PRESSURE
// ---------------------------------------------------------
// UNIMPLEMENTED
backlog_pressure = 0; // 0 - 100

// ---------------------------------------------------------
// DAY PROGRESSION
// ---------------------------------------------------------
// UNIMPLEMENTED
game_day = 1;
max_days = 4;
game_over = false;
ending_name = "";
ending_description = "";

// ---------------------------------------------------------
// END-OF-DAY REVIEW (deferred task review before advancing to next day)
// ---------------------------------------------------------
day_review_active = false;
review_page = 0; 

// ---------------------------------------------------------
// TASK POOLS
// ---------------------------------------------------------
available_tasks = [];
scheduled_tasks = [];
deferred_tasks = [];
discarded_tasks = [];

// ---------------------------------------------------------
// EISENHOWER MATRIX
// ---------------------------------------------------------
quadrant_capacity = {
    q1: 1,
    q2: 1,
    q3: 1,
    q4: 1
};

quadrant_tasks = {
    q1: [],
    q2: [],
    q3: [],
    q4: []
};

quadrant_colors = {
    q1: c_lime,
    q2: c_yellow,
    q3: c_aqua,
    q4: c_red
};

quadrant_labels = {
    q1: "URGENT + IMPORTANT",
    q2: "NOT URGENT + IMPORTANT",
    q3: "URGENT + NOT IMPORTANT",
    q4: "NOT URGENT + NOT IMPORTANT"
};

// ---------------------------------------------------------
// DRAG / DROP FEEDBACK
// ---------------------------------------------------------
invalid_drop_flash = 0;
invalid_drop_quadrant = "";

// ---------------------------------------------------------
// Q4 DISCARD/DEFER CHOICE (currently unwired, kept for future use)
// ---------------------------------------------------------
q4_choice_active = false;
q4_choice_task = noone;

// ---------------------------------------------------------
// LAYOUT (shared by Draw event + scr_game_logic rect helpers)
// ---------------------------------------------------------
layout = {
    stat_panel_x: 32,
    stat_panel_y: 32,
    stat_panel_w: 280,
    stat_panel_h: 110,
    stat_line_gap: 28,

    matrix_x: 32,
    matrix_y: 176,
    matrix_w: 820,
    matrix_h: 560,

    quad_card_w: 220,
    quad_card_h: 48,

    task_area_x: 900,
    task_area_y: 176,
    card_cols: 1,
    card_w: 220,
    card_h: 48,
    card_gap_x: 16,
    card_gap_y: 16
};

// ---------------------------------------------------------
// TASK SYSTEM (TaskSystem.gml - loads global.taskList from CSV)
// ---------------------------------------------------------
TaskDatabase();


// ---------------------------------------------------------
// PERSISTENT UI (survives destroy_transient_buttons() calls)
// ---------------------------------------------------------
spawn_end_day_button();

// ---------------------------------------------------------
// DAY 1 SETUP (populates available_tasks and spawns task cards)
// ---------------------------------------------------------
game_start_new_day();