switch to archive.
runpath("archive:bootstrap").

clearscreen.

local minmus is body("Minmus").
local v is 29.29.
local altitude is (minmus:mu / v^2) - minmus:radius.

local a is semimajoraxis(altitude, altitude, minmus).
local period is 2 * constant:pi * sqrt(a^3 / minmus:mu).

local T is period * 2/3.
local deploy_periapsis is (((T / (2 * constant:pi))^2 * minmus:mu)^(1/3) * 2) - (2*minmus:radius) - altitude.

local b is semimajoraxis(altitude, deploy_periapsis, minmus).
local deploy_period is 2 * constant:pi * sqrt(b^3 / minmus:mu).

print("[Minmus Network]").
print("  Altitude: " + altitude + "m").
print("  Period: " + period + "s" + " (" + time_format(period) + ")").
print("[Deployment]").
print("  Apoapsis: " + altitude + "m").
print("  Periapsis: " + deploy_periapsis + "m").
print("  Period: " + deploy_period + "s" + " (" + time_format(deploy_period) + ")").

// Minmus Network:
//   Altitude: 1998272m
//   Period:   441533s = (20d2h55m44.6s)
// Deployment:
//   Apoapsis:  1998272m
//   Periapsis: 1023239m
//   Period:    294355.40392s = (13d3h56m52.88s)

// Orbital Period:
//   20d2h39m38.728s
// Deploy Period:
//   13d3h46m8.96s
// 1/3
//   6d4h52m39.19s
