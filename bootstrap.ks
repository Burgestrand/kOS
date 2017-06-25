PARAMETER wait_stationary IS false.

local indent IS 0.
function measure {
  parameter message.
  parameter block.

  local spaces is "".
  FROM {local x is indent.} UNTIL x = 0 STEP {set x to x-1.} DO {
    set spaces to spaces + "  ".
  }
  local start is TIME:SECONDS.
  print spaces + message + "...".
  set indent to indent + 1.
  block:call().
  set indent to indent - 1.
  print spaces + message + ": " + ROUND(TIME:SECONDS - start, 2) + "s.".
}

measure("[Bootstrap]", {
  if wait_stationary {
    measure("Waiting until stationary", {
      LOCAL velocity IS 0.
      LOCK velocity TO ROUND(SHIP:VELOCITY:SURFACE:MAG, 2).
      WAIT until velocity = 0.
    }).
  }

  measure("Loading utilities", {
    RUNONCEPATH("0:util/functional").
    RUNONCEPATH("0:util/math").
    RUNONCEPATH("0:util/misc").
    RUNONCEPATH("0:util/rocket").
  }).
}).
