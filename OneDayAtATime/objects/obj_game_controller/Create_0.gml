/// obj_game_controller - Create Event
/// Central controller: holds all game state and runs initialization.

depth = 100;
visible = true;

// ---------------------------------------------------------
// STATISTICS (managed through scr_stat_tracking functions)
// ---------------------------------------------------------
stats_init();

// ---------------------------------------------------------
// Initialization of Tasks
// ---------------------------------------------------------
TaskDatabase();
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
    q2: c_aqua,
    q3: c_orange,
    q4: c_red
};

quadrant_labels = {
    q1: "Urgent & Important",
    q2: "Not Urgent, Important",
    q3: "Urgent, Not Important",
    q4: "Not Urgent & Not Important"
};

// ---------------------------------------------------------
// DRAG FEEDBACK (invalid-drop flash only - drag itself is handled
// by obj_task_card)
// ---------------------------------------------------------
invalid_drop_flash = 0;
invalid_drop_quadrant = "";

// ---------------------------------------------------------
// Q4 CHOICE POPUP STATE
// ---------------------------------------------------------
q4_choice_active = false;
q4_choice_task = noone;

// ---------------------------------------------------------
// LAYOUT CONSTANTS (matches mockup: matrix left, stats top-left,
// tasks right in a 2x2 grid. Room target: 1280x720)
// ---------------------------------------------------------
layout = {
    // Stat panel - small bordered box, top-left
    stat_panel_x: 40,
    stat_panel_y: 20,
    stat_panel_w: 340,
    stat_panel_h: 110,
    stat_line_gap: 28,

    // Reserved space for the  Day banner, top-right of stat panel
    day_banner_x: 760,
    day_banner_y: 20,
    day_banner_w: 480,
    day_banner_h: 110,

    // Eisenhower Matrix - ONE bordered frame, split visually by cross-lines
    matrix_x: 40,
    matrix_y: 170,
    matrix_w: 680,
    matrix_h: 460,

    // Task cards - 2x2 grid on the right
    task_area_x: 760,
    task_area_y: 170,
    card_w: 220,
    card_h: 140,
    card_gap_x: 20,
    card_gap_y: 20,
    card_cols: 2,

    quad_card_w: 260,
    quad_card_h: 60
};

// ---------------------------------------------------------
// START DAY 1
// ---------------------------------------------------------
game_start_new_day(); // also calls sync_task_cards() internally