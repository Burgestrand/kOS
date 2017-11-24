@LAZYGLOBAL off.

PARAMETER wait_stationary IS (ship:status = "landed").

switch to archive.

//Open the terminal for the user.
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

print("Starting...").

RUNONCEPATH("util/enum").
RUNONCEPATH("util/general_math").
RUNONCEPATH("util/misc").
RUNONCEPATH("util/navball").
RUNONCEPATH("util/piloting").
RUNONCEPATH("util/rocket_science").
RUNONCEPATH("util/terminal").

kuniverse:TimeWarp:cancelwarp().
terminal_clear().
