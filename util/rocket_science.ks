@LAZYGLOBAL off.

global kG is 6.67408e-11.
global kg0 is 9.80665.

function vis_viva {
  parameter altitude.
  parameter semimajor.

  local r is altitude + body:radius.
  local a is semimajor.

  return sqrt(body:mu * (2/r - 1/a)).
}

function semimajoraxis {
  parameter a is orbit:apoapsis.
  parameter p is orbit:periapsis.
  parameter b is body.

  local diameter is 2 * b:radius.

  return (a + p + diameter)/2.
}

// Calculates how long it will take us to achieve a certain deltaV at max acceleration.
function maneuver_time {
  parameter deltaV.

  local engines IS Enum["select"](LIST_OF("ENGINES"), {
    parameter engine.
    return engine:ignition AND NOT engine:flameout.
  }).

  local engine_thrust IS 0.
  local engine_isp IS 0.
  for engine in engines {
    SET engine_thrust TO engine_thrust + engine:AVAILABLETHRUST.
    SET engine_isp TO engine_isp + engine:ISPAT(0).
  }

  if engine_thrust = 0 OR engine_isp = 0 {
    return -1.
  } else {
    local isp IS engine_isp / engines:LENGTH. // specific impulse
    local ve IS kg0 * isp. // effective exhaust velocity
    local mf IS 1 - constant:e^(-deltaV / ve). // propellant mass fraction

    local f IS engine_thrust * 1000. // enghine thrust (kg * m/s2)
    local m IS SHIP:MASS * 1000. // starting mass (kg)

    return kg0 * m * isp * mf / f.
  }
}
