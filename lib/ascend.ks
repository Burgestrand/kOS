@LAZYGLOBAL off.

parameter inclination is 0.

runoncepath("archive:bootstrap").

local station is vessel("Kerbal Station").

on (ship:altitude > body:atm:height) {
  // Clear all fairings.
  for fairing in ship:partsnamedpattern("fairing") {
    fairing:getmodule("ModuleProceduralFairing"):doaction("deploy", true).
  }

  wait 1.

  toggle lights.
  toggle panels.
  target_antennas(station).

  // Don't repeat.
  return false.
}

runpath("lib/ascend/gravity_turn", inclination).
runpath("lib/node_circularize").

wait until ship:altitude > body:atm:height.
