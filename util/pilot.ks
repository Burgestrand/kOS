@LAZYGLOBAL off.

// Set ship throttle to 0.
function kill_throttle {
  WAIT 0.
  LOCK THROTTLE TO 0.
  UNLOCK THROTTLE.
  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
  WAIT UNTIL SHIP:CONTROL:PILOTMAINTHROTTLE = 0.
}