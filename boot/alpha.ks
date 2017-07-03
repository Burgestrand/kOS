@LAZYGLOBAL off.

RUNPATH("archive:bootstrap").

clearscreen.

if ship:status = "prelaunch" {
  terminal_print("Enabling auto-toggle of deployables").
  enable_auto_atmosphere_toggle().

  terminal_print("Ascending to outside atmosphere").
  runpath("archive:ships/alpha/ascend").

  // Clear starting rockets.
  terminal_print("Clearing starting rockets").
  stage.

  terminal_print("Waiting until outside atmosphere").
  local current_line is terminal_current_line.
  lock steering to ship:prograde.
  until ship:altitude >= body:atm:height {
    terminal_print("Distance: " + round(body:atm:height - ship:altitude) + "m", current_line).
    wait 0.
  }

  terminal_print("Calculating circularization node").
  runpath("archive:lib/node_circularize").

  terminal_print("Executing cularization node").
  runpath("archive:lib/node_execute").
}
