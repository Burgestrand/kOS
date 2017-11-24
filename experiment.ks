local target_body is body("Kerbin").
local satellites is 3.
local modifier is 1.73205080756888.
local desired_altitude is 2.000 * 1e6.
local desired_radius is desired_altitude + target_body:radius.

local angle is 360 / satellites.
local va is v(desired_radius, 0, 0).
local vb is v(va:x * cos(angle) - va:y * sin(angle), va:y * cos(angle) + va:x * sin(angle), 0).
local vc is va - vb.

runpath("archive:util/rocket_science").
print("vc: " + round(vc:mag / 1e6, 4) + "Mm").
print("geosync: " + round(geostationary_altitude() / 1e6, 4) + "Mm").
