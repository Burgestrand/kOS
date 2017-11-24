@LAZYGLOBAL off.

parameter desired_inclination is 0.

local deltaI is desired_inclination - orbit:inclination.

function time_to_node {
    local w is ship:orbit:period/360.
    local shiptolan is 360 - (orbit:argumentofperiapsis + orbit:trueanomaly).

    if shiptolan < 0 {
        set shiptolan to shiptolan + 360.
    }

    return shiptolan * w.
}

function dV_normal {
    local v is velocityat(ship, time:seconds + time_to_node()):orbit:mag.
    return 2 * v * sin(deltaI/2).
}

function dV_prograde {
    local v is velocityat(ship,time:seconds + time_to_node()):orbit:mag.
    local v_prograde is v/cos(deltaI).
    return v - v_prograde.
}

local nd is node(time:seconds + time_to_node(), 0, dV_normal() ,dV_prograde).
add nd.
