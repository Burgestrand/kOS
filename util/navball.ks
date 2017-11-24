@LAZYGLOBAL off.

// @see https://github.com/KSP-KOS/KSLib/blob/master/library/lib_navball.ks

function navball_east {
  parameter ves.

  return vcrs(ves:up:vector, ves:north:vector).
}

function navball_heading {
  parameter ves is ship.

  local pointing is ves:facing:forevector.
  local east is navball_east(ves).

  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).

  local result is arctan2(trig_y, trig_x).

  if result < 0 {
    return 360 + result.
  } else {
    return result.
  }
}
