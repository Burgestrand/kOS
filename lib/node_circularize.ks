runoncepath("archive:bootstrap").

// Calculate our velocity at apoapsis using vis-via equation.
local v_ap is vis_viva(orbit:apoapsis, semimajoraxis()).

// Calculate what we want our velocity to be at apoapsis.
local desired_ap is orbit:apoapsis.
local desired_pe is desired_ap.
local desired_sma is semimajoraxis(desired_ap, desired_pe).
local v_desired is vis_viva(orbit:apoapsis, desired_sma).

// How much we need to accelerate to reach circularization.
local delta_v is v_desired - v_ap.
local nd is node(time:seconds + eta:apoapsis, 0, 0, delta_v).
add nd.
