/// @function game_start_new_day()
/// @description Sets up available tasks for the current day: generates four
/// fresh predefined tasks from the database and adds back any deferred tasks
/// from the previous day. Clears quadrant assignments.
function game_start_new_day() {
    with (obj_game_controller) {
        show_debug_message("=== [game_start_new_day] START Day " + string(game_day) + " ===");

        // Clear quadrant assignments for the new day
        quadrant_tasks.q1 = [];
        quadrant_tasks.q2 = [];
        quadrant_tasks.q3 = [];
        quadrant_tasks.q4 = [];
        show_debug_message("[game_start_new_day] Quadrants cleared.");

        // Pull 4 predefined tasks from the database (cycle through if needed)
        var _db = task_database_clone();
        var _db_len = array_length(_db);
        var _new_tasks = [];
        for (var i = 0; i < 4; i++) {
            var _index = (game_day - 1) * 4 + i;
            _index = _index mod _db_len; // wrap around if we run out
            array_push(_new_tasks, _db[_index]);
        }

        show_debug_message("[game_start_new_day] Generated " + string(array_length(_new_tasks)) + " new tasks:");
        for (var k = 0; k < array_length(_new_tasks); k++) {
            show_debug_message("   - " + _new_tasks[k].name + " (id=" + string(_new_tasks[k].id) + ", status=" + _new_tasks[k].status + ")");
        }

        // Start available_tasks as the new tasks, then add deferred ones back
        available_tasks = _new_tasks;

        if (array_length(deferred_tasks) > 0) {
            show_debug_message("[game_start_new_day] Re-adding " + string(array_length(deferred_tasks)) + " deferred task(s):");
            for (var j = 0; j < array_length(deferred_tasks); j++) {
                show_debug_message("   - " + deferred_tasks[j].name + " (id=" + string(deferred_tasks[j].id) + ")");
                array_push(available_tasks, deferred_tasks[j]);
            }
        } else {
            show_debug_message("[game_start_new_day] No deferred tasks to re-add.");
        }

        deferred_tasks = [];

        show_debug_message("[game_start_new_day] Stats -> Productivity: " + string(productivity) +
            ", Happiness: " + string(happiness) +
            ", Relaxation: " + string(relaxation) +
            ", Backlog Pressure: " + string(backlog_pressure));

        show_debug_message("[game_start_new_day] Total available_tasks: " + string(array_length(available_tasks)));
        show_debug_message("=== [game_start_new_day] END ===");
    }
}