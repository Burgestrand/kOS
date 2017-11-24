@LAZYGLOBAL off.

parameter rcs_adjust is false.

runoncepath("archive:bootstrap").

sas off.

parameter nd is nextnode.

terminal_print("[node]").
terminal_print("ΔV: " + round(nd:deltav:mag) + "m/s").
terminal_print("Ap: " + round(nd:orbit:apoapsis) + ", Pe: " + round(nd:orbit:periapsis)).
terminal_print("Eccentricity: " + round(nd:orbit:eccentricity, 4)).

// Calculate how fast we can go.
local burn_duration is maneuver_time(nd:deltav:mag).
terminal_print("Burn time: " + round(burn_duration, 2) + "s").

lock steering to lookdirup(nd:deltav, ship:facing:topvector).
local facing_timeout is 0.
terminal_wait("Orienting", {
  if (nd:eta <= burn_duration / 2) {
    return true.
  }

  if vdot(ship:facing:forevector, steering:forevector) >= 0.995 {
    if facing_timeout = 0 {
      // Hold direction for 2 seconds.
      set facing_timeout to time:seconds + 2.
      return false.
    } else {
      return (time:seconds > facing_timeout).
    }
  } else {
    set facing_timeout to 0.
    return false.
  }
}).

local burn_time is time:seconds + nd:eta - (burn_duration / 2).

kuniverse:TimeWarp:WARPTO(burn_time - 30).
terminal_wait("Waiting for burn", {
  return burn_time - time:seconds.
}).

// Burn using main engines.
local th is 1.          // throttle
local dv0 is nd:deltav. // initial ΔV
local dvMin is dv0.
local done is false.
lock throttle to th.
until done {
  if ship:maxthrust <> 0 {
    set th to clamp(nd:deltav:mag / (ship:maxthrust/ship:mass), 0, 1).
  } else {
    set th to 1.
  }

  // Burn time increased, so we're off target.
  if round(nd:deltav:mag) < round(dvMin:mag) {
    set dvMin to nd:deltav.
  } else if round(nd:deltav:mag) > round(dvMin:mag) {
    terminal_print("Aborting burn due to ΔV increasing.").
    break.
  }

  if vdot(dv0, nd:deltav) < 0 {
    terminal_print("Aborting burn due to node facing opposite way from original.").
    set done to true.
  }

  if nd:deltav:mag < 0.2 {
    terminal_print("Aborting burn due to being very close.").
    set done to true.
  }

  wait 0.
}

kill_controls().

// Make fine adjustments using RCS for at most 10 seconds.
if done and rcs_adjust and nd:deltav:mag > 0.1 {
  rcs on.

  local tend is time:seconds + 10.
  terminal_wait("Fine-tuning node burn using RCS", {
    if nd:deltav:mag < 0.1 {
      return 0.
    } else {
      local translate is v(
        vdot(nd:deltav, ship:facing:starvector),
        vdot(nd:deltav, ship:facing:topvector),
        vdot(nd:deltav, ship:facing:forevector)
      ).

      set ship:control:translation to translate:normalized.
      return tend - time:seconds.
    }
  }).

  set ship:control:translation to v(0, 0, 0).
  rcs off.
}

kill_controls().
remove nd.
