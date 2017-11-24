@LAZYGLOBAL off.

//
// Functions that do various steering maneuvers.
//

// Set ship throttle to 0.
function kill_controls {
  WAIT 0.
  LOCK THROTTLE TO 0.
  UNLOCK THROTTLE.

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
  WAIT UNTIL SHIP:CONTROL:PILOTMAINTHROTTLE = 0.

  UNLOCK STEERING.
}

function target_antennas {
  parameter antenna_target.

  local antennas is ship:modulesnamed("ModuleRTAntenna").
  for antenna in antennas {
    antenna:setfield("target", antenna_target).
    antenna:doaction("activate", true).
  }
}
