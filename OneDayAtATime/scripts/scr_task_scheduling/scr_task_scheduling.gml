/// Q3 scheduling and Q4 discard/defer storage.
/// This is the integration point another developer should call into when
/// starting a new day (retrieve_carried_over_tasks is already wired into
/// game_start_new_day in scr_game_logic, so no extra call is needed there).

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


/// Called when the player chooses "Defer" during Q4 resolution.
/// Removes the task from the Q4 slot, swaps its current* fields over to the
/// deferred variant (title/description/P/H/R), and stores it in
/// deferred_tasks so it sits in the persistent Deferred Task Stack until
/// the player either completes it (complete_deferred_task) or it is
/// discarded. Unlike Q3's scheduled_tasks, deferred_tasks is NOT folded
/// back into available_tasks at the start of each new day - it
/// accumulates across days until the player addresses each task directly
/// from the end-of-day review panel.
function defer_task_q4(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);

        _task.status = "deferred";

        _task.currentTitle = _task.deferredTitle;
        _task.currentDesc = _task.deferredDesc;
        _task.currentP = _task.deferredP;
        _task.currentH = _task.deferredH;
        _task.currentR = _task.deferredR;

        array_push(deferred_tasks, _task);

        show_debug_message("[Q4 Skipping] '" + _task.currentTitle + "' deferred to the next day.");
    }
}


/// Called when the player chooses "Discard" during Q4 resolution.
/// Removes the task from the Q4 slot and permanently removes it from play.
function discard_task_q4(_task) {
    with (obj_game_controller) {
        remove_task_from_all_locations(_task);

        _task.status = "discarded";

        array_push(discarded_tasks, _task);

        show_debug_message("[Q4 Discarding] '" + _task.currentTitle + "' discarded permanently.");
    }
}

/// Pulls Q3's scheduled tasks back into the general available pool at the
/// start of a new day, marking each one as locked_to_q1q2 so the player
/// cannot drag it back into Q3 or Q4 - since it was already scheduled
/// ("do it tomorrow") from a previous day, it must now be resolved as
/// urgent+important or not-urgent+important instead of being scheduled or
/// skipped again. Deferred (Q4) tasks are intentionally NOT touched here -
/// they remain in the persistent deferred_tasks stack (the Deferred Task
/// Stack) until the player completes them via the end-of-day review panel,
/// so the stack correctly accumulates across multiple days if left
/// unaddressed.
function retrieve_carried_over_tasks() {
    with (obj_game_controller)
    {
        var _count = 0;

        // Retrieve Q3 scheduled tasks back into the available pool, locked
        // out of Q3/Q4.
        for (var i = 0; i < array_length(scheduled_tasks); i++)
        {
            var _task = scheduled_tasks[i];

            _task.isQ3 = false;
            _task.isQ4 = false;
            _task.status = "available";
            _task.assignedQuadrant = "";
            _task.locked_to_q1q2 = true;

            array_push(available_tasks, _task);
            _count++;
        }

        scheduled_tasks = [];

        show_debug_message("[Task Retrieval] Returned " + string(_count) + " carried-over task(s) to the available pool, locked out of Q3/Q4. Deferred Task Stack currently holds " + string(array_length(deferred_tasks)) + " task(s).");
    }
}

function get_scheduled_tasks() {
    return obj_game_controller.scheduled_tasks;
}

function get_deferred_tasks() {
    return obj_game_controller.deferred_tasks;
}


/// Called when the player presses "End Day". If there are still tasks
/// sitting in Q4, this pops up the DISCARD/DEFER choice for the first one
/// (reusing the existing Q4 popup UI) and returns - resolving that choice
/// (see obj_button/Mouse_4.gml "discard"/"defer" cases) re-calls
/// end_day_and_review(), so the player is walked through each remaining
/// Q4 task one at a time. Once Q4 is empty, applies stat consequences for
/// every task placed in Q1/Q2, then opens the end-of-day review UI so the
/// player can address any deferred tasks before the next day begins.
function end_day_and_review() {
    var _q4_has_tasks = false;

    with (obj_game_controller) {
        if (array_length(quadrant_tasks.q4) > 0) {
            _q4_has_tasks = true;
            q4_choice_active = true;
            q4_choice_task = quadrant_tasks.q4[0];
        }
    }

    if (_q4_has_tasks) {
        spawn_q4_popup_buttons();
        return;
    }

    with (obj_game_controller) {
        apply_placed_task_effects();
        day_review_active = true;
    }

    sync_task_cards();
    spawn_day_review_ui();
}



/// Applies stat consequences for every task currently placed in Q1 or Q2
/// (the quadrants resolved immediately, as opposed to Q3 which carries
/// over and Q4 which was just deferred above). Q1/Q2 tasks are cleared
/// from their quadrants afterward since their effects have been resolved.
function apply_placed_task_effects() {
    with (obj_game_controller) {
        var _keys = ["q1", "q2"];
        for (var k = 0; k < array_length(_keys); k++) {
            var _arr = quadrant_tasks[$ _keys[k]];
            for (var i = 0; i < array_length(_arr); i++) {
                var _task = _arr[i];
                stat_modify("productivity", _task.currentP);
                stat_modify("happiness", _task.currentH);
                stat_modify("relaxation", _task.currentR);

                show_debug_message("[Stat Effects] '" + _task.currentTitle + "' applied P:" + string(_task.currentP) + " H:" + string(_task.currentH) + " R:" + string(_task.currentR));
            }
            quadrant_tasks[$ _keys[k]] = [];
        }
    }
}


/// Called when the player chooses to address (complete) a deferred task
/// during the end-of-day review. Removes it from the persistent deferred
/// stack and applies its (deferred-variant) stat consequences.
function complete_deferred_task(_task) {
    with (obj_game_controller) {
        var _idx = task_array_find_index(deferred_tasks, _task);
        if (_idx != -1) array_delete(deferred_tasks, _idx, 1);

        stat_modify("productivity", _task.currentP);
        stat_modify("happiness", _task.currentH);
        stat_modify("relaxation", _task.currentR);

        show_debug_message("[Deferred Task Completed] '" + _task.currentTitle + "' addressed and removed from the deferred stack. Applied P:" + string(_task.currentP) + " H:" + string(_task.currentH) + " R:" + string(_task.currentR));
    }
}