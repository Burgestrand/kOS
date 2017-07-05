@LAZYGLOBAL off.

runoncepath("archive:bootstrap").

parameter nd is nextnode.

terminal_clear().
terminal_print("[node]").
terminal_print("ΔV: " + round(nd:deltav:mag) + "m/s").
terminal_print("Ap: " + round(nd:orbit:apoapsis) + ", Pe: " + round(nd:orbit:periapsis)).
terminal_print("Eccentricity: " + round(nd:orbit:eccentricity, 4)).

// Calculate how fast we can go.
local burn_time is maneuver_time(nd:deltav:mag).
terminal_print("Burn time: " + round(burn_time, 2) + "s").

lock steering to lookdirup(nd:deltav, ship:facing:topvector).
terminal_wait("Orienting", {
  return vdot(ship:facing:forevector, steering:forevector) >= 0.995.
}).

local current_line is terminal_current_line.
until nd:eta <= (burn_time / 2) {
  terminal_print("ETA: " + round(nd:eta - burn_time/2) + "s", current_line).
  wait 0.
}

terminal_print("Burning!").
local th is 1.          // throttle
local dv0 is nd:deltav. // initial ΔV
lock throttle to th.
until false {
    // If node is facing the opposite way it means we overshot.
    if vdot(dv0, nd:deltav) < 0 {
        break.
    }

    if nd:deltav:mag < 0.1 {
        wait until vdot(dv0, nd:deltav) < 0.5.
        break.
    }
}

kill_throttle().
unlock steering.
remove nd.
