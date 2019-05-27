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

; Assign the Canvas Object to key 1
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