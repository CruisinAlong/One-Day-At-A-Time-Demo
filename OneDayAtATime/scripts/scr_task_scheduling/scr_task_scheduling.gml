/// Q3 scheduling and Q4 discard/defer storage.
/// This is the integration point another developer should call into when
/// starting a new day (retrieve_carried_over_tasks is already wired into
/// game_start_new_day in scr_game_logic, so no extra call is needed there).

function schedule_task_q3(_task) {
    with (obj_game_controller) {
        _task.status = "scheduled";
        array_push(scheduled_tasks, _task);
        show_debug_message("[Q3 Scheduling] '" + _task.name + "' scheduled for the next day.");
    }
}


/// Called when the player chooses "Defer" during Q4 resolution.
/// Removes the task from the Q4 slot and stores it in deferred_tasks so it
/// becomes available again when the next day starts.
function defer_task_q4(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);
        _task.status = "deferred";
        _task.assigned_quadrant = "";
        array_push(deferred_tasks, _task);
        show_debug_message("[Q4 Skipping] '" + _task.name + "' deferred to the next day.");
    }
}


/// Called when the player chooses "Discard" during Q4 resolution.
/// Removes the task from the Q4 slot and permanently removes it from play.
function discard_task_q4(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);
        _task.status = "discarded";
        _task.assigned_quadrant = "";
        array_push(discarded_tasks, _task);
        show_debug_message("[Q4 Skipping] '" + _task.name + "' discarded permanently.");
    }
}

function retrieve_carried_over_tasks() {
    with (obj_game_controller) {
        var _count = 0;

        for (var i = 0; i < array_length(scheduled_tasks); i++) {
            var _t = scheduled_tasks[i];
            _t.status = "available";
            _t.assigned_quadrant = "";
            array_push(available_tasks, _t);
            _count++;
        }
        scheduled_tasks = [];

        for (var j = 0; j < array_length(deferred_tasks); j++) {
            var _d = deferred_tasks[j];
            _d.status = "available";
            _d.assigned_quadrant = "";
            array_push(available_tasks, _d);
            _count++;
        }
        deferred_tasks = [];

        show_debug_message("[retrieve_carried_over_tasks] Returned " + string(_count) + " carried-over task(s) to available_tasks.");
    }
}

function get_scheduled_tasks() {
    return obj_game_controller.scheduled_tasks;
}

function get_deferred_tasks() {
    return obj_game_controller.deferred_tasks;
}