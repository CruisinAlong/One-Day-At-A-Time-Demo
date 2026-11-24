/// obj_quadrant_panel - Create Event
/// quadrant_key is set via Room Editor Creation Code (just the key string,
/// nothing that depends on obj_game_controller.layout - that's computed
/// safely in Step instead, since Create event ordering between different
/// instances isn't guaranteed).

quadrant_key = "q1";
zone_x = 0;
zone_y = 0;
zone_w = 0;
zone_h = 0;
depth = 100;
zone_initialized = false;