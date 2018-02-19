TASS64=D:\Dropbox\C64 Stuff\Windows\64tass-1.53.1515\64tass
KICK=d:\Downloads\KickAssembler\KickAss.jar
EXOMIZER=D:\Dropbox\C64 Stuff\Windows\exo\win32\exomizer
CC1541=D:\Dropbox\C64 Stuff\Windows\cc1541
EXOMIZERFLAGS=sfx basic -n
VICE=D:\WinVICE-3.1-x64\x64
VICEFLAGS=-keybuf "\88" +warp
SOURCES=$(wildcard *.asm)
OBJECTS=$(SOURCES:.asm=.prg)

.PRECIOUS:Calvin.prg
.SECONDARY:

%.prg: %.asm
	java -jar $(KICK) $<

%.prg.exo: %.prg
	$(EXOMIZER) $(EXOMIZERFLAGS) $< -o $@

%: %.d64
	-$(VICE) $(VICEFLAGS) $<

%.d64: %.prg.exo
	$(CC1541) -n $@ -f $< -w $< $@