@LAZYGLOBAL off.

parameter desired_periapsis.

runoncepath("bootstrap").

local opposite_apsis is orbit:apoapsis.
local desired_sma is semimajoraxis(orbit:apoapsis, desired_periapsis).
local apsis_eta is eta:apoapsis.

// Calculate our current velocity, desired velocity, and their difference.
local v_current is vis_viva(opposite_apsis, semimajoraxis()).
local v_desired is vis_viva(opposite_apsis, desired_sma).
local delta_v is v_desired - v_current.

// Add a node for ourselves.
local nd is node(time:seconds + apsis_eta, 0, 0, delta_v).
add nd.
