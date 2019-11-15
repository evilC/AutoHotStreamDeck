#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

OutputDebug % DEBUGVIEWCLEAR

AHSD := new AutoHotStreamDeck()

deckCount := AHSD.Instance.GetDeckCount()

decks := []
virtualKeys := []
pageSwitchKeys := []

Loop % deckCount {
	deckNum := A_Index
	deck := AHSD.Instance.GetDeck(deckNum)
	decks[deckNum] := deck
	pageStart := (deck.RowCount - 1) * deck.ColCount
	
	virtualKeys[deckNum] := []
	pageSwitchKeys[deckNum] := []
	
	Loop % deck.ColCount {
		; Add Page button
		page := A_Index
		pageSwitchKeyPos := pageStart + page
		letter := Chr(page+64)
		r := Rand(), g := Rand(), b := Rand()
		pageSwitchKey := new KeyHelper(ahsd, deck, pageSwitchKeyPos, Func("PageSwitchKeyEvent").Bind(deckNum, page))
		pageSwitchKey
			.SetBackground(r, g, b)
			.AddText("MainLabel", "Page " letter, 36, 0, 15, 5)
			.AddText("Pressed", "Pressed", 36, 20, 12, 3)
			.SetTextVisible("Pressed", false)
			.AddText("Active", "Active", 36, 40, 15, 5)
			.SetTextVisible("Active", page == 1)
			.Show()
		
		pageSwitchKeys[deckNum, page] := pageSwitchKey
		
		; Add virtual keys for this page
		virtualKeys[deckNum, page] := []
		Loop % deck.ColCount * (deck.RowCount - 1) {
			keyNum := A_Index
			virtualKey := new KeyHelper(ahsd, deck, keyNum, Func("KeyEvent").Bind(deckNum, page, keyNum))
			virtualKey
				.SetBackground(r, g, b)
				.AddText("MainLabel", letter keyNum, 36, 36, 25, 5)
				.AddText("Pressed", "Pressed", 36, 0, 12, 3)
				.SetTextVisible("Pressed", false)
				.AddImage("Off", A_ScriptDir "\SwitchHOff.png")
				.AddImage("On", A_ScriptDir "\SwitchHOn.png")
				.SetImageVisible("On", false)
			if (page == 1){
				virtualKey.Show()
			}
			virtualKeys[deckNum, page, keyNum] := virtualKey
		}
	}
}
return

PageSwitchKeyEvent(deckNum, page, state){
	global virtualKeys, pageSwitchKeys, decks
	deck := decks[deckNum]
	pageSwitchKey := pageSwitchKeys[deckNum, page]
	pageSwitchKey
		.SetTextVisible("Pressed", state)
		.Refresh()
	if (state){
		Loop  % deck.ColCount {
			pageSwitchKey := pageSwitchKeys[deckNum, A_Index]
			pageSwitchKey
				.SetTextVisible("Active", page == A_Index)
				.Refresh()
		}
		Loop % deck.ColCount * (deck.RowCount - 1) {
			keyNum := A_Index
			virtualKey := virtualKeys[deckNum, page, keyNum]
			virtualKey.Show()
		}
	}
}

KeyEvent(deckNum, page, keyNum, state){
	global virtualKeys
	virtualKey := virtualKeys[deckNum, page, keyNum]
	virtualKey.SetTextVisible("Pressed", state)
	if (state){
		virtualKey.ToggleImageVisible("Off")
		virtualKey.ToggleImageVisible("On")
	}
	virtualKey.Refresh()
}


^Esc:: ExitApp

class KeyHelper {
	_imageStates := {}
	__New(AHSD, deck, keyNum, callback){
		this._AHSD := AHSD
		this._deck := deck
		this._keyNum := keyNum
		this._canvas := this._deck.CreateKeyCanvas(callback)
	}
	
	Show(){
		this._deck.SetKeyCanvas(this._keyNum, this._canvas)
		this.Refresh()
	}
	
	SetBackground(r, g, b){
		this._canvas.SetBackground(r, g, b)
		return this
	}
	
	AddText(name, text, height, top, fontSize, outlineSize){
		; ToDo: Can Height not be automatic?
		buttonText := this._canvas.CreateTextBlock(text)
			.SetHeight(height)
			.SetTop(top)
			.SetFontSize(fontSize)
			.SetOutlineSize(outlineSize)
		this._canvas.AddTextBlock(name, buttonText)
		return this
	}
	
	SetTextVisible(name, state){
		this._canvas.SetTextBlockVisible(name, state)
		return this
	}
	
	AddImage(name, path){
		this._canvas.AddImage(name, this._AHSD.Instance.CreateImageFromFileName(path))
		this._imageStates[name] := 1
		return this
	}
	
	SetImageVisible(name, state){
		this._canvas.SetImageVisible(name, state)
		this._imageStates[name] := state
		return this
	}
	
	ToggleImageVisible(name){
		this._imageStates[name] := !this._imageStates[name]
		this.SetImageVisible(name, this._imageStates[name])
	}
	
	Refresh(){
		this._deck.RefreshKey(this._keyNum)
		return this
	}
}

Rand(){
	Random, val, 0, 255
	return val
}
