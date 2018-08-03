#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

AHSD := new AutoHotStreamDeck()

Images := [A_ScriptDir "\ArrowUp.png", A_ScriptDir "\ArrowRight.png", A_ScriptDir "\ArrowDown.png", A_ScriptDir "\ArrowLeft.png"]

Loop % Images.Length(){
	Images[A_Index] := AHSD.Instance.CreateBitmapFromFile(Images[A_Index])
}

keyCount := AHSD.Instance.Deck.KeyCount

Loop % keyCount {
	key := A_Index - 1
	AHSD.Instance.SubscribeKey(key, Func("KeyEvent").Bind(key))
	AHSD.Instance.SetKeyBitmap(key, GetRandomColor())
}
return

KeyEvent(key, state){
	global AHSD
	ToolTip % "Key: " key ", State: " state
	if (state){
		AHSD.Instance.SetKeyBitmap(key, GetRandomColorOrImage())
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