﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;------------- Coordinate Management -------------------------------------------
User_MouseCoords()
{
	Global X_Mouse
	Global Y_Mouse
	CoordMode, mouse, screen
	MouseGetPos, X_Mouse, Y_Mouse
}
;------------------------------------------------------------
;------------- Tooltip Management ---------------------
TooltipNote(x,y:="")
{
	global Tooltip_I
	Tooltip_I := y
	Tooltip,%x%,,,%Tooltip_I%
	Settimer,Remove_Tooltip,5000
}

Remove_Tooltip:
	ToolTip,,,,%Tooltip_I%
	settimer,Remove_Tooltip,delete
return

;------------------------------------------------------------
;------------- Clipboard Management ----------------------------
ClipboardCheck:
	Clipwait, 1
	If ErrorLevel
	{
		tooltipnote("Clipboard came up empty",5)
		ErrorLevel :=
		Exit
	}
	else
	{
		tooltipNote("Contents successfully copied",5)
	}
return

;------------------ Message Boxes ----------------------

UserMsg_Notif(t)
{
	User_MouseCoords()_NewEnum
	Global X_Mouse
	Global Y_Mouse
	Gui, Notification:New,,Notification
	Gui, Add, text, x15 Y15, %t%
	Gui, Add, button, X15 y45 w100 gAcceptNote, Exit
	gui, Notification:Show, x%X_Mouse% y%Y_Mouse%
	Exit
}

AcceptNote:
	Gui, Submit
return

UserMsg_YESNO(t)
{
	Global Proceed
	User_MouseCoords()
	Global X_Mouse
	global Y_Mouse
	Gui, Testing:new,,Testing Gui
	Gui, add, text, x15 y15, %t%
	gui, add, button, x15 y45 w100 gYesVar, Yes
	gui, Add, button, x115 y45 w100 gNoVar, No
	Gui, Testing:show, x%X_Mouse% y%Y_Mouse%
	pause, on
	Return Proceed
}

YesVar:
	Proceed := 1
	Gui, Cancel
	pause, off
return

NoVar:
	Proceed := 0
	gui, Cancel
	pause, off
return

;-  PolarScreenCheck
;-  Polar Screen Check will take the Text entered in the paranthasis and check if Polar is on that screen by copying the screen into the clipboard.
;-  The result is submitted into a Boolean called PolarScreenCheckBool
PolarScreenCheck(byref TextToFind)
{
	Global PolarScreenCheckBool
	TempVar := Clipboard
	Clipboard :=
	PolarScreenCheckBool := 0
	Loop, 2
	{
		Loop, 2
		{
			IfWinNotExist, AHK_Class SDI:TN3270Plus
				Break 2
			IfWinNotActive, AHK_Class SDI:TN3270Plus
				WinActivate, AHK_Class SDI:TN3270Plus
			IfWinNotActive, AHK_Class SDI:TN3270Plus
				Break 2
			SendEvent, ^a^c
			Clipwait, 1
			If ErrorLevel
			{
				TooltipNote("Clipboard appears to still be empty...")
				ErrorLevel = 0
				If A_Index = 2
				{
					TooltipNote("Failed to copy polar screen")
					Break 2
				}
			}
			else
			{
				TooltipNote("Clipboard Filled, Searching for Variable")
				Break
			}
		}
		Ifinstring, Clipboard, %TextToFind%
		{
			PolarScreenCheckBool := 1
			TooltipNote("Varible found in string...")
			break
		}
		else
		{
			Sleep, 500
		}
	}
	Clipboard := TempVar
	Return PolarScreenCheckBool
}
			
GetPolarRates:
{
	Global NewString
	;----- Variable reset ------------------
	NewString :=
	NewClipboard :=
	NewClipboardFinal :=
	ClipArray := Object()
	;----- Troubleshooting variables -----------------
	CheckFormat := 
	;----- Fill Clipboard, Assign to new Value ------------------------------
	SendEvent, ^a^c
	Clipwait, 1
	If Errorlevel
	{
		ErrorLevel :=
		Tooltip, "Failed to fill clipboard with values. Exiting..."
		Exit
	}
	NewClipboard := Clipboard
	;----- Format value to just rates and categories --------------------------
	NewClipboard := substr(NewClipboard,Instr(NewClipboard,"Cat Apo",,1,1))
	If Instr(NewClipboard,"Cat Apo`t ",,1,1) ;--- Change Field Attribute To Tab
	{
		StringReplace, NewClipboard, NewClipboard, `tC`t,`t,All
		StringReplace, NewClipboard, NewClipboard, %a_Space%,,,All
		StringReplace, NewClipboard, NewClipboard, `t`t,`t,All
		NewClipboard := SubStr(NewClipboard,Instr(NewClipboard,"`n",,1,1)+1)
		NewClipboard := SubStr(NewClipboard,1,Instr(NewClipboard,"`r`n`r`n",,1,1)+1)
	}
	else ;---- Spaces To Tab
	{
		StringReplace, NewClipboard, NewClipboard, %A_Space%C%A_Space%,`t,All
		NewClipboard := SubStr(NewClipboard,Instr(NewClipboard,"`n",,1,1)+1)
		NewClipboard := Substr(NewClipboard,1,Instr(NewClipboard,"`r`n`t`r`n",,1,1)+1)
	}
	;---- StringReplace that applies to both "Field Attribute to Tab" and "Spaces to Tab" copy options
	StringReplace, NewClipboard, NewClipboard, `t`r`n,`r`n,All
	;---- Boolean check to add text to visualize the outcome ----------------------
	If CheckFormat
	{
		StringReplace, Checking, NewClipboard, %A_Space%, {Space},,All
		StringReplace, Checking, Checking, `t, {Tab},,All
		StringReplace, Checking, Checking, `r, {Return},,All
		StringReplace, Checking, Checking, `n, {NewLine}`n,,All
		Msgbox, %Checking%
	}
	;----- Parse NewClipboard by Newline(`n) and rebuild list
	Loop, Parse, NewClipboard, `n,`r `n `t
	{
		If CheckFormat
		{
			StringReplace, Checking, A_Loopfield,`t,{tab},all
			StringReplace, Checking, Checking,`n,{NewLine},All
			StringReplace, Checking, Checking, `r,{Return},All
			Msgbox, %Checking%
			continue
		}
		If (Strlen(A_Loopfield) < 1) or (instr(A_Loopfield,"`t`t",,1,1)=1)
			continue
		else
		{
			NewString .= A_Loopfield . "`n"
		}
	}
}
return
		
	
