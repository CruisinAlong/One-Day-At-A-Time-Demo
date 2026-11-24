
function TaskData(idVal, normalTitleVal, deferredTitleVal, normalPVal, normalHVal, normalRVal,
    deferredPVal, deferredHVal, deferredRVal, normalDescVal, deferredDescVal) constructor
{
    taskId = idVal;

    // Normal task data
    normalTitle = normalTitleVal;
    normalDesc = normalDescVal;

    normalP = normalPVal;
    normalH = normalHVal;
    normalR = normalRVal;

    // Deferred task data
    deferredTitle = deferredTitleVal;
    deferredDesc = deferredDescVal;

    deferredP = deferredPVal;
    deferredH = deferredHVal;
    deferredR = deferredRVal;

    // Current task data
    currentTitle = normalTitle;
    currentDesc = normalDesc;

    currentP = normalP;
    currentH = normalH;
    currentR = normalR;

	status = "available";
	assignedQuadrant = "";
    // Quadrant flags
    isQ3 = false;
    isQ4 = false;
}

// Parse CSV line
function TaskParseCSVLine(line)
{
    var fields = [];
    var currentField = "";
    var insideQuotes = false;

    for (var i = 1; i <= string_length(line); i++)
    {
        var char = string_char_at(line, i);

        if (char == "\"")
        {
            if (insideQuotes && i < string_length(line)
                && string_char_at(line, i + 1) == "\"")
            {
                currentField += "\"";
                i++;
            }
            else
            {
                insideQuotes = !insideQuotes;
            }
        }
        else if (char == "," && !insideQuotes)
        {
            array_push(fields, currentField);
            currentField = "";
        }
        else
        {
            currentField += char;
        }
    }

    array_push(fields, currentField);

    return fields;
}

function TaskRemovePrefix(description, prefix)
{
    if (string_copy(description, 1, string_length(prefix)) == prefix)
    {
        description = string_delete(description, 1, string_length(prefix));
    }

    return string_trim(description);
}

// Load tasks from CSV

function TaskDatabase()
{
    global.taskList = [];

    show_debug_message("========== TASK DATABASE ==========");
    show_debug_message("Opening Task List.csv...");

    var file = file_text_open_read("Task List.csv");

    if (file == -1)
    {
        show_debug_message("ERROR: Could not open Task List.csv");
        return;
    }

    show_debug_message("CSV opened successfully.");

    // Skip column headers
    file_text_readln(file);

    var taskIndex = 0;

    while (!file_text_eof(file))
    {
        var line = file_text_readln(file);

        if (string_length(string_trim(line)) > 0)
        {
            var fields = TaskParseCSVLine(line);

            if (array_length(fields) >= 10)
            {
                var task = new TaskData(
                    taskIndex,

                    // Task titles
                    string_trim(fields[0]),
                    string_trim(fields[1]),

                    // Normal P, H, R
                    real(fields[2]),
                    real(fields[3]),
                    real(fields[4]),

                    // Deferred P, H, R
                    real(fields[5]),
                    real(fields[6]),
                    real(fields[7]),

                    // Descriptions
                    TaskRemovePrefix(fields[8], "Normal:"),
                    TaskRemovePrefix(fields[9], "Deferred:")
                );

                array_push(global.taskList, task);

                show_debug_message(
                    "Loaded: " + task.currentTitle
                );

                taskIndex++;
            }
            else
            {
                show_debug_message(
                    "WARNING: Invalid CSV row. Columns found: "
                    + string(array_length(fields))
                );
            }
        }
    }

    file_text_close(file);

    show_debug_message("-----------------------------------");
    show_debug_message(
        "TOTAL TASKS LOADED: "
        + string(array_length(global.taskList))
    );
    show_debug_message("========== DATABASE END ==========");
}


// Set normal task data
function TaskSetNormal(task)
{
    task.currentTitle = task.normalTitle;
    task.currentDesc = task.normalDesc;

    task.currentP = task.normalP;
    task.currentH = task.normalH;
    task.currentR = task.normalR;
}


// Set deferred task data
function TaskSetDeferred(task)
{
    task.currentTitle = task.deferredTitle;
    task.currentDesc = task.deferredDesc;

    task.currentP = task.deferredP;
    task.currentH = task.deferredH;
    task.currentR = task.deferredR;
}

function TaskDatabaseClone()
{
    var clone = [];

    for (var i = 0; i < array_length(global.taskList); i++)
    {
        var source = global.taskList[i];

        var task = new TaskData(
            source.taskId,

            source.normalTitle,
            source.deferredTitle,

            source.normalP,
            source.normalH,
            source.normalR,

            source.deferredP,
            source.deferredH,
            source.deferredR,

            source.normalDesc,
            source.deferredDesc
        );

        array_push(clone, task);
    }

    return clone;
}
