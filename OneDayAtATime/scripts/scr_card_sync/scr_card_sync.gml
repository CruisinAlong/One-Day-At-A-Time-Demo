/// Destroys all existing obj_task_card instances and respawns
/// them to match the current available_tasks / quadrant_tasks data. Call
/// this any time those arrays change (assignment, return-to-available,
/// Q4 discard/defer, new day start).
function sync_task_cards() {
    with (obj_task_card) instance_destroy();

    with (obj_game_controller) {
        for (var i = 0; i < array_length(available_tasks); i++) {
            var _r = get_available_card_rect(i);
            var _inst = instance_create_layer(_r.x, _r.y, "Instances", obj_task_card);
            _inst.task = available_tasks[i];
            _inst.home_quadrant = "available";
        }

        var _keys = ["q1", "q2", "q3", "q4"];
        for (var k = 0; k < array_length(_keys); k++) {
            var _key = _keys[k];
            var _arr = quadrant_tasks[$ _key];
            var _total = array_length(_arr);
            for (var j = 0; j < _total; j++) {
                var _cr = get_quadrant_card_rect(_key, j, _total);
                var _inst2 = instance_create_layer(_cr.x, _cr.y, "Instances", obj_task_card);
                _inst2.task = _arr[j];
                _inst2.home_quadrant = _key;
            }
        }
    }
}


/// Spawns the DISCARD and DEFER button instances for the Q4
/// choice popup. Called automatically when a task is assigned to Q4.
function spawn_q4_popup_buttons() {
    destroy_transient_buttons();

    var _btn_w = 160;
    var _btn_h = 50;
    var _popup_cx = room_width / 2;
    var _popup_cy = room_height / 2;
    var _btn_y = _popup_cy + 50;

    var _discard = instance_create_layer(_popup_cx - _btn_w - 15, _btn_y, "Instances", obj_button);
    _discard.button_action = "discard";
    _discard.label = "DISCARD";

    var _defer = instance_create_layer(_popup_cx + 15, _btn_y, "Instances", obj_button);
    _defer.button_action = "defer";
    _defer.label = "DEFER";
}


/// Destroys all obj_button instances EXCEPT ones marked persistent_ui
/// (e.g. the always-visible END DAY button). Use this instead of a raw
/// "with (obj_button) instance_destroy()" anywhere popups/review buttons
/// need clearing, so persistent UI buttons survive.
function destroy_transient_buttons() {
    with (obj_button) {
        if (!persistent_ui) instance_destroy();
    }
}


/// Spawns the always-visible END DAY button once. Call this a single time
/// (from obj_game_controller's Create event) - it is never destroyed by
/// destroy_transient_buttons() since persistent_ui is set to true. It hides
/// itself while the day-review panel is open (see obj_button Draw/Step),
/// so there's only ever one obvious day-progression button visible at a time.
function spawn_end_day_button() {
    var _btn = instance_create_layer(1180, 32, "Instances", obj_button);
    _btn.button_action = "end_day";
    _btn.label = "END DAY";
    _btn.persistent_ui = true;
}


/// Returns the geometry of the end-of-day review panel, shared by both
/// spawn_day_review_ui() (button placement) and obj_game_controller's
/// Draw GUI event (panel/background/text rendering) so they always agree.
function get_day_review_panel_rect() {
    var _pw = 760;
    var _ph = 560;
    var _px = (room_width - _pw) / 2;
    var _py = (room_height - _ph) / 2;
    return { x: _px, y: _py, w: _pw, h: _ph };
}


/// Spawns the end-of-day review panel's interactive elements. Shows ONE
/// deferred task per page (with its full description, rendered in the
/// Draw GUI event) to avoid overlapping text when descriptions wrap to
/// multiple lines. Includes PREV/NEXT page navigation, a "Complete"
/// button for the task on the current page, and a "CLOSE & NEXT DAY"
/// button that is always available regardless of page. Safe to call
/// repeatedly (e.g. after completing a task) to refresh the current page.
function spawn_day_review_ui() {
    destroy_transient_buttons();

    with (obj_game_controller) {
        var _panel = get_day_review_panel_rect();
        var _btn_w = 220;
        var _btn_h = 44;

        var _count = array_length(deferred_tasks);

        // Clamp review_page in case the list shrank (e.g. last task completed).
        if (_count == 0) {
            review_page = 0;
        } else if (review_page >= _count) {
            review_page = _count - 1;
        }

        if (_count > 0) {
            var _task = deferred_tasks[review_page];

            // Complete button for the task on the current page.
            var _complete_btn = instance_create_layer(
                _panel.x + _panel.w - _btn_w - 40,
                _panel.y + _panel.h - _btn_h - 90,
                "Instances", obj_button
            );
            _complete_btn.button_action = "complete_deferred";
            _complete_btn.task = _task;
            _complete_btn.label = "Complete";

            // PREV / NEXT page navigation (only shown when relevant).
            if (review_page > 0) {
                var _prev_btn = instance_create_layer(
                    _panel.x + 40,
                    _panel.y + _panel.h - _btn_h - 90,
                    "Instances", obj_button
                );
                _prev_btn.button_action = "review_prev_page";
                _prev_btn.label = "< PREV";
            }

            if (review_page < _count - 1) {
                var _next_btn = instance_create_layer(
                    _panel.x + 40 + _btn_w + 20,
                    _panel.y + _panel.h - _btn_h - 90,
                    "Instances", obj_button
                );
                _next_btn.button_action = "review_next_page";
                _next_btn.label = "NEXT >";
            }
        }

        var _close_btn = instance_create_layer(
            _panel.x + (_panel.w - _btn_w) / 2,
            _panel.y + _panel.h - _btn_h - 24,
            "Instances", obj_button
        );
        _close_btn.button_action = "continue_day";
        _close_btn.label = "CLOSE & NEXT DAY";
    }
}