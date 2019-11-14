#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

OutputDebug % DEBUGVIEWCLEAR

AHSD := new AutoHotStreamDeck()

deckCount := AHSD.Instance.GetDeckCount()
Decks := []

Loop % deckCount {
	deckNum := A_Index
	deck := AHSD.Instance.GetDeck(deckNum)
	pageStart := (deck.RowCount - 1) * deck.ColCount
	deckData := {ID: deckNum, Deck: deck, ActiveProfile: 0, CanvasPages: [], ToggleStates: [], SubCanvases: [], PageStart: pageStart}
	Decks[deckNum] := deckData
	
	Loop % deck.ColCount {
		page := A_Index
		pos := pageStart + page
		letter := Chr(page+64)
		
		r := Rand(), g := Rand(), b := Rand()
		canvas := CreateCanvas(deckData, "P " letter, r, g, b, Func("PageKeyEvent").Bind(deckData, page))
		deck.SetKeyCanvas(pos, canvas)
		deckData.CanvasPages[page] := canvas
		Loop % deck.ColCount * (deck.RowCount - 1) {
			canvas := CreateCanvas(deckData, letter " " A_Index, r, g, b, Func("KeyEvent").Bind(deckData, page, A_Index))
			deckData.SubCanvases[page, A_Index] := canvas
			deckData.ToggleStates[page, A_Index] := 0
		}
	}
	SetPage(deckData, 1)
}

CreateCanvas(deckData, text, r, g, b, callback){
	global AHSD
	canvas := deckData.Deck.CreateKeyCanvas(callback)
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

SetPage(deckData, page){
	PageKeyEvent(deckData, page, 1)
	PageKeyEvent(deckData, page, 0)
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

KeyEvent(deckData, page, key, state){
	Log("KeyEvent: ID=" deckData.ID ", Page=" page ", Key=" key ", State=" state )
	canvas := deckData.SubCanvases[page, key]
	SetStateLabel(canvas, state)
	if (state){
		deckData.ToggleStates[key] := !deckData.ToggleStates[key]
		SetToggleState(canvas, deckData.ToggleStates[key])
	}
	deckData.Deck.RefreshKey(key)
}

PageKeyEvent(deckData, page, state){
	canvas := deckData.CanvasPages[page]
	SetStateLabel(canvas, state)
	
	SetToggleState(canvas, 1)
	deckData.Deck.RefreshKey(deckData.PageStart + page)
	
	if (page == deckData.ActiveProfile)
		return
	
	SetToggleState(deckData.CanvasPages[deckData.ActiveProfile], 0)
	deckData.Deck.RefreshKey(deckData.PageStart + deckData.ActiveProfile)
	
	Loop % deckData.Deck.ColCount * (deckData.Deck.RowCount - 1) {
		deckData.Deck.SetKeyCanvas(A_Index, deckData.SubCanvases[page, A_Index])
	}
	deckData.ActiveProfile := page
}

Rand(){
	Random, val, 0, 255
	return val
}

Log(text){
	OutputDebug % "AHK| " text
}

^Esc:: ExitApp