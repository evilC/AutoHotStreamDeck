#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

ActiveProfile := 0
Canvases := []
SubCanvases := []
ToggleStates := []

AHSD := new AutoHotStreamDeck()

Deck := AHSD.Instance.GetDeck(1)
keyCount := Deck.KeyCount
rowCount := Deck.RowCount
colCount := Deck.ColCount

pageStart := (rowCount - 1) * colCount

Loop % colCount {
	page := A_Index
	letter := Chr(page+64)
	pos := pageStart + page
	r := Rand(), g := Rand(), b := Rand()
	
	canvas := CreateCanvas("P " letter, r, g, b, Func("PageKeyEvent").Bind(page))
	Deck.SetKeyCanvas(pos, canvas)
	Canvases[page] := canvas

	ToggleStates[page] := []
	SubCanvases[page] := []
	Loop % colCount * 2 {
		canvas := CreateCanvas(letter " " A_Index, r, g, b, Func("KeyEvent").Bind(page, A_Index))
		
		SubCanvases[page, A_Index] := canvas
		ToggleStates[page, A_Index] := 0
	}
}

SetPage(1)
return

CreateCanvas(text, r, g, b, callback){
	global AHSD, Deck
	canvas := Deck.CreateKeyCanvas(callback)
	canvas.SetBackground(r, g, b)
	
	stateText := canvas.CreateTextBlock("Pressed").SetHeight(36)
	canvas.AddTextBlock("StateLabel", stateText)
	SetStateLabel(canvas, false)

	buttonText := canvas.CreateTextBlock(text).SetHeight(36).SetTop(36)
	buttonText.SetFontSize(25)
	buttonText.SetOutlineSize(5)
	canvas.AddTextBlock("ButtonLabel", buttonText)
	
	canvas.AddImage("Off", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOff.png"))
	canvas.AddImage("On", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOn.png"))

	SetToggleState(canvas, 0)
	return canvas
}

KeyEvent(page, key, state){
	global AHSD, Deck, Canvases, SubCanvases, ToggleStates
	;~ ToolTip % "Key: " key ", State: " state
	canvas := SubCanvases[page, key]
	SetStateLabel(canvas, state)
	if (state){
		ToggleStates[key] := !ToggleStates[key]
		SetToggleState(canvas, ToggleStates[key])
	}
	Deck.RefreshKey(key)
}

PageKeyEvent(page, state){
	global AHSD, Deck, Canvases, SubCanvases, ActiveProfile, pageStart, colCount
	
	canvas := Canvases[page]
	SetStateLabel(canvas, state)
	
	SetToggleState(canvas, 1)
	Deck.RefreshKey(pageStart + page)
	
	if (page == ActiveProfile)
		return

	SetToggleState(Canvases[ActiveProfile], 0)
	Deck.RefreshKey(pageStart + ActiveProfile)

	Loop % colCount * 2 {
		Deck.SetKeyCanvas(A_Index, SubCanvases[page, A_Index])
	}
	ActiveProfile := page
}

SetPage(page){
	PageKeyEvent(page, 1)
	PageKeyEvent(page, 0)
}

SetStateLabel(canvas, state){
	canvas.SetTextBlockVisible("StateLabel", state)
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