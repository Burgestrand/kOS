@LAZYGLOBAL off.

PARAMETER wait_stationary IS (ship:status = "landed").

local indent is 0.
function measure {
  parameter message.
  parameter block.

  local spaces is "".
  until spaces:length = (indent * 2) {
    set spaces to spaces + "  ".
  }

  local start is TIME:SECONDS.
  print spaces + message + "...".
  set indent to indent + 1.
  block:call().
  set indent to indent - 1.
  print spaces + message + ": " + ROUND(TIME:SECONDS - start, 2) + "s.".
}

//Open the terminal for the user.
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

measure("[Bootstrap]", {
  if wait_stationary {
    measure("Waiting until stationary", {
      LOCAL velocity IS 0.
      LOCK velocity TO ROUND(SHIP:VELOCITY:SURFACE:MAG, 2).
      WAIT until velocity = 0.
    }).
  }

  measure("Loading utilities", {
    RUNONCEPATH("0:util/enum").
    RUNONCEPATH("0:util/maneuver").
    RUNONCEPATH("0:util/math").
    RUNONCEPATH("0:util/misc").
    RUNONCEPATH("0:util/pilot").
    RUNONCEPATH("0:util/terminal").
    RUNONCEPATH("0:util/triggers").
  }).
}).
