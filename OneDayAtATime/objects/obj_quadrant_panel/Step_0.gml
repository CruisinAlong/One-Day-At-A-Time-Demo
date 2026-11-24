/// obj_quadrant_panel - Step Event
/// Computes the zone rect once, safely after every instance's Create event
/// (including obj_game_controller's) has already run.

if (!zone_initialized) {
    var _r = get_quadrant_rect(quadrant_key);
    zone_x = _r.x;
    zone_y = _r.y;
    zone_w = _r.w;
    zone_h = _r.h;
    x = zone_x;
    y = zone_y;
    zone_initialized = true;
}