	*=$0801 	;SYS 2064
    .byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00
    
    *=$2000
    .binary 'calvin.prg',2
    
    *=$0810		;code at $0810
	
	sei		;disable interrupts

hobbes_background_color   = $0C
hobbes_multicolor_1       = $00
hobbes_multicolor_2       = $01
hobbes_color              = $08

init_screen      ldx #$00     ; set X to zero (black color code)
                 stx $d021    ; set background color
                 stx $d020    ; set border color
                 jsr clear
                 
setup_sprites   lda #$07
				sta $d015	  ; turn on sprite 1 + 2 + 3
				sta $d01c	  ; multicolor mode
				
				
				lda #hobbes_background_color 
				sta $d021
				lda #hobbes_multicolor_1
				sta $d025
				lda #hobbes_multicolor_2 
				sta $d026
				lda #hobbes_color
				sta $d027

				; Sprite 1 coords
				lda #$40
				sta $d000	  ;x = 40
				sta $d001     ; y=40
				
				; Sprite 2 coords
				lda #$40
				sta $d002	  ;x = 40
				lda #$51
				sta $d003     ; y=51
				
				; Sprite 3 coords
				lda #$40
				sta $d004	  ;x = 40
				lda #$62
				sta $d005     ; y=60
				
				lda #$80
				sta $07f8	  ; pointer to sprite data at $2000
				
				lda #$88
				sta $07f9
				
				lda #$90
				sta $07fa
				
				;---

				
				

clear            lda #$20     ; #$20 is the spacebar Screen Code
                 sta $0400,x  ; fill four areas with 256 spacebar characters
                 sta $0500,x 
                 sta $0600,x 
                 sta $06e8,x 
                 lda #$00     ; set foreground to black in Color Ram 
                 sta $d800,x  
                 sta $d900,x
                 sta $da00,x
                 sta $dae8,x
                 inx           ; increment X
                 bne clear     ; did X turn to zero yet?
                               ; if not, continue with the loop
                 rts           ; return from this subroutine