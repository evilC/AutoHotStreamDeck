#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

SubTextBlocks := []
Canvases := []

AHSD := new AutoHotStreamDeck()

Images := [A_ScriptDir "\ArrowUp.png", A_ScriptDir "\ArrowRight.png", A_ScriptDir "\ArrowDown.png", A_ScriptDir "\ArrowLeft.png"]

keyCount := AHSD.Instance.Deck.KeyCount

Loop % keyCount {
	key := A_Index - 1
	AHSD.Instance.SubscribeKey(key, Func("KeyEvent").Bind(key))
	
	canvas := AHSD.Instance.CreateKeyCanvas(key)
	canvas.SetBackground(Rand(), Rand(), Rand())

	stateText := canvas.CreateTextBlock("Off").SetHeight(36)
	canvas.AddTextBlock("StateLabel", stateText)

	buttonText := canvas.CreateTextBlock("Button " key).SetHeight(36).SetTop(36)
	canvas.AddTextBlock("ButtonLabel", buttonText)

	canvas.Update()
	
	Canvases[key] := canvas
	SubTextBlocks.Push(subText)
}
return

KeyEvent(key, state){
	global AHSD, Canvases
	ToolTip % "Key: " key ", State: " state
	canvas := Canvases[key]
	subText := canvas.GetTextBlock("StateLabel")
	subText.SetText(state ? "On" : "Off")
	if (state){
		canvas.SetImageFromFileName(GetRandomImage())
	}
	canvas.Update()
}

GetRandomColorOrImage(){
	Random, val, 0, 1
	if (val){
		return GetRandomColor()
	}
	return GetRandomImage()
}

GetRandomColor(){
	global AHSD
	return AHSD.Instance.CreateBitmapFromColor(Rand(), Rand(), Rand())
}

GetRandomImage(){
	global Images
	Random, val, 1, Images.Length()
	return Images[val]
}

Rand(){
	Random, val, 0, 255
	return val
}

^Esc::
	ExitApp