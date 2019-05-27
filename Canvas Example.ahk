/*
Example to demonstrate that canvases are independent from keys
And that each canvas has it's own callback
*/

#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

AHSD := new AutoHotStreamDeck()

; Get a Deck object
Deck := AHSD.Instance.GetDeck(1)

; Ask the Deck object to create a new Canvas Object
canvas1 := Deck.CreateKeyCanvas(Func("Canvas1Event"))
canvas2 := Deck.CreateKeyCanvas(Func("Canvas2Event"))

; Set the background colour of the Canvas Object
canvas1.SetBackground(Rand(), Rand(), Rand())
canvas2.SetBackground(Rand(), Rand(), Rand())

; Set text and background for the two canvases
Loop 2 {
	; Create a KeyTextBlock  Object
	keyTextBlock := canvas%A_Index%.CreateTextBlock("Canvas " A_Index)
	; Set text height
	keyTextBlock.SetHeight(36)
	; You can also "chain" these SeXXX functions
	keyTextBlock.SetTop(20)
		.SetFontSize(15)
		.SetOutlineSize(5)
	; Add the KeyTextBlock to the Canvas Object
	canvas%A_Index%.AddTextBlock("ButtonLabel", keyTextBlock)
}

; Assign the Canvas1 Object to key 1 (Imagery uploaded to key's screen at this point)
Deck.SetKeyCanvas(1, canvas1)

CurrentCanvas := 1
return

; Swap Canvas for Key
F12::
	CurrentCanvas := 3 - CurrentCanvas ; Toggle CurrentCanvas between 1 and 2
	Deck.SetKeyCanvas(1, canvas%CurrentCanvas%)
	return

Canvas1Event(state){
	Tooltip % "Canvas1 changed state to: " state
}

Canvas2Event(state){
	Tooltip % "Canvas2 changed state to: " state
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