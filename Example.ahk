#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

AHSD := new AutoHotStreamDeck()

keyCount := AHSD.Instance.KeyCount

Loop % keyCount {
	key := A_Index - 1
	AHSD.Instance.SubscribeKey(key, Func("KeyEvent").Bind(key))
	if (state){
		AHSD.Instance.SetKeyColor(key, Rand(), Rand(), Rand())
	}
}
return

KeyEvent(key, state){
	global AHSD
	ToolTip % "Key: " key ", State: " state
	AHSD.Instance.SetKeyColor(key, Rand(), Rand(), Rand())
}

Rand(){
	Random, val, 0, 255
	return val
}

^Esc::
	ExitApp