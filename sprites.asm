*=$0801 "Basic Program"
	BasicUpstart($0810)

*=$1000 "Music"
	.import binary "FeelTheBass.sid",$7E
	
*=$A000 "Sprites"
    .import binary "calvin2.prg",2
	
*=$0810 "Main code"

	//disable interrupts
	sei	

	// here we shift BASIC and Kernal ROM routines out the way
	// so we can use the RAM space at the addresses they used.
	lda #$35
	sta $01

// ----- @Sprite images@ -----

.var hobbes_head1_right 		= $80
.var calvin_head1_right			= $81
.var calvin_head1_overlay_right	= $82
.var calvin_head2_right			= $83
.var calvin_head2_overlay_right = $84
.var calvin_head3_right		 	= $85
.var calvin_head3_overlay_right	= $C6
.var hobbes_head2_right			= $C7
.var hobbes_body_right			= $C8
.var calvin_body_right			= $C9
.var calvin_body_overlay_right	= $CA
.var choc_bomb					= $CB
.var sandwich					= 12
.var calvin_head1_left			= 17
.var calvin_head1_overlay_left	= 18
.var calvin_head2_left			= 19
.var calvin_head2_overlay_left   = 20
.var calvin_head3_left			= 21
.var calvin_head3_overlay_left	= 22
.var hobbes_head2_left			= 23
.var hobbes_head1_left			= 24
.var calvin_body_left			= 25
.var calvin_body_overlay_left    = 26
.var spiff_head1_right			= 27
.var spiff_head1_overlay_right	= 28
.var spiff_head1_left			= 29
.var spiff_head1_overlay_left	= 30
.var hobbes_body_left			= 32
.var raygun_right				= 33
.var raygun_overlay_right		= 34
.var spiff_body_right			= 35
.var spiff_body_overlay_right	= 36
.var spiff_body_left				= 37
.var spiff_body_overlay_left		= 38
.var raygun_left					= 41
.var raygun__overlay_left		= 42

// ----- @Sprite palettes@ -----

.var sprite_background_color   = $0C
.var sprite_multicolor_1       = $00
.var sprite_multicolor_2       = $01

.var sprite1_color              = $08
.var sprite2_color              = $07
.var sprite3_color              = $02
.var sprite4_color              = $08
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

.var sprite1x = $A0
.var sprite1y = $80

.var sprite2x = $A0
.var sprite2y = $95

.var sprite3x = $70
.var sprite3y = $7D

.var sprite4x = $70
.var sprite4y = $92

.var sprite5x = $70
.var sprite5y = $a2

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
	
	lda #sprite2_color
	sta $d027                                                    
	
	lda #sprite3_color
	sta $d029
	
	lda #sprite_overlay_color1
	sta $d028
	
	lda #sprite_overlay_color2
	sta $d02a
	
	lda #sprite4_color
	sta $d02b
	sta $d02c
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
	sta $d000	  // x = 40
	lda #sprite1y
	sta $d001     // y=40
	
	//Sprite 2 coords
	lda #sprite1x
	sta $d002	  // x = 40
	lda #sprite1y
	sta $d003     // y=40
	
	//Sprite 3 coords
	lda #sprite2x
	sta $d004	  // x = 40
	lda #sprite2y
	sta $d005     // y=55
	
	//Sprite 4 coords
	lda #sprite2x
	sta $d006	  // x = 40
	lda #sprite2y
	sta $d007     // y=55
	
	//Sprite 5 coords
	lda #sprite3x
	sta $d008
	lda #sprite3y
	sta $d009
	
	//sprite 6 coords
	lda #sprite4x
	sta $d00a
	lda #sprite4y
	sta $d00b

	//sprite0
	lda #hobbes_head1_right
	sta $87f8	  // pointer to sprite data at $8000
	
	/*
	//sprite1
	lda #calvin_head1_overlay_left
	sta $07f9
	
	//sprite2
	lda #calvin_body_left
	sta $07fa
	
	//sprite3
	lda #calvin_body_overlay_left
	sta $07fb
	
	//sprite4
	lda #hobbes_head2_right
	sta $07fc
	
	//sprite5
	lda #hobbes_body_right
	sta $07fd
	*/
	//:break()
	rts

clear:
    lda #$20     // #$20 is the spacebar Screen Code
	sta $8400,x  // fill four areas with 256 spacebar characters
	sta $8500,x 
	sta $8600,x 
	sta $86e8,x 
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
	ora #%00000001  
	sta $dd00
	
	lda #$18
 	sta $d018
 	rts