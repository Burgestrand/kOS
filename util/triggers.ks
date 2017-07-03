@LAZYGLOBAL off.

function enable_auto_atmosphere_toggle {
  ON (SHIP:ALTITUDE > BODY:ATM:HEIGHT) {
    toggle ag1.
  }
}
