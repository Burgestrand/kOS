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
  return ((a + b:radius) + (p + b:radius))/2.
}

function orbital_period {
  parameter a is orbit:apoapsis.
  parameter p is orbit:periapsis.
  parameter b is body.

  local x is semimajoraxis(a, p, b).
  return 2 * constant:pi * sqrt(x^3 / b:mu).
}

function geostationary_altitude {
  parameter b is body.

  local t is b:rotationperiod.
  local altitude is ((b:mu * t^2) / (4 * constant:pi^2))^(1/3).

  return altitude - b:radius.
}

function body_g {
  parameter altitude.
  parameter b is body.
  return b:mu / (altitude + b:radius)^2.
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

// This function calculates the direction a ship must travel to achieve the target inclination,
// given the current ship's latitude and orbital velocity.
function azimuth {
	parameter target_inclination.

	// find orbital velocity for a circular orbit at the current altitude.
	local V_orb is vis_viva(altitude, semimajoraxis(altitude, altitude)).

	// project desired orbit onto surface heading
	local az_orb is arcsin(min(cos(target_inclination) / cos(ship:latitude), 1)).
	if (target_inclination < 0) {
		set az_orb to 180 - az_orb.
	}

	// create desired orbit velocity vector
	local V_star is heading(az_orb, 0) * v(0, 0, V_orb).

	// find horizontal component of current orbital velocity vector
	local V_ship_h is ship:velocity:orbit - vdot(ship:velocity:orbit, up:vector) * up:vector.

	// calculate difference between desired orbital vector and current (this is the direction we go)
	local V_corr is V_star - V_ship_h.

	// project the velocity correction vector onto north and east directions
	local vel_n is vdot(V_corr, ship:north:vector).
	local vel_e is vdot(V_corr, heading(90,0):vector).

	// calculate compass heading
	local az_corr is arctan2(vel_e, vel_n).
	return az_corr.
}
