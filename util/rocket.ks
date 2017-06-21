// Safelty stage by temporarily reducing throttle, staging, and then throttling back.
function SAFE_STAGE {
  local previousThrottle IS THROTTLE.
  UNLOCK THROTTLE.

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
  STAGE.
  WAIT until STAGE:READY.

  LOCK THROTTLE TO previousThrottle.
}

// Retrieve all engines in a specific stage.
function STAGE_ENGINES {
  PARAMETER stageNumber IS STAGE:NUMBER.

  local engines IS LIST().
  LIST ENGINES in engines.

  local result IS LIST().
  for engine in engines {
    if engine:STAGE = stageNumber {
      result:add(engine).
    }
  }
  return result.
}

// Retrieve all parts in a specific stage.
function STAGE_PARTS {
  PARAMETER stageNumber IS STAGE:NUMBER.

  local parts IS LIST().
  LIST PARTS in parts.

  local result IS LIST().
  for part in parts {
    if part:STAGE = stageNumber {
      result:add(part).
    }
  }
  return result.
}

// Retrieve the total mass for a specific stage.
function STAGE_TOTAL_MASS {
  PARAMETER stageNumber IS STAGE:NUMBER.

  local mass IS 0.

  local parts IS LIST().
  LIST PARTS IN parts.
  for part in parts {
    if part:STAGE <= stageNumber {
      SET mass TO mass + part:MASS.
    }
  }
  return mass.
}

// Retrive the dry mass of a specific stage.
function STAGE_TOTAL_DRYMASS {
  PARAMETER stageNumber IS STAGE:NUMBER.

  local mass IS STAGE_TOTAL_MASS(stageNumber).

  // Remove the difference of wet/dry mass from current stage.
  local parts IS STAGE_PARTS(stageNumber).
  for part in parts {
    SET mass TO mass - (part:WETMASS - part:DRYMASS).
  }

  return mass.
}

// Retrieve the total specific impulse if all engines fired in a stage.
function STAGE_ISP {
  PARAMETER stageNumber IS STAGE:NUMBER.
  PARAMETER pressure IS 0. // Vacuum

  local engines IS STAGE_ENGINES(stageNumber).
  local totalISP IS 0.
  for engine in engines {
    SET totalISP TO totalISP + engine:ISPAT(pressure).
  }
  return totalISP.
}

// Retrieve the available delta V for a specific stage.
function STAGE_DELTAV {
  PARAMETER stageNumber IS STAGE:NUMBER.
  PARAMETER pressure IS 0. // Vacuum

  //
  local g is 9.81.
  local v0 IS STAGE_ISP(stageNumber, pressure) * g.
  local m0 IS STAGE_TOTAL_MASS(stageNumber).
  local m1 IS STAGE_TOTAL_DRYMASS(stageNumber).

  return v0 * LN(m0 / m1).
}
