print "Waiting for physics stabilization.".
WAIT UNTIL ROUND(SHIP:VELOCITY:SURFACE:MAG, 3) = 0.

print "Stable. RUN!".
RUNPATH("0:hover", 500).
