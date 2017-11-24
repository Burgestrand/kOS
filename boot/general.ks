@LAZYGLOBAL off.

if ship:status = "prelaunch" {
  runoncepath("archive:bootstrap").

  // Auto-toggle ag1 outside atmosphere.
  on (ship:altitude > body:atm:height) {
    toggle ag1.
    return true.
  }

  // Start our ascension!
  runpath("archive:lib/ascend").

  // Wait until outside atmosphere, so that apoapsis no longer lowers.
  // This is for our circularization calculations.
  terminal_print("-- Waiting until outside atmosphere --").
  lock steering to prograde.
  wait until ship:altitude > body:atm:height.

  // Calculate what we need to circularize, and do it.
  runpath("archive:lib/node_circularize").
  runpath("archive:lib/node_execute").
} else {
  terminal_print("Ship status: " + ship:status).
  terminal_print("Nothing to do!").
}
