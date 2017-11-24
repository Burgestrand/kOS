@LAZYGLOBAL off.

function die {
  return 1/0.
}

function time_format {
  parameter seconds.

  local one_day is body("Kerbin"):rotationperiod.
  local one_hour is 60 * 60.
  local one_minute is 60.

  local current is seconds.

  // Calculate days
  local days is floor(current / one_day).
  set current to current - (days * one_day).

  // Calculate hours
  local hours is floor(current / one_hour).
  set current to current - (hours * one_hour).

  // Calculate minutes
  local minutes is floor(current / one_minute).
  set current to current - (minutes * one_minute).

  local seconds is round(current, 2).

  local output is "".
  set output to output + days + "d".
  set output to output + hours + "h".
  set output to output + minutes + "m".
  set output to output + seconds + "s".
  return output.
}

function time_parse {
  parameter days.
  parameter hours.
  parameter minutes.
  parameter seconds.

  local days_s is days * body("Kerbin"):rotationperiod.
  local hours_s is hours * 60 * 60.
  local minutes_s is minutes * 60.

  return days_s + hours_s + minutes_s + seconds.
}

function list_repeat {
  parameter element.
  parameter count.

  local lst is list().
  until lst:length >= count {
    lst:add(element).
  }
  return lst.
}

function unsafely {
  parameter fn.

  local safe is config:safe.
  set config:safe to false.
  local value is fn().
  set config:safe to safe.
  return value.
}

// Returns a function that runs at most every `duration`s.
function throttle_fn {
  parameter duration.
  parameter fn.

  local last_call is -duration.
  local last_value is 0.
  return {
    if (time:seconds - last_call) >= duration {
      set last_call to time:seconds.
      set last_value to fn().
      return last_value.
    } else {
      return last_value.
    }
  }.
}

function PRINT_PID {
  PARAMETER PID.
  CLEARSCREEN.

  print "P: " + PID:ERROR + " (" + PID:PTERM + ")".
  if PID:KI <> 0 {
    print "I: " + PID:ITERM / PID:KI + " (" + PID:ITERM + ")".
  } else {
    print "I: 0".
  }
  print "D: " + PID:CHANGERATE + " (" + PID:DTERM + ")".
  print "ERROSUM: " + PID:ERRORSUM.
  print "SETPOINT: " + PID:SETPOINT.
  print "INPUT: " + PID:INPUT.
  print "OUTPUT: " + PID:OUTPUT.
}

// Convert the built in LIST INTO X to a function.
function LIST_OF {
  PARAMETER type.

  local output IS LIST().
  if type = "Bodies" {
    LIST Bodies in output.
  } else if type = "Targets" {
    LIST Targets in output.
  } else if type = "Processors" {
    LIST Processors in output.
  } else if type = "Resources" {
    LIST Resources in output.
  } else if type = "Parts" {
    LIST Parts in output.
  } else if type = "Engines" {
    LIST Engines in output.
  } else if type = "Sensors" {
    LIST Sensors in output.
  } else if type = "Elements" {
    LIST Elements in output.
  } else if type = "DockingPorts" {
    LIST DockingPorts in output.
  } else if type = "Files" {
    LIST Files in output.
  } else if type = "Volumes" {
    LIST Volumes in output.
  } else {
    "What the hell?".
  }

  return output.
}
