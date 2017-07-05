@LAZYGLOBAL off.

function die {
  return 1/0.
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
