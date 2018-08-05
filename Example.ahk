#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

SubTextBlocks := []
Canvases := []
ToggleStates := []

AHSD := new AutoHotStreamDeck()

Images := [A_ScriptDir "\ArrowUp.png", A_ScriptDir "\ArrowRight.png", A_ScriptDir "\ArrowDown.png", A_ScriptDir "\ArrowLeft.png"]

Loop % Images.Length(){
	Images[A_Index] := AHSD.Instance.CreateImageFromFileName(Images[A_Index])
}

keyCount := AHSD.Instance.Deck.KeyCount

Loop % keyCount {
	key := A_Index - 1
	ToggleStates[key] := 0
	AHSD.Instance.SubscribeKey(key, Func("KeyEvent").Bind(key))
	
	canvas := AHSD.Instance.CreateKeyCanvas(key)
	canvas.SetBackground(Rand(), Rand(), Rand())

	stateText := canvas.CreateTextBlock("Off").SetHeight(36)
	canvas.AddTextBlock("StateLabel", stateText)

	buttonText := canvas.CreateTextBlock("B " key).SetHeight(36).SetTop(36)
	buttonText.SetFontSize(25)
	buttonText.SetOutlineSize(5)
	canvas.AddTextBlock("ButtonLabel", buttonText)
	
	canvas.AddImage("Off", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOff.png"))
	canvas.AddImage("On", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOn.png"))
	
	SetStateText(canvas, 0)
	SetToggleState(canvas, 0)

	canvas.Update()
	
	Canvases[key] := canvas
	SubTextBlocks.Push(subText)
}
return

KeyEvent(key, state){
	global AHSD, Canvases, ToggleStates
	;~ ToolTip % "Key: " key ", State: " state
	canvas := Canvases[key]
	
	SetStateText(canvas, state)
	
	if (state){
		ToggleStates[key] := !ToggleStates[key]
		SetToggleState(canvas, ToggleStates[key])
	}
	canvas.Update()
}

SetStateText(canvas, state){
	subText := canvas.GetTextBlock("StateLabel")
	subText.SetText(state ? "Pressed" : "")
}

SetToggleState(canvas, state){
	if (state){
		canvas.SetImageVisible("Off", false)
		canvas.SetImageVisible("On", true)
	} else {
		canvas.SetImageVisible("On", false)
		canvas.SetImageVisible("Off", true)
	}
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