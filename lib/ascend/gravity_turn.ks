@LAZYGLOBAL off.

parameter target_inclination is 0.

local ascent_complete is false.
lock ascent_complete to ship:apoapsis > 80000.

if hastarget {
  lock ascent_complete to ship:apoapsis > target:orbit:periapsis.
  set target_inclination to target:orbit:inclination.
}

function target_heading {
  parameter pitch.
  return heading(azimuth(target_inclination), pitch).
}

runoncepath("archive:bootstrap").

local steering_mode is "start".

local pivot_target is r(0, 0, 0).
local pivot_deadline is 0.

local degrees_from_north is 0.

local steering_line is terminal_current_line.
until ascent_complete {
  terminal_print("[Gravity turn: " + steering_mode + "]", steering_line).

  if steering_mode = "start" {
    lock steering to target_heading(90).
    set steering_mode to "wait for pivot".
  } else if steering_mode = "wait for pivot" {
    if ship:altitude > 2000 or ship:velocity:surface:mag > 60 {
      set pivot_target to target_heading(85).
      lock steering to pivot_target.
      set steering_mode to "pivoting".
    }
  } else if steering_mode = "pivoting" {
    terminal_print("Current heading: " + navball_heading()).
    local angle is round(vectorangle(pivot_target:forevector, ship:srfretrograde:forevector), 0).
    if angle = 0 {
      if pivot_deadline = 0 {
        set pivot_deadline to time:seconds + 2.
      } else if time:seconds > pivot_deadline {
        set steering_mode to "ship:srfprograde".
      }
    } else if ship:altitude > 2500 {
      // Timeout, no more time for turning.
      set steering_mode to "ship:srfprograde".
    } else {
      set pivot_deadline to 0.
    }
  } else if steering_mode = "ship:srfprograde" {
    lock steering to ship:srfprograde.
    if ship:apoapsis > 70000 {
      set steering_mode to "ship:prograde".
    }
  } else if steering_mode = "ship:prograde" {
      lock steering to ship:prograde.
  }

  wait 0.
}

kill_controls().
