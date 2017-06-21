PARAMETER altitude.
print "Hover initiated for " + altitude + "m.".

LOCK STEERING TO HEADING(90, 90).

LOCK THROTTLE TO 0.4.
STAGE.

LOCAL KP IS 0.05.
LOCAL KI IS 0.001.
LOCAL KD IS 0.01.
LOCAL pid IS PIDLOOP(KP, KI, KD).
SET pid:SETPOINT TO altitude.

WAIT UNTIL SHIP:ALTITUDE > 500.
print altitude + "m reached. Starting hovering.".

LOCAL startTime IS TIME:SECONDS.

LOG "Time,Altitude,Throttle" TO "0:data.csv".
LOCK logline TO (TIME:SECONDS - startTime) + "," + SHIP:ALTITUDE + "," + speed.

LOCAL speed IS 0.
LOCK THROTTLE TO speed.

UNTIL MAXTHRUST = 0 {
  LOCAL dt IS TIME:SECONDS - pid:LASTSAMPLETIME.
  LOCAL output TO pid:UPDATE(TIME:SECONDS, SHIP:ALTITUDE).
  SET speed TO MIN(MAX(output, 0), 1).

  CLEARSCREEN.
  print "Time: " + (TIME:SECONDS - startTime) + "s.".
  print "Altitude: " + SHIP:ALTITUDE + "m.".
  print "Delta T: " + dt.
  print "Output = " + pid:PTERM + " + " + pid:ITERM + " + " + pid:DTERM.
  print "Output: " + output.
  print "KP: " + pid:KP.
  print "KI: " + pid:KI.
  print "KD: " + pid:KD.
  print "P: " + pid:ERROR.
  print "I: " + pid:ERRORSUM.
  print "D: " + -pid:CHANGERATE.
  print "Output: " + speed.

  LOG logline TO "0:data.csv".

  WAIT 0.1.
}

PRINT "Out of fuel. Exiting.".
UNLOCK THROTTLE.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
STAGE.
