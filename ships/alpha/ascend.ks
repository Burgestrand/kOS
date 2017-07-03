@LAZYGLOBAL off.

parameter altitude is body:atm:height * 1.1.

terminal_print("Ascension to " + round(altitude) + "m starting!").

// Lock steering to a function of altitude.
local desired_angle is 90.
lock STEERING to heading(90, desired_angle).
lock THROTTLE to 1.

// Enable main rockets
stage.
wait until stage:ready.

until ship:apoapsis > altitude {
  set desired_angle to clamp(90 * (1 - ((ship:altitude * 1.5) / body:atm:height)), 5, 90).
  wait 0.
}

kill_throttle().
