*=$0801 	;SYS 2064
    	.byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00
  
*=$0810

	lda #01
	sta $0400

	lda #23
	sta $0401

	lda #05
	sta $0402

	lda #19
	sta $0403

	lda #15
	sta $0404

	lda #13
	sta $0405
	lda #05
	sta $0406
	rts
