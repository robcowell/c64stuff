TASS64=64tass
EXOMIZER=exomizer
CC1541=cc1541
EXOMIZERFLAGS=sfx basic -n
VICE=/Applications/VICE/x64.app/Contents/MacOS/x64
VICEFLAGS=-sidenginemodel 1803 -keybuf "\88"
SOURCES=$(wildcard *.asm)
OBJECTS=$(SOURCES:.asm=.prg)

.PRECIOUS:Calvin.prg
.SECONDARY:

%.prg: %.asm
	$(TASS64) -C -a -o $@ -i $<

%: %.prg
	-$(VICE) $(VICEFLAGS) $<
