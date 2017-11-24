@LAZYGLOBAL off.

runoncepath("archive:bootstrap").

local circularizeAt is unsafely({
  if eta:apoapsis < eta:periapsis {
    return "apoapsis".
  } else {
    return "periapsis".
  }
}).

if circularizeAt = "apoapsis" {
  runpath("lib/node_periapsis", orbit:apoapsis).
} else {
  runpath("lib/node_apoapsis", orbit:periapsis).
}
