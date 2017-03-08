	*=$0801 	;SYS 2064
    .byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00

	*=$1000		;music at $1000	to $5E23 - rules out VIC banks 0 and 1
	.binary "megamix.sid",$7c+2

	;Advanced art studio file specs:
	;Load address: $a000 - $c71F
	
	; Load address needs to be in same address range as the VIC bank
	; that you're going to copy it to, according to Vanja

	;$a000 - $bF3F Bitmap data
	;$bF40 - $c327 Screen RAM (copy to VIC Bank start address + $0400)
	;$c328 Border colour
	;$c329 Background colour
	;$c338 - $c71F Colour RAM (copy to $d800->)
	
	*=$a000
	.binary "dino.ocp",2
	
	*=$0810		;code at $0810
	
	sei		;disable interrupts

	; here we shift BASIC and Kernal ROM routines out the way
	; so we can use the RAM space at the addresses they used.
	lda #$35
	sta $01

	lda #$00	;select subtune
	jsr $1000	;init music
	
	;-------------------------
	;-- DISPLAY PIC ATTEMPT --
	;-------------------------

	; black background/border
	lda #$00
	sta $d020
	sta $d021
	
	ldx #$00    ; zero X register

setpic
;	start copying screen data - screen ram
	lda $bF40,x
	sta $8400,x

	lda $c040,x
	sta $8500,x
	
	lda $c140,x
	sta $8600,x
	
	lda $c240,x
	sta $8700,x
	
;	 start copying color ram

	lda $c338,x
	sta $d800,x

	lda $c438,x
	sta $d900,x

	lda $c538,x
	sta $da00,x

	lda $c638,x
	sta $db00,x
                                                         
	inx
	bne setpic

;	 Go into bitmap mode
	lda #$3b 
	sta $d011
                                     
;	 Go into multicolor mode
	lda #$18 
	sta $d016

	; Select VIC bank (last two digits of the ora statement)
	; 00 = bank 3 - $C000 - $FFFF
	; 01 = bank 2 - $8000 - $BFFF
	; 10 = bank 1 - $4000 - $7FFF
	; 11 = bank 0 - $0000 - $3FFF
	
 	lda $DD00
	and #%11111100
	ora #%00000001
	sta $dd00

	; Set VIC screen and font pointers

	lda #$18
 	sta $d018

loop	
	lda #$3A	;wait for the raster beam to reach line #$3f	
	cmp $d012				
	bne *-3	

	ldx #$0b	;timing loop to hide flicker beyond border
	dex		
	bne *-1		

	lda #$00	;change screen and border
	sta $d020	
	sta $d021	

	jsr $1003	;play the music

	lda #$f2 	;wait for raster beam to reach line #$f2
	cmp $d012	
	bne *-3	

	ldx #$0b	;timing loop to hide flicker beyond border
	dex		
	bne *-1		

	lda #$0b	;change screen and border
	sta $d020	
	sta $d021	

	jmp loop	;jump to loop