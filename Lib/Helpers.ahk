class DeckHelper {
	__New(AHSD, deckNum){
		this._AHSD := AHSD
		this._deckNum := deckNum
		this.Deck := AHSD.Instance.GetDeck(deckNum)
		this.RowCount := this.Deck.RowCount
		this.ColCount := this.Deck.ColCount
		this._pageHelper := new PageHelper()
	}
	
	AddKey(page, keyNum, callback){
		keyHelper := new KeyHelper(this._AHSD, this.Deck, keyNum, callback)
		this._pageHelper.AddKey(keyHelper, page, keyNum)
		return keyHelper
	}

	AddPageKey(keyNum, page, callback){
		return this._pageHelper.AddPageKey(this._AHSD, this.Deck, keyNum, page, callback)
	}
	
	Show(page := 1){
		return this._pageHelper.Show(page)
	}
}

class PageHelper {
	ActivePage := 1
	PageSwitchKeyHelpers := []
	_pageSwitchKeyCallbacks := []
	__New(numPages){
		this.NumPages := numPages
		this.KeyHelpers := []
		Loop % numPages {
			this.KeyHelpers[A_Index] := []
		}
	}
	
	AddKey(keyHelper, page, keyNum){
		this.KeyHelpers[page, keyNum] := keyHelper
	}
	
	AddPageKey(ahsd, deck, keyNum, page, callback){
		this.PageSwitchKeyHelpers[page] := new KeyHelper(ahsd, deck, keyNum, this.OnPageSwitchKeyEvent.Bind(this, page))
		this._pageSwitchKeyCallbacks[page] := callback
		return this.PageSwitchKeyHelpers[page]
	}
	
	OnPageSwitchKeyEvent(page, keyHelper, state){
		this._pageSwitchKeyCallbacks[page].Call(this, page, state)
		if (state){
			this.Show(page)
		}
	}
	
	Show(page){
		for i, k in this.KeyHelpers[page] {
			k.Show()
		}
		this.ActivePage := page
	}
}

class KeyHelper {
	_imageStates := {}
	__New(AHSD, deck, keyNum, callback){
		this._AHSD := AHSD
		this._deck := deck
		this._keyNum := keyNum
		this._callback := callback
		this._canvas := this._deck.CreateKeyCanvas(this.OnKeyEvent.Bind(this))
	}
	
	Show(){
		this._deck.SetKeyCanvas(this._keyNum, this._canvas)
		this.Refresh()
	}
	
	OnKeyEvent(state){
		this._callback.Call(this, state)
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