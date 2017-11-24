switch to archive.
runpath("archive:bootstrap").

clearscreen.

local target_body is body(terminal_prompt("Target body")).
local desired_altitude is terminal_prompt("Desired altitude"):tonumber().

local satellites is 3.
local energyUsage is 0.6.

local desired_radius is desired_altitude + target_body:radius.
local desired_period is sqrt((desired_radius^3 * 4 * constant:pi^2) / target_body:mu).
local deploy_period is desired_period * (satellites - 1)/satellites.

// Calculate time in shadow
local h is sqrt(desired_radius * target_body:mu).
local td is (2 * desired_radius^2) / h * arcsin(target_body:radius / desired_radius) * constant:DegToRad.

// Calculate maximum distance between satellites
local angle is 360 / satellites.
local va is v(desired_radius, 0, 0).
local vb is v(va:x * cos(angle) - va:y * sin(angle), va:y * cos(angle) + va:x * sin(angle), 0).
local vc is va - vb.

until false {
  clearscreen.

  print("Network info:").
  print("  Body: " + target_body:name).
  print("  Number of satellites: " + satellites).
  print("  Desired altitude: " + round(desired_altitude / 1e3, 2) + "km").
  print("  Desired period: " + round(desired_period) + "s").
  print("  Deploy period: " + round(deploy_period) + "s").
  print("  Required power: " + round(td * energyUsage)).
  print("  Maximum distance: " + round(vc:mag / 1e3, 2) + "km").
  print("  Time in shadow: " + round(td) + "s").
  print("").
  print("Current status:").
  print("  ETA Apoapsis: " + round(eta:apoapsis, 2) + "s").
  print("  Apoapsis: " + round(orbit:apoapsis) + "m (" + round(desired_altitude - orbit:apoapsis) + "m)").
  print("  Periapsis: " + round(orbit:periapsis) + "m (" + round(desired_altitude - orbit:periapsis) + "m)").
  print("  Period: " + round(orbit:period, 2) + "s").
  print("    > deploy diff: " + round(deploy_period - orbit:period, 2)).
  print("    > network diff: " + round(desired_period - orbit:period, 9)).

  wait 0.1.
}

print("Apoapsis reached!").
