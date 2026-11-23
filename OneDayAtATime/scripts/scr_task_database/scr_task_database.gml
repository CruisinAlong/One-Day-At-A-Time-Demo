//I know this is your task but i did this so the day can start. 1 Placeholder event has been added so you can iterate as needed.

function task_database_get() {
    return [
        {
            id: 0,
            name: "placeholder_1",
            description: "this is the content of the event",
            prod_fx: 15,
            happy_fx: -5,
            relax_fx: -10,
            status: "available",      
            assigned_quadrant: ""     
        },
		{
            id: 1,
            name: "placeholder_2",
            description: "this is the content of the event",
            prod_fx: 15,
            happy_fx: -5,
            relax_fx: -10,
            status: "available",      
            assigned_quadrant: ""     
        },
		{
            id: 2,
            name: "placeholder_3",
            description: "this is the content of the event",
            prod_fx: 15,
            happy_fx: -5,
            relax_fx: -10,
            status: "available",      
            assigned_quadrant: ""     
        },
		{
            id: 3,
            name: "placeholder_4",
            description: "this is the content of the event",
            prod_fx: 15,
            happy_fx: -5,
            relax_fx: -10,
            status: "available",      
            assigned_quadrant: ""     
        }
    ];
}


function task_database_clone() {
    var _source = task_database_get();
    var _clone = [];
    for (var i = 0; i < array_length(_source); i++) {
        var _t = _source[i];
        array_push(_clone, {
            id: _t.id,
            name: _t.name,
            description: _t.description,
            prod_fx: _t.prod_fx,
            happy_fx: _t.happy_fx,
            relax_fx: _t.relax_fx,
            status: _t.status,
            assigned_quadrant: _t.assigned_quadrant
        });
    }
    return _clone;
}