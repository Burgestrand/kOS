@LAZYGLOBAL off.

if ship:status = "prelaunch" {
  runoncepath("archive:bootstrap").

  terminal_print("Enabling auto-toggle of action group 1").
  on (ship:altitude > body:atm:height) {
    toggle lights.
    toggle panels.
    toggle ag1.
    return true.
  }

  runpath("archive:lib/gravity_turn").

  terminal_wait("Waiting until outside atmosphere", {
    return body:atm:height - ship:altitude.
  }).

  terminal_print("Calculating circularization node at " + round(ship:apoapsis) + "m").
  runpath("archive:lib/node_circularize").

  terminal_print("Scheduling execution of circularization node").
  runpath("archive:lib/node_execute").
}
