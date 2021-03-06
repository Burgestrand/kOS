@LAZYGLOBAL off.

if ship:status = "prelaunch" {
  runoncepath("archive:bootstrap").

  terminal_print("Enabling auto-toggle of action group 1").
  on (ship:altitude > body:atm:height) {
    toggle ag1.
    return true.
  }

  runpath("archive:lib/gravity_turn", -90).

  lock steering to ship:prograde.
  terminal_wait("Waiting until outside atmosphere", {
    return body:atm:height - ship:altitude.
  }).

  // Wait until close to 2.5Mm (max range of antenna).
  terminal_wait("Waiting for apoapsis to be 2.2Mm", {
    return 2.2e6 - ship:apoapsis.
  }).
  kill_controls().

  terminal_print("Calculating circularization node at " + round(ship:apoapsis) + "m").
  runpath("archive:lib/node_circularize").
}
