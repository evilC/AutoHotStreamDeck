#SingleInstance force
#Persistent
#include Lib\AutoHotStreamDeck.ahk

AHSD := new AutoHotStreamDeck()

keyCount := AHSD.Instance.KeyCount

AHSD.Instance.SetKeyColor(0, Rand(), Rand(), Rand())
return

Rand(){
	Random, val, 0, 255
	return val
}

^Esc::
	ExitApp