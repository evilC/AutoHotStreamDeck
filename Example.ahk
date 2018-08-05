#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

ActiveProfile := 0
Canvases := []
SubCanvases := []
ToggleStates := []

AHSD := new AutoHotStreamDeck()

keyCount := AHSD.Instance.Deck.KeyCount
rowCount := AHSD.Instance.Deck.RowCount
colCount := AHSD.Instance.Deck.ColumnCount

pageStart := (rowCount - 1) * colCount

Loop % colCount {
	page := A_Index
	letter := Chr(page+64)
	pos := pageStart + page
	
	AHSD.Instance.SubscribeKey(pos, Func("PageKeyEvent").Bind(A_Index))

	canvas := AHSD.Instance.CreateKeyCanvas()
	r := Rand(), g := Rand(), b := Rand()
	canvas.SetBackground(r, g, b)
	
	stateText := canvas.CreateTextBlock("Pressed").SetHeight(36)
	canvas.AddTextBlock("StateLabel", stateText)
	SetStateLabel(canvas, false)
	
	buttonText := canvas.CreateTextBlock("P " letter).SetHeight(36).SetTop(36)
	buttonText.SetFontSize(25)
	buttonText.SetOutlineSize(5)
	canvas.AddTextBlock("ButtonLabel", buttonText)
	
	canvas.AddImage("Off", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOff.png"))
	canvas.AddImage("On", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOn.png"))

	SetToggleState(canvas, 0)

	AHSD.Instance.SetKeyCanvas(pos, canvas)
	
	Canvases[page] := canvas
	
	ToggleStates[page] := []
	
	SubCanvases[page] := []
	Loop % colCount * 2 {
		AHSD.Instance.SubscribeKey(A_Index, Func("KeyEvent").Bind(A_Index))
	
		canvas := AHSD.Instance.CreateKeyCanvas()
		canvas.SetBackground(r, g, b)
		
		stateText := canvas.CreateTextBlock("Pressed").SetHeight(36)
		canvas.AddTextBlock("StateLabel", stateText)
		SetStateLabel(canvas, false)

		buttonText := canvas.CreateTextBlock(letter " " A_Index).SetHeight(36).SetTop(36)
		buttonText.SetFontSize(25)
		buttonText.SetOutlineSize(5)
		canvas.AddTextBlock("ButtonLabel", buttonText)
		
		canvas.AddImage("Off", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOff.png"))
		canvas.AddImage("On", AHSD.Instance.CreateImageFromFileName(A_ScriptDir "\SwitchHOn.png"))

		SetToggleState(canvas, 0)
		SubCanvases[page, A_Index] := canvas
		
		ToggleStates[page, A_Index] := 0
	}
}

SetPage(1)
return

KeyEvent(key, state){
	global AHSD, Canvases, SubCanvases, ActiveProfile, ToggleStates
	;~ ToolTip % "Key: " key ", State: " state
	canvas := SubCanvases[ActiveProfile, key]
	SetStateLabel(canvas, state)
	if (state){
		ToggleStates[key] := !ToggleStates[key]
		SetToggleState(canvas, ToggleStates[key])
	}
	AHSD.Instance.RefreshKey(key)
}

PageKeyEvent(page, state){
	global AHSD, Canvases, SubCanvases, ActiveProfile, pageStart
	
	canvas := Canvases[page]
	SetStateLabel(canvas, state)
	
	SetToggleState(canvas, 1)
	AHSD.Instance.RefreshKey(pageStart + page)
	
	if (page == ActiveProfile)
		return

	SetToggleState(Canvases[ActiveProfile], 0)
	AHSD.Instance.RefreshKey(pageStart + ActiveProfile)

	Loop % AHSD.Instance.Deck.ColumnCount * 2 {
		AHSD.Instance.SetKeyCanvas(A_Index, SubCanvases[page, A_Index])
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
	global AHSD
	return AHSD.Instance.CreateBitmapFromColor(Rand(), Rand(), Rand())
}

Rand(){
	Random, val, 0, 255
	return val
}

^Esc::
	ExitApp