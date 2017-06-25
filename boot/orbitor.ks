local wait_stationary IS true.
RUNONCEPATH("0:bootstrap", wait_stationary).

WHEN ROUND(MAXTHRUST) = 0 THEN {
  print "No thrust available. Staging!".
  SAFE_STAGE().
  return (LIST_OF("ENGINES"):LENGTH > 0).
}

ON (SHIP:ALTITUDE > SHIP:ORBIT:BODY:ATM:HEIGHT) {
  print "Outside atmosphere!".
  TOGGLE AG1.
  return true.
}

// Section: Gravity turn, using boosters so no throttle necessary.
print "Using boosters for gravity turn.".
LOCK THROTTLE TO 0.
UNTIL SHIP:ORBIT:APOAPSIS > (SHIP:ORBIT:BODY:ATM:HEIGHT * 1.10) {
  local angle IS 90 - ((SHIP:ALTITUDE / SHIP:ORBIT:BODY:ATM:HEIGHT) * 90).
  local min_angle IS 10.
  LOCK STEERING TO HEADING(90, MAX(MIN(angle, 90), min_angle)).
}
print "Apoapsis above atmosphere! Waiting for circular burn.".

// Apiapsis is high enough, wait until we're outside the atmosphere.
print "Steering for orbital maneuver and waiting for stability.".
steer_to(HEADING(90, 0)).
print "Orbital maneuver steering stable.".

print "Waiting to exit atmosphere.".
until ship:altitude > body:atm:height {
  wait 0.
}

// Section: Orbit burn.
local g IS SHIP:ORBIT:BODY:MU / (SHIP:ORBIT:BODY:RADIUS ^ 2).
local orbital_velocity IS ship:body:radius * sqrt(g/(ship:body:radius + ship:apoapsis)).
local deltaA IS maxthrust/mass.
local apoapsis_velocity IS sqrt(ship:body:mu * ((2/(ship:body:radius + apoapsis))-(1/ship:obt:semimajoraxis))).
local deltaV IS (orbital_velocity - apoapsis_velocity).
local time_to_burn IS deltaV/deltaA.

local burn_start is time_to_burn/2.
print "Waiting for ETA:APOAPSIS <= " + burn_start + "s.".
wait until (eta:apoapsis <= burn_start).

print "Circularizing.".
local circular is pidloop(1, 0, 1).
set circular:setpoint to ship:apoapsis.

LOCAL th IS 1.
LOCK THROTTLE TO th.
// TODO: Make this more stable.
until semi_equal(ship:apoapsis, ship:periapsis, 500) {
  print_pid(circular).
  local updated_th is clamp(circular:update(time:seconds, ship:periapsis), 0, 1).
  print "throttle: " + updated_th.
  SET th TO updated_th.
  LOCK STEERING TO HEADING(90, 0).
  wait 0.
}

LOCK THROTTLE TO 0.
print "Orbit achieved! Exiting.".
