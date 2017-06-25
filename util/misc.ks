// Print a message to the screne.
function notifty {
  PARAMETER message.
  HUDTEXT("kOS: " + message, 5, 2, 50, YELLOW, false).
}

function CLAMP {
  PARAMETER number.
  PARAMETER min.
  PARAMETER max.
  return MAX(MIN(number, max), min).
}

function PRINT_PID {
  PARAMETER PID.
  CLEARSCREEN.
  print "ERROR: " + PID:ERROR.
  print "ERROSUM: " + PID:ERRORSUM.
  print "PTERM: " + PID:PTERM.
  print "ITERM: " + PID:ITERM.
  print "DTERM: " + PID:DTERM.
  print "CHANGERATE: " + PID:CHANGERATE.
}

function SIGNUM {
  PARAMETER number.
  if number > 0 {
    return 1.
  } else {
    return -1.
  }
}

function semi_equal {
  parameter a.
  parameter b.
  parameter difference.
  return abs(a - b) <= difference.
}.

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
