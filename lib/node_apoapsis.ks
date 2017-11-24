@LAZYGLOBAL off.

parameter desired_apoapsis.

runoncepath("archive:bootstrap").

local opposite_apsis is orbit:periapsis.
local desired_sma is semimajoraxis(desired_apoapsis, orbit:periapsis).
local apsis_eta is eta:periapsis.

// Calculate our current velocity, desired velocity, and their difference.
local v_current is vis_viva(opposite_apsis, semimajoraxis()).
local v_desired is vis_viva(opposite_apsis, desired_sma).
local delta_v is v_desired - v_current.

// Add a node for ourselves.
local nd is node(time:seconds + apsis_eta, 0, 0, delta_v).
add nd.
