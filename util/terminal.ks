@LAZYGLOBAL off.

//
// Terminal
//

local empty_line_cache is "".
function empty_line {
  local width is terminal:width.

  if empty_line_cache:length <> width {
    set empty_line_cache to list_repeat(" ", width):join("").
  }

  return empty_line_cache.
}

global terminal_current_line is 0.

function terminal_clearscrn {
  clearscreen.
  set terminal_current_line to 0.
}

function terminal_clear {
  parameter line is terminal_current_line.
  print empty_line() at (0, line).
}

function terminal_print {
  parameter message.
  parameter line is terminal_current_line.

  terminal_clear(line).
  print message at (0, line).
  set terminal_current_line to clamp(line + 1, 0, terminal:height).
}

function terminal_wait {
  parameter message.
  parameter fn.

  // Check what kind of value we're checking.
  local value is fn().
  local done is false.
  local progress is "".

  if value:istype("scalar") {
    lock done to value <= 0.
    lock progress to round(value) + "s".
  } else if value:istype("boolean") {
    lock done to value.
    local dots is ".".
    local calculate_progress is throttle_fn(0.5, {
      if dots:length = 3 {
        set dots to ".".
      } else {
        set dots to dots + ".".
      }
      return dots.
    }).
    lock progress to calculate_progress().
  } else {
    die().
  }

  local iterate is {
    set value to fn().
    return done.
  }.

  // Keep track of current line so we can print over it.
  local line is terminal_current_line.
  until iterate() {
    terminal_print(message + ": " + progress, line).
    wait 0.
  }
  terminal_print(message + ": ✔", line).
}
