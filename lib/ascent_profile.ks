@LAZYGLOBAL off.

runoncepath("archive:bootstrap").

parameter altitude.

terminal_print("Ascension to " + round(altitude) + "m starting!").

// Lock steering to a function of altitude.
local desired_angle is 90.
lock STEERING to heading(90, desired_angle).
lock THROTTLE to 1.

until ship:apoapsis > altitude {
  set desired_angle to clamp(90 * (1 - ((ship:altitude * 1.25) / body:atm:height)), 5, 90).
  wait 0.
}

kill_throttle().
