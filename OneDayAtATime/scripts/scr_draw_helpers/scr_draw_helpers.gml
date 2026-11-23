/// Draws an unfilled rectangle outline with the given pixel thickness

function draw_rectangle_border_width(_x1, _y1, _x2, _y2, _width) {
    for (var i = 0; i < _width; i++) {
        draw_rectangle(_x1 + i, _y1 + i, _x2 - i, _y2 - i, true);
    }
}