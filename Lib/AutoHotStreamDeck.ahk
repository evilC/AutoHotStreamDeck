#include %A_LineFile%\..\CLR.ahk

class AutoHotStreamDeck {
	__New(){
		dllName := "AutoHotStreamDeck.dll"
		dllFile := A_LineFile "\..\" dllName
		hintMessage := "Try right-clicking lib\" dllName ", select Properties, and if there is an 'Unblock' checkbox, tick it`nAlternatively, running Unblocker.ps1 in the lib folder (ideally as admin) can do this for you."
		if (!FileExist(dllFile)){
			MsgBox % "Unable to find lib\" dllName ", exiting..."
			ExitApp
		}
		
		asm := CLR_LoadLibrary(dllFile)
		try {
			this.Instance := asm.CreateInstance("AutoHotStreamDeck.Wrapper")
		}
		catch {
			MsgBox % dllName " failed to load`n`n" hintMessage
			ExitApp
		}
		if (this.Instance.OkCheck() != "OK"){
			MsgBox % dllName " loaded but check failed!`n`n" hintMessage
			ExitApp
		}
	}
	
	GetInstance(){
		return this.Instance
	}
}