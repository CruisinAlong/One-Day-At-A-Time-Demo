/// Q3 scheduling and Q4 discard/defer storage.
/// This is the integration point u should call into when
/// starting a new day (retrieve_carried_over_tasks is already wired into
/// game_start_new_day in scr_game_logic, so no extra call is needed there).


/// Marks _task as scheduled for the next day and stores it in
/// the controller's scheduled_tasks collection. The task is NOT removed from
/// its visual quadrant slot for the remainder of the current day - it still
/// displays in Q3 so the player can see it's been scheduled. It is excluded
/// from the current day's available_tasks pool (already removed by
/// assign_task_to_quadrant before this is called).
function schedule_task_q3(_task) {
    with (obj_game_controller)
    {
        _task.isQ3 = true;
        _task.isQ4 = false;
        _task.status = "scheduled";

        array_push(scheduled_tasks, _task);

        show_debug_message("[Q3 Scheduling] '" + _task.currentTitle + "' scheduled for the next day.");
    }
}

/// Called when the player chooses "Defer" in the Q4 popup.
/// Stores the task in the deferred_tasks collection so it becomes available
/// again when the next day starts. Currently does not touch statistics or backlog
/// pressure
function defer_task_q4(_task) {
    with (obj_game_controller)
    {
        TaskSetDeferred(_task);

        _task.isQ3 = false;
        _task.isQ4 = true;
        _task.assignedQuadrant = 0;
        _task.status = "deferred";

        array_push(deferred_tasks, _task);

        show_debug_message("[Q4 Skipping] '" + _task.currentTitle + "' deferred to the next day.");
    }
}


/// Called when the player chooses "Discard" in the Q4 popup.
/// Permanently removes the task from active play. Kept in discarded_tasks
/// purely as a record rn it is never retrieved or made available again, this should be able to be taken from again
function discard_task_q4(_task) {
    with (obj_game_controller)
    {
        _task.isQ3 = false;
        _task.isQ4 = true;
        _task.assignedQuadrant = 0;
        _task.status = "discarded";

        array_push(discarded_tasks, _task);

        show_debug_message("[Q4 Discarding] '" + _task.currentTitle + "' discarded permanently.");
    }
}


/// Pulls all Q3-scheduled and Q4-deferred tasks back into
/// available_tasks, resetting their status/assigned_quadrant, then clears
/// both source collections. Intended to be called once per new day (already
/// wired into game_start_new_day()). Discarded tasks are never retrieved.
function retrieve_carried_over_tasks() {
    with (obj_game_controller)
    {
        var _count = 0;

        // Retrieve Q3 scheduled tasks.
        for (var i = 0; i < array_length(scheduled_tasks); i++)
        {
            var _task = scheduled_tasks[i];

            _task.isQ3 = false;
            _task.isQ4 = false;
            _task.assignedQuadrant = 0;
            _task.status = "available";

            array_push(available_tasks, _task);
            _count++;
        }

        scheduled_tasks = [];


        // Retrieve Q4 deferred tasks.
        for (var j = 0; j < array_length(deferred_tasks); j++)
        {
            var _task = deferred_tasks[j];

            // Keep the deferred version of the task.
            _task.isQ3 = false;
            _task.isQ4 = false;
            _task.assignedQuadrant = 0;
            _task.status = "available";

            array_push(available_tasks, _task);
            _count++;
        }

        deferred_tasks = [];

        show_debug_message("[Task Retrieval] Returned " + string(_count) + " carried-over task(s).");
    }
}


/// Read-only accessor for the current Q3 scheduled task list.
function get_scheduled_tasks() {
    return obj_game_controller.scheduled_tasks;
}


/// Read-only accessor for the current Q4 deferred task list.
function get_deferred_tasks() {
    return obj_game_controller.deferred_tasks;
}