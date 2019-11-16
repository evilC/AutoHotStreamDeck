#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk
#include Lib\Helpers.ahk

OutputDebug % DEBUGVIEWCLEAR

AHSD := new AutoHotStreamDeck()

deckCount := AHSD.Instance.GetDeckCount()

Loop % deckCount {
	deckNum := A_Index
	deckHelper := new DeckHelper(AHSD, deckNum)
	pageStart := (deckHelper.Deck.RowCount - 1) * deckHelper.Deck.ColCount
	
	Loop % deckHelper.Deck.ColCount {
		; Add Page button
		page := A_Index
		pageSwitchKeyPos := pageStart + page
		letter := Chr(page+64)
		r := Rand(), g := Rand(), b := Rand()
		pageSwitchKey := deckHelper.AddPageKey(pageSwitchKeyPos, page, Func("PageSwitchKeyEvent"))
		pageSwitchKey
			.SetBackground(r, g, b)
			.AddText("MainLabel", "Page " letter, 36, 0, 15, 5)
			.AddText("Pressed", "Pressed", 36, 20, 12, 3)
			.SetTextVisible("Pressed", false)
			.AddText("Active", "Active", 36, 40, 15, 5)
			.SetTextVisible("Active", page == 1)
			.Show()
		
		; Add virtual keys for this page
		Loop % deckHelper.Deck.ColCount * (deckHelper.Deck.RowCount - 1) {
			keyNum := A_Index
			keyHelper := deckHelper.AddKey(page, keyNum, Func("KeyEvent"))
			keyHelper
				.SetBackground(r, g, b)
				.AddText("MainLabel", letter keyNum, 36, 36, 25, 5)
				.AddText("Pressed", "Pressed", 36, 0, 12, 3)
				.SetTextVisible("Pressed", false)
				.AddImage("Off", A_ScriptDir "\SwitchHOff.png")
				.AddImage("On", A_ScriptDir "\SwitchHOn.png")
				.SetImageVisible("On", false)
			if (page == 1){
				keyHelper.Show()
			}
		}
	}
}
return

PageSwitchKeyEvent(pageHelper, newPageNum, state){
	pageHelper.PageSwitchKeyHelpers[newPageNum]
		.SetTextVisible("Pressed", state)
		.Refresh()
	if (state){
		pageHelper.PageSwitchKeyHelpers[pageHelper.ActivePage]
			.SetTextVisible("Active", false)
			.Refresh()
		pageHelper.PageSwitchKeyHelpers[newPageNum]
			.SetTextVisible("Active", true)
			.Refresh()
	}
}

KeyEvent(keyHelper, state){
	keyHelper.SetTextVisible("Pressed", state)
	if (state){
		keyHelper.ToggleImageVisible("Off")
		keyHelper.ToggleImageVisible("On")
	}
	keyHelper.Refresh()
}


^Esc:: ExitApp

Rand(){
	Random, val, 0, 255
	return val
}