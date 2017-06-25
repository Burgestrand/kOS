// Safelty stage by temporarily reducing throttle, staging, and then throttling back.
function SAFE_STAGE {
  local previousThrottle IS THROTTLE.
  UNLOCK THROTTLE.

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
  STAGE.
  WAIT until STAGE:READY.

  LOCK THROTTLE TO previousThrottle.
}

// lock steering to a target, and wait until we're stable at that angle for X seconds.
function steer_to {
  parameter target.
  parameter stable_time is 2.

  local facing_correctly to {
    if not semi_equal(facing:roll, target:roll, 5) {
      return false.
    }
    if not semi_equal(facing:pitch, target:pitch, 1) {
      return false.
    }
    if not semi_equal(facing:yaw, target:yaw, 1) {
      return false.
    }
    return true.
  }.

  lock steering to target.

  local wait_start is time:seconds.
  until false {
    if facing_correctly:call() {
      local wait_time is time:seconds - wait_start.
      if wait_time >= stable_time  {
        break.
      }
    } else {
      set wait_start to time:seconds.
    }
    wait 0.
  }
}

// Auto-deploy antennas and solar thingies when entering/exiting the atmosphere.
function autodeploy {
  parameter action_group.
  on (ship:altitude > body:atm:height) {
    toggle action_group.
    return true.
  }
}

// Calculates how long it will take us to achieve a certain deltaV at max acceleration.
function maneuver_time {
  parameter deltaV.

  local engines IS filter(LIST_OF("ENGINES"), {
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
    // gravitational parameter
    local g IS SHIP:ORBIT:BODY:MU / (SHIP:ORBIT:BODY:RADIUS ^ 2).

    local isp IS engine_isp / engines:LENGTH. // specific impulse
    local ve IS g * isp. // effective exhaust velocity

    local e IS constant():e.
    local mf IS 1 - e^(-deltaV / ve). // propellant mass fraction

    local f IS engine_thrust * 1000. // enghine thrust (kg * m/s2)
    local m IS SHIP:MASS * 1000. // starting mass (kg)
    return g * m * isp * mf / f.
  }
}
