@LAZYGLOBAL off.

parameter nd is nextnode.
runpath("archive:bootstrap").

clearscreen.
terminal_print("Node in: " + round(nd:eta) + "s, ΔV: " + round(nd:deltav:mag) + "m/s").

terminal_print("Orienting to node...").
lock steering to lookdirup(nd:deltav, ship:facing:topvector).
wait until vdot(ship:facing:forevector, steering:forevector) >= 0.995.
terminal_print("Orientation complete").

// Calculate how fast we can go.
local burn_time is maneuver_time(nd:deltav:mag).
terminal_print("Burn time: " + round(burn_time, 2) + "s").

terminal_print("Coasting to node!").
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
