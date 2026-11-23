/// obj_game_controller - Create Event
/// Central controller: holds all game state and runs initialization.

// ---------------------------------------------------------
// STATISTICS (managed through scr_stat_tracking functions)
// ---------------------------------------------------------
stats_init();

// ---------------------------------------------------------
// BACKLOG PRESSURE
// ---------------------------------------------------------
backlog_pressure = 0; // 0 - 100

// ---------------------------------------------------------
// DAY PROGRESSION
// ---------------------------------------------------------
game_day = 1;
max_days = 4;
game_over = false;
ending_name = "";
ending_description = "";

// ---------------------------------------------------------
// TASK POOLS
// ---------------------------------------------------------
// available_tasks: tasks the player can currently drag/assign
// deferred_tasks: tasks carried over from Q3 or Q4-defer, added back next day
available_tasks = [];
deferred_tasks = [];

// ---------------------------------------------------------
// EISENHOWER MATRIX
// ---------------------------------------------------------
// Each quadrant has a capacity (modifiable by future events) and an array
// of currently assigned task structs (length <= capacity).
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

// ---------------------------------------------------------
// DRAG AND DROP STATE
// ---------------------------------------------------------
dragging = false;
drag_task = noone;       // the task struct currently being dragged
drag_source = "";        // "available" or "q1"/"q2"/"q3"/"q4"
drag_source_index = -1;  // index within source array
drag_offset_x = 0;
drag_offset_y = 0;
mouse_x_prev = 0;
mouse_y_prev = 0;

// Feedback flags (reset every step, set during input handling)
invalid_drop_flash = 0; // frames remaining to show invalid-drop feedback

// ---------------------------------------------------------
// Q4 CHOICE POPUP STATE
// ---------------------------------------------------------
q4_choice_active = false;
q4_choice_task = noone;

// ---------------------------------------------------------
// LAYOUT CONSTANTS (interface positions - 1280x720 room)
// ---------------------------------------------------------
layout = {
    stat_panel_x: 20,
    stat_panel_y: 20,
    stat_bar_w: 200,
    stat_bar_h: 20,

    matrix_x: 350,
    matrix_y: 150,
    quad_w: 280,
    quad_h: 200,
    quad_gap: 10,

    task_area_x: 20,
    task_area_y: 150,
    card_w: 300,
    card_h: 70,
    card_gap: 10,

    end_day_btn_x: 1100,
    end_day_btn_y: 650,
    end_day_btn_w: 150,
    end_day_btn_h: 50
};

// ---------------------------------------------------------
// START DAY 1
// ---------------------------------------------------------
game_start_new_day();