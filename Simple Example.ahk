#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

AHSD := new AutoHotStreamDeck()

; Get a Deck object
Deck := AHSD.Instance.GetDeck(1)

; Pick random colour for the button
r := Rand(), g := Rand(), b := Rand()

; Ask the Deck object to create a new Canvas Object
canvas := Deck.CreateKeyCanvas(Func("KeyEvent"))

; Set the background colour of the Canvas Object
canvas.SetBackground(r, g, b)

; Create a KeyTextBlock  Object
keyTextBlock := canvas.CreateTextBlock("Test")
; Set text height
keyTextBlock.SetHeight(36)
; You can also "chain" these SeXXX functions
keyTextBlock.SetTop(36)
	.SetFontSize(25)
	.SetOutlineSize(5)
; Add the KeyTextBlock to the Canvas Object
canvas.AddTextBlock("ButtonLabel", keyTextBlock)

; Assign the Canvas Object to key 1 (Imagery uploaded to key's screen at this point)
Deck.SetKeyCanvas(1, canvas)
return

KeyEvent(state){
	Tooltip % "key changed state to: " state
}

; Helper functions for picking random colours
GetRandomColor(){
	global Deck
	return Deck.CreateBitmapFromColor(Rand(), Rand(), Rand())
}

Rand(){
	Random, val, 0, 255
	return val
}

^Esc::
	ExitApp