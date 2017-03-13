	*=$0801 	;SYS 2064
    .byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00
    
    *=$2000
    .binary 'calvin.prg',2		;sprites exported from SpritePad
    
    *=$0810		;code at $0810
	
	sei		;disable interrupts
	
	;Sprite palettes

sprite_background_color   = $0C
sprite_multicolor_1       = $00
sprite_multicolor_2       = $01

sprite1_color              = $08
sprite2_color              = $07
sprite3_color             = $02
sprite_overlay_color     = $0A



init_screen      ldx #$00     ; set X to zero (black color code)
                 stx $d021    ; set background color
                 stx $d020    ; set border color
                 jsr clear
                 
setup_sprites   lda #$f
				sta $d015	  ; turn on sprite 1 + 2 + 3 + 4
				sta $d01c	  ; multicolor mode
				
				
				lda #sprite_background_color 
				sta $d021
				
				lda #sprite_multicolor_1
				sta $d025
				
				lda #sprite_multicolor_2 
				sta $d026
				
				lda #sprite2_color
				sta $d027                                                    
				
				lda #sprite3_color
				sta $d029
				
				lda #sprite_overlay_color
				sta $d028
				
				lda #sprite_overlay_color
				sta $d02a
				
				
				
				; Sprite 1 coords
				lda #$40
				sta $d000	  ;x = 40
				sta $d001     ; y=40
				
				; Sprite 2 coords
				lda #$40
				sta $d002	  ;x = 40
				sta $d003     ; y=51
				
				; Sprite 3 coords
				lda #$40
				sta $d004	  ;x = 40
				lda #$55
				sta $d005     ; y=55
				
				; Sprite 4 coords
				lda #$40
				sta $d006	  ;x = 40
				lda #$55
				sta $d007     ; y=55
			
				;sprite1
				lda #$81
				sta $07f8	  ; pointer to sprite data at $2000
				
				;sprite2
				lda #$82
				sta $07f9
				
				;sprite3
				lda #$89
				sta $07fa
				
				;sprite4
				lda #$8a
				sta $07fb
				
				
				
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