@LAZYGLOBAL off.

runoncepath("archive:bootstrap").

local current_body is body.

local number_of_satellites is 3.
local target_apoapsis is 2 * 1e6. // 2Mm
local target_periapsis is target_apoapsis.
local target_period is orbital_period(target_apoapsis, target_periapsis, current_body).

local separation_angle is 360 / number_of_satellites.
local va is v(target_apoapsis + current_body:radius, 0, 0).
local vb is v(va:x * cos(separation_angle) - va:y * sin(separation_angle), va:y * cos(separation_angle) + va:x * sin(separation_angle), 0).
local vc is va - vb.
local separation_distance is round(vc:mag, 0).

local separation_fraction is (number_of_satellites - 1)/number_of_satellites.
local separation_period is target_period * separation_fraction.
local separation_apoapsis is target_apoapsis.
local separation_periapsis is (((separation_period / (2 * constant:pi))^2 * current_body:mu)^(1/3) * 2) - (2*current_body:radius) - separation_apoapsis.

function delta {
  parameter lhs.
  parameter rhs.
  parameter decimals is 0.
  return "Δ" + round(lhs - rhs, decimals).
}

local target_ap is round(target_apoapsis / 1e3).
local target_pe is round(target_periapsis / 1e3).
local target_p is round(target_period, 4).

local separation_ap is round(separation_apoapsis).
local separation_pe is round(separation_periapsis).
local separation_p is round(separation_period, 4).

local maximum_distance is round(separation_distance / 1e6, 2).

until false {
  clearscreen.

  print("[Target]").
  print("Body: " + current_body:name).
  print("Apoapsis: " + target_ap + "km (" + delta(orbit:apoapsis, target_apoapsis) + "m)").
  print("Periapsis: " + target_pe + "km (" + delta(orbit:periapsis, target_periapsis) + "m)").
  print("Period: " + target_p + "s (" + delta(orbit:period, target_period, 4) + "s)").
  print("Distance: " + maximum_distance + "Mm").
  print(" ").
  print("[Separation]").
  print("Apoapsis: " + separation_ap + "m (" + delta(orbit:apoapsis, separation_apoapsis) + "m)").
  print("Periapsis: " + separation_pe + "m (" + delta(orbit:periapsis, separation_periapsis) + "m)").
  print("Period: " + separation_p + "s (" + delta(orbit:period, separation_period, 4) + "s)").

  wait 0.
}
