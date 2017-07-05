@LAZYGLOBAL off.

PARAMETER wait_stationary IS (ship:status = "landed").

//Open the terminal for the user.
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

RUNONCEPATH("archive:util/enum").
RUNONCEPATH("archive:util/general_math").
RUNONCEPATH("archive:util/misc").
RUNONCEPATH("archive:util/piloting").
RUNONCEPATH("archive:util/rocket_science").
RUNONCEPATH("archive:util/terminal").
