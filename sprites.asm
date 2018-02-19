*=$0801 "Basic Program"
	BasicUpstart($0810)

*=$1000 "Music"
	.import binary "Scrambled_Mind.sid",$7E
	
*=$4800 "Sprites"
    .import binary "newsprite.prg",2
	
*=$0810 "Main code"

	//disable interrupts
	sei	

	// here we shift BASIC and Kernal ROM routines out the way
	// so we can use the RAM space at the addresses they used.
	lda #$35
	sta $01

// ----- @Sprite images@ -----
// Index + 32

.var hobbes_head1_right 		= 33
.var hobbes_body1_right         = 41
.var hobbes_feet_right          = 49
.var hobbes_tail_right          = 48
.var calvin_top_right           = 42
.var calvin_bottom_right        = 50
.var calvin_bottom_right_ovl    = 51

// ----- @Sprite palettes@ -----

.var sprite_background_color   = $0B
.var sprite_multicolor_1       = $00
.var sprite_multicolor_2       = $0A

.var sprite1_color              = $01
.var sprite2_color              = $01
.var sprite3_color              = $01
.var sprite4_color              = $01
.var sprite5_color              = $07
.var sprite6_color              = $07
.var sprite7_color              = $02

.var sprite_overlay_color1     = $0A
.var sprite_overlay_color2	  = $0A

// ----- @Sprite coords@ -----

.var spr1x = $D000
.var spr1y = $D001

.var spr2x = $d002
.var spr2y = $d003

.var spr3x = $d004
.var spr3y = $d005

.var spr4x = $d006
.var spr4y = $d007

.var spr5x = $d008
.var spr5y = $d009

.var spr6x = $d00a
.var spr6y = $d00b

.var spr7x = $d00c
.var spr7y = $d00d

.var sprite1x = $A0
.var sprite1y = $80

.var sprite2x = $A0
.var sprite2y = $94

.var sprite3x = $A0
.var sprite3y = $A9

.var sprite4x = $88
.var sprite4y = $A9

.var sprite5x = $C0
.var sprite5y = $94

.var sprite6x = $C0
.var sprite6y = $a9

.var sprite7x = $C0
.var sprite7y = $a9

.var dx = $0
.var dy = $0

	jsr clear
	jsr init_vic
	jsr init_mus
        
                 
setup_sprites:   
	lda #%11111111
	sta $d015	  // turn on all sprites
	sta $d01c	  // multicolor mode
	
	
	lda #sprite_background_color 
	sta $d021	//background
	sta $d020	//border
	
	lda #sprite_multicolor_1
	sta $d025
	
	lda #sprite_multicolor_2 
	sta $d026
	
	lda #sprite1_color
	sta $d027

    lda #sprite2_color
    sta $d028

    lda #sprite3_color  
    sta $d029

    lda #sprite4_color
    sta $d02a

    lda #sprite5_color
    sta $d02b

    lda #sprite6_color
    sta $d02c

    lda #sprite7_color
    sta $d02d
                                  
	
	jsr draw_sprites	
	
loop:
	jsr $1003		//play music
	jsr WaitFrame
	jsr PlayerMovement
	jmp loop		//jump to loop
	

//wait for the raster to reach line $f8
//this is keeping our timing stable
          
//are we on line $F8 already? if so, wait for the next full screen
//prevents mistimings if called too fast

WaitFrame: 
          lda $d012
          cmp #$F8
          beq WaitFrame

//wait for the raster to reach line $f8 (should be closer to the start of this line this way)

WaitStep2:
          lda $d012
          cmp #$F8
          bne WaitStep2
          
          rts

PlayerMovement:
	lda #$02
	cmp $DC00
	beq PlayerMovement		//loop until joystick register changes

	lda $dc00      			//store new value in memory location 2.
    sta $02

    lda #%00000001 			//mask joystick up movement 
         bit $dc00      	//bitwise AND with address 56320
         bne cont1      	//no movement up -> do not increase border color
         dec spr1y
         dec spr2y
         dec spr3y
         dec spr4y
         rts

cont1:
		lda #%00000010 	//mask joystick down movement 
         bit $dc00      	//bitwise AND with address 56320
         bne cont2      	//no movement down -> do not decrease border color
         inc spr1y
         inc spr2y
         inc spr3y
         inc spr4y
         rts

cont2:    
		lda #%00000100 	//mask joystick left movement 
         bit $dc00      	//bitwise AND with address 56320
         bne cont3      	//no movement left -> do not increase background color
         dec spr1x
         dec spr2x
         dec spr3x
         dec spr4x
         rts

cont3: 
		lda #%00001000 	//mask joystick right movement 
         bit $dc00      	//bitwise AND with address 56320
         bne cont4      	//no movement right -> do not decrease background color
         inc spr1x
         inc spr2x
         inc spr3x
         inc spr4x
         rts
cont4:    
	rts

draw_sprites:
	//Sprite 1 coords
	lda #sprite1x
	sta $d000	  
	lda #sprite1y
	sta $d001     
	
	//Sprite 2 coords
	lda #sprite2x
	sta $d002	  
	lda #sprite2y
	sta $d003     
	
	//Sprite 3 coords
	lda #sprite3x
	sta $d004	  
	lda #sprite3y
	sta $d005     
	
	//Sprite 4 coords
	lda #sprite4x
	sta $d006	  
	lda #sprite4y
	sta $d007     
	
	//Sprite 5 coords
	lda #sprite5x
	sta $d008
	lda #sprite5y
	sta $d009
	
	//sprite 6 coords
	lda #sprite6x
	sta $d00a
	lda #sprite6y
	sta $d00b

    //sprite 7 coords
    lda #sprite7x
    sta $d00c
    lda #sprite7y
    sta $d00d


	//sprite1
	lda #hobbes_head1_right
	sta $47f8	  // pointer to sprite data at $8000
	
	//sprite2
	lda #hobbes_body1_right
	sta $47f9
	
	//sprite3
	lda #hobbes_feet_right
	sta $47fa
	
	//sprite4
	lda #hobbes_tail_right
	sta $47fb
	
	//sprite5
	lda #calvin_top_right
	sta $47fc
	
	//sprite6
	lda #calvin_bottom_right
	sta $47fd

    //sprite7
    lda #calvin_bottom_right_ovl
    sta $47fe
	
	//:break()
	rts

clear:
    lda #$20     // #$20 is the spacebar Screen Code
	sta $4400,x  // fill four areas with 256 spacebar characters
	sta $4500,x 
	sta $4600,x 
	sta $46e8,x 
	lda #$00     // set foreground to black in Color Ram 
	sta $d800,x  
	sta $d900,x
	sta $da00,x
	sta $dae8,x
	inx           // increment X
	bne clear     // did X turn to zero yet?
	              // if not, continue with the loop
	rts           // return from this subroutine
	
init_mus:
	lda #$00	// select subtune
	jsr $1000	// init music
	rts

init_vic:
	/* Select VIC bank (last two digits of the ora statement)
		00 = bank 3 - $C000 - $FFFF
		01 = bank 2 - $8000 - $BFFF
		10 = bank 1 - $4000 - $7FFF
		11 = bank 0 - $0000 - $3FFF
	*/

	lda $DD00
	and #%11111100
	ora #%00000010  
	sta $dd00
	
	lda #$18
 	sta $d018
 	rts