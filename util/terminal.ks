@LAZYGLOBAL off.

local empty_line_cache is "".
function empty_line {
  local width is terminal:width.

  if empty_line_cache:length <> width {
    set empty_line_cache to "".
    until empty_line_cache:length >= width {
      set empty_line_cache to empty_line_cache + " ".
    }
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
  set terminal_current_line to line + 1.
}
