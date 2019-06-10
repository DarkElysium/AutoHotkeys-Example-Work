﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

PastePolarRatePause = 1000
MenuOptions = object()
MenuOptions := Array("Active", "Active", "Active")
Option1 := MenuOptions[1]
Option2 := MenuOptions[2]
Tools_PasteZerosBool = 1
Tools_SingleDouble = 1

;Create Splash Image Screen
SplashPicGif = %A_WorkingDir%\Images\Heidy.gif
SplashImage, %SplashPicGif%, b fs18, Ready to get nutty.
WinGet, id, list,
Loop, %id%
{
	this_id := id%A_Index%
	WinGetTitle, This_Title, ahk_Id %This_ID%
	;tooltip, %this_Title%
	CheckVar1 := substr(This_Title,1,instr(This_Title,"-",False,1,1)-2) = "AutoHotkey Tools"
	CheckVar2 := Substr(This_Title,1,Instr(This_Title,".",False,1,2)-1) <> "AutoHotkey Tools - 2.06"
	CheckVar3 := strlen(This_Title) < StrLen("AutoHotkey Tools - 2.06.ahk")+5
	If CheckVar1 and CheckVar2 and CheckVar3
	{
		Msgbox, 4,Already open, Appears that %this_Title% is already opened. Close it and continue?
		If MsgboxYes
			Winclose, This_Title
	}
	;sleep, 2000
}
Sleep, 2000
SplashImage2 = %A_WorkingDir%\Images\SplashScreen2.PNG
SplashImage, %SplashImage2%, On
Sleep, 3000
SplashImage, Off


#Persistent
	SetTitleMatchMode, 1
	winGetTitle, WorkingSpreadsheet, , Copy of DE Excludes, Microsoft Visual Basic
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	CoordMode, Menu, Screen
	gosub, Create_GuiWork
return

#include, *i %A_ScriptDir%\Lib\Lib.ahk

;-------------------------------------------------------------------------------------------
;------------- Create Gui Work Tools --------------------
;-------------------------------------------------------------------------------------------
!Home::
Create_GuiWork:
	User_MouseCoords()
	SettingsPic = %A_WorkingDir%\Images\Settings.jpg
	HelpPic = %A_WorkingDir%\Images\Help.jpg
	ClosePic = %A_WorkingDir%\Images\Close.png
	Gui, AutoTools:New,,Work Tools
	;----- Arrange Groupbox's --------
	Gui, Add, Groupbox, w170 h50, Promo Status:
	Gui, Add, Groupbox, w170 y+7 h150, Macro Sets
	;----- Arrange Buttons --------------
	Gui, Add, Dropdownlist, w150 y25 x18 vDesiredStatus Choose%DesiredStatus% gMenu_StatusAutoSave AltSubmit, Open - Open - New Search||Open - Open - Continue With|Open - Close - New Search
	Gui, Add, Button, x18 y82 w150 left gPromoBuildingButton_Click, Macro Set &1: Promo Building
	Gui, Add, Button, w150 y+2 left gPromoRevisionButton_Click, Macro Set &2: Promo Revision
	Gui, Add, Button, w150 y+2 left gMacroListButton_Click, Macro Set &3: Macro List
	Gui, Add, Button, w150 y+2 left gAuditingButton Disabled, Marco Set &4: Auditing
	Gui, Add, Button, w150 y+2 left gTestScript_Load, Macro Set &5: Test Scripts
	Gui, add, picture, x25 y220 w35 h-1, %SettingsPic%
	Gui, Add, Button, x20 y215 w45 h45 0x4000000 gMainMenu_Options,
	Gui, Add, Picture, x75 Y220 w35 h-1, %HelpPic%
	Gui, Add, Button, x70 y215 w45 h45 0x4000000 gMainMenu_Help,
	Gui, Add, Picture, x125 Y220 w35 h-1, %ClosePic%
	Gui, Add, Button, Default x120 y215 w45 h45 0x4000000 gOkButton,
	Gui, AutoTools:Show,x%X_Mouse% y%Y_Mouse%
Return

;------------- Submit Entry ---------------------------
OkButton:
	Gui, Submit
	If Menu_Macroset = 3
	{
		If TimerLength =
			STime = StopPause
		Else
			STime := TimerLength * 1000
	}
Return

MainMenu_Options:
	Gui, ToolsSettings:New,,Main Options
	gui, add, checkbox,y+15 r1 vTools_PasteZerosBool Checked%Tools_PasteZerosBool%,`: Convert 0's from AP to 0.01
	gui, add, checkbox,y+3 r1 vTools_SingleDouble Checked%Tools_SingleDouble%,`: Format duplicate rates per category as 3rd/4th/5th/UC.
	Gui, add, Text, y+12 x5, Paste Polar Rate Pause (Default 1000)
	Gui, add, Text,Y+2,(Change to longer if second pricing screen is being skipped)
	Gui, Add, Slider, w300 Range500-2500 TickInterval100 Tooltip vPastePolarRatePause,1000
;	Gui, Add, Edit, w200 vPastePolarRatePause, %PastePolarRatePause%
	Gui, add, Button, x50 default w100 gMainMenu_Options_Submit, Save
	Gui, ToolsSettings:Show,x%X_Mouse% y%Y_Mouse%
return

MainMenu_Help:
	User_MouseCoords()
	Gui, Help:New,,Help Screen
	Gui, Add, Tab, w400 h400, Promo Status Help|Building Help|Revision Help|Additional Features
	Gui, Tab,1
	Gui, Add, Text, w350 x15 y35, Promo Status Macro:`tALT+NumbPadADD aka Numbpad "+"`n`n What the macro does is determined by selection in the tool but for it to work it needs 3 macros assigned to the appropriate keys.`n(Which can be created and assigned through the buttons below)`n`nThe macro will assign the keys CTRL+SHIFT+ 7-9 (Never going to directly use them). The shortcut keys were chosen for their unlikeliness to ever be already assigned.(two modifiers and distance from left handed use of the keyboard. The hand most likely to be on the keyboard)
	Gui, Add, Text, x15 y+15, Create Macros in Polar:
	Gui, Add, Button,Section w120 gBuild_Macro1_OpenOpenNext,Open - Open - New
	Gui, Add, Button, w120,Open - Open - Continue
	Gui, Add, Button, w120,Open - Close - New
	Gui, Add, Text, ys+5, Open both screens in Polar and starts a new search.
	Gui, Add, Text, y+17, Open both screens in Polar and go to next promo.
	Gui, Add, Text, y+15, Open Pricing, Close Promo, and start a new search.
	Gui, Help:Show, x%X_Mouse% y%Y_Mouse%
return

GuiClose:
ExitApp

return

MainMenu_Options_Submit:
	Gui, Submit
return

Menu_StatusAutoSave:
	Gui, Submit, NoHide
return

TestScript_Load:
	run, ToolsTest - V2.01.ahk, %A_Workingdir%\Project - Test\
return

;------------ Global Commands ----------------------------------------------------
#IfWinExist, Macro Set Active...
$^1::
	if Menu_Macroset = 2
		gosub, Revision_Step1
	else if Menu_Macroset = 3
		gosub, ListMacro1
;	else if Menu_Macroset = 4
;		send ^1
	Else if Menu_Macroset = 5
		gosub, Test_PrimaryMacro
return


$^2::
	;else if Menu_Macroset = 2
	;	gosub, Revision_Step2
	if Menu_Macroset = 3
		gosub, ListMacro2
;	else if Menu_Macroset = 4
;		send ^2
return

$^3::
	;else if Menu_Macroset = 2
	;	gosub, CVoyList
	if Menu_Macroset = 3
		gosub, ListMacro3
;	else if Menu_Macroset = 4
;		Send ^3
return

$^4::
	;else if Menu_Macroset = 2
	;	gosub, Revision_Step4
	;else if Menu_Macroset = 3
	;	gosub, ListMacro_Step4
;	Else if Menu_Macroset = 4
;		send ^4
return

$^5::
	;else if Menu_Macroset = 2
	;	gosub, Revision_Step5
	;else if Menu_Macroset = 3
	;	gosub, ListMacro_Step5
;	if Menu_Macroset = 4
;		send ^5
return

$^6::
	;~ if Menu_Macroset = 1
		;~ gosub, Building_Step6  ;Sub to run all steps. Currently, May change.
	;else if Menu_Macroset = 2
	;	gosub, Revision_Step6
	;else if Menu_Macroset = 3
	;	gosub, ListMacro_Step6
	;Else if Menu_Macroset = 4
		;;---Auditing Command
return

$^7::
	;~ If Menu_Macroset = 1
		;~ GoSub, Building_Step7
return
#IfWinExist


;------------Additional script features ------------------------------------------------------
#include, *i %A_ScriptDir%\Project - Build Promo\Building Promos - Version 1.011.ahk
#include, *i %A_ScriptDir%\Project - Revision\Revision V1.05.ahk
#include, *i %A_ScriptDir%\Project - Macro Through List\MacroThroughList V0-07.ahk
#include, *i %A_ScriptDir%\Project - Test\ToolsTest - V1.01.ahk
#include, *i %A_ScriptDir%\Project - Auditing\Auditing Master 5000 - V1.01.ahk
;----------------------------------------------------------------
#IfWinActive

!NumpadAdd::
;--- What to do depending on what the status change required is ----
StatusChange:
loop, 2
{
	IfWinActive ahk_Class SDI:TN3270Plus
	{
		If (DesiredStatus = 1 or DesiredStatus = "") ;--- "Open - Open - New Search" Shift+CTRL+7
			Send ^+7
		else if DesiredStatus = 2 ;--- "Open - Open - Continue With" Shift+CTRL+8
			Send ^+8
		else if DesiredStatus = 3 ;--- "Open - Close - New Search" Shift+CTRL+9
			Send ^+9
		else
			Msgbox "Uh.... `nDesired Status is : " %DesiredStatus%
		Exit
	}
	else IfWinNotActive ahk_Class SDI:TN3270Plus
	{
		WinActivate, ahk_Class SDI:TN3270Plus
		Winwait, ahk_Class SDI:TN3270Plus,,2
	}
}
Return

!Pause::
	Winactivate, AHK_EXE OUTLOOK.EXE
Return

;------------- Copy Rates from Polar, Activate Pricing Made 2 Easy ----------------
#IfWinActive ahk_Class SDI:TN3270Plus
!c::
CopyPolarRates:
	;--- Empty Clipboard, RatesFromPolar, and Reset ErrorLevel
	Clipboard :=
	;----- New Polar Rate copy -----
		Gosub, GetPolarRates
	;---- End Polar Rate Copy --------------------
	String1 := NewString
	
	Sendevent, {f8}
	Sleep, 600
	
	;----- New Polar Rate copy -----
		Gosub, GetPolarRates
		Clipboard :=
	;---- End Polar Rate Copy --------------------
	String2 := NewString
	
	If String1 = %String2%
		Clipboard := String1
	else
		Clipboard := String1 . String2

	ClipWait, 2
	If Errorlevel = 1
	{
		Msgbox Failed to put FinalPolar Rates into the Clipboard `n %String1% `n %String2%
		ErrorLevel = 0
		Exit
	}
	ifwinexist, ,Auditing Made 2 Easy,, Microsoft Visual Basic
	{
		Winactivate, ,Auditing Made 2 Easy,, Microsoft Visual Basic
		loop, 10
		{
			sleep, 150
			IfWinNotactive, ,Auditing Made 2 Easy,, Microsoft Visual Basic
				continue
			IfwinActive, ,Auditing Made 2 Easy,, Microsoft Visual Basic
				break
			If A_Index = 10
				Msgbox Failed to switch windows.
		}
	}
	else ifwinexist, ,Auditing Pricing Made Easy 101,, Microsoft Visual Basic
	{
		Winactivate,, Auditing Pricing Made Easy 101,, Microsoft Visual Basic
		loop, 4
		{
			sleep, 150
			IfWinNotActive,, Auditing Pricing Made Easy 101, Microsoft visual Basic
				continue
			IfwinActive, ,Auditing Pricing Made Easy 101, Microsoft visual Basic
				break
			If A_Index = 4
				Msgbox Failed to switch windows.
		}
	}

Return
#IfWinActive

;-------------------------------------------------------------------------------------------
;---------------------Paste Rates into Polar ---------------------------------------------------
;-------------------------------------------------------------------------------------------

#IfWinActive, ahk_Class SDI:TN3270Plus
^d::
PasteRatesIntoPolar:
Haystack :=
textSegment :=
PricingArray :=
finalText :=
Page1 :=
Page2 :=
Loopcount :=

If clipboard =
{
	Tooltip, Nothing in Clipboard
	Exit
}

;----- check cursor location ---------
SaveClipboard := Clipboard
Clipboard :=
Sendevent, +{up 2}^c
Clipwait, 1
If errorlevel
	Exit
StringReplace, NewVar, Clipboard,`r,,all
StringReplace, NewVar, NewVar,`n,,all
If NewVar = aA4
	SendEvent, +{Enter 2}{Tab 2}

Clipboard :=
Clipboard := SaveClipboard

;------- Process and format rates -------------------
HayStack := Clipboard
StringReplace, HayStack, HayStack, %A_Space%,,All
StringReplace, HayStack, HayStack, `,,,All
StringReplace, HayStack, HayStack, `r`n`t,,All
Loop, Parse, Haystack, `n, %A_Space%%A_Tab%
{
	PricingArray1 :=
	PricingArray2 :=
	PricingArray3 :=
	PricingArray4 :=
	PricingArray5 :=
	PricingArray6 :=
	
	StringReplace, TextSegment, A_Loopfield, `n,,all
	StringReplace, TextSegment, TextSegment, `r,,all
	StringReplace, TextSegment, TextSegment, `t`t,`t,all
	
	StringSplit, PricingArray, TextSegment, `t
		If TextSegment =
			break
		
		;--- If copied rates are 3rd/4th/5th then make 0's 0.01 if checkbox is checked
		If Tools_PasteZerosBool
		{
			If (PricingArray1 = PricingArray2) or (PricingArray1 > PricingArray2)
			{
				If PricingArray1 = 0
					PricingArray1 = 0.01
				If PricingArray2 = 0
					PricingArray2 = 0.01
			}
		}
		else
		{
			;Do Nothing to the 0's from the AP.
		}
		
		If (PricingArray3 = "FREE") or (PricingArray3 = 0) or (PricingArray3 = 0.01)
			PricingArray3 := 0.01
		If (PricingArray4 = "FREE") or (PricingArray4 = 0) or (PricingArray4 = 0.01)
			PricingArray4 := 0.01
		
		If PricingArray1 is Number
		{
			Loop
				PricingArray1 := PricingArray1 " "
			until strlen(PricingArray1) = 10
		}
		If PricingArray2 is Number
		{
			Loop
				PricingArray2 := PricingArray2 " "
			until strlen(PricingArray2) = 10
		}
		If PricingArray3 is Number
		{
			Loop
				PricingArray3 := PricingArray3 " "
			until strlen(PricingArray3) = 10
		}
		If PricingArray4 is Number
		{
			Loop
				PricingArray4 := PricingArray4 " "
			until strlen(PricingArray4) = 10
		}
		If PricingArray5 is Number
		{
			Loop
				PricingArray5 := PricingArray5 " "
			until strlen(PricingArray5) = 10
		}
		If PricingArray6 is Number
		{
			Loop
				PricingArray6 := PricingArray6 " "
			until strlen(PricingArray6) = 10
		}

		If Finaltext <> ;---- New Line
			FinalText := FinalText "`n"
		
		If Tools_PasteZerosBool
		{
			If (PricingArray1 = 0) and (PricingArray2 = 0)
				PricingArray1 = 0.01
		}
		else
		{
			;Do nothing
		}
		
		FinalText := FinalText PricingArray1 "`t" ;--- Enter Double Rate
		
		If PricingArray6
			FinalText := FinalText PricingArray2 "`t" PricingArray3 "`t" PricingArray4 "`t" PricingArray5 "`t" PricingArray6
		else if PricingArray5
			FinalText := FinalText PricingArray2 "`t" PricingArray3 "`t" PricingArray4 "`t" PricingArray5
		else if PricingArray3
		{
			If PricingArray4
				FinalText := FinalText PricingArray2 "`t" PricingArray3 "`t" PricingArray3 "`t" PricingArray4 "`t" PricingArray3
			else
				FinalText := FinalText PricingArray2 "`t" PricingArray3 "`t" PricingArray3 "`t" PricingArray3
		}
		else if (PricingArray1 = PricingArray2 or (PricingArray1 > PricingArray2 and PricingArray2 > PricingArray1/2))
		{
			If Tools_SingleDouble
				FinalText := FinalText PricingArray1 "`t" PricingArray2 "`t" PricingArray1
			else
				FinalText := FinalText PricingArray2
		}
		else
			FinalText := FinalText PricingArray2
		
		If A_Index <= 27
			Page1 := FinalText
		If A_Index = 27
			FinalText :=
		If a_Index > 27
			Page2 := FinalText
	}

If Page2 <>
	Loopcount := 2
else
	Loopcount := 1

;----- Final Loop? ------
Loop, %LoopCount%
{
	IfWinNotActive ahk_class SDI:TN3270Plus
		gosub ReactivatePolar
	If A_Index = 1
		Clipboard := Page1
	else
		Clipboard := Page2
	Clipwait, 2
	If Errorlevel
		Exit
	
	If A_Index = 2
	{
		Sleep, 250
		Send, {f8}
		Sleep, %PastePolarRatePause%
		SetKeydelay, 50
		Sendevent, +{Enter 2}{Tab 2}
	}
	Sleep, 100
	Send, ^v
	Sleep, 250
	Send, {Enter}
}
return
#ifWinActive

ReactivatePolar:
	WinActivate ahk_class SDI:TN3270Plus
	Sleep, 250
return
;-----------------------------------------------------------------------------------------------------------------------------------
;--------------------------------- Help Section ---------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------
Build_Macro1_OpenOpenNext:
Msgbox, 4,, This will create a macro in Polar called Open - Open - New and assign it to SHFT+CTRL+7. Do you wish to continue?
IfMsgBox No
	Exit
IfMsgBox Yes
{
	WinActivate, AHK_Class SDI:TN3270Plus
	;--Define output text --- Much easier than doing the whole A%A_Space% and `n and etc in the sendEvent
	Macro1Name = Open - Open - New
	Macro1Script = <PF5><Cursorto 528>o<Enter><PF12><Tab><Tab>o<Enter><PF12><,><CursorTo 177><Delete><Delete><Delete><Delete>
	;--Start a loop to navigate polar menus ----
	Loop, 19
	{
		;-- If Polar is not active and Polar Popup window is not active then exit---
		IfWinNotActive, AHK_Class SDI:TN3270Plus
		{
			;-- Check for polar pop up window ----
			IfWinNotActive, AHK_Class #32770
				Exit
		}
		If A_Index = 1 ;-- Escape to home screen, activate Macro Menu
		{
			SendEvent, {Esc}
			Sleep, 450
			SendEvent, !m
		}
		If A_Index = 2 ;-- Select Start Recording on Macro Menu
			SendEvent, s
		If A_Index = 3 ;-- Do a recordable action for the macro so that when it stops it will ask to save --
			SendEvent, {tab}
		If A_Index = 4 ;-- Activate Macro menu again --
			SendEvent, !m
		If A_Index = 5 ;-- Select Stop Recording on Macro Menu
			SendEvent, o
		If A_Index = 6 ;-- Now that the Polar input window pops up, input name of macro
		{
			SendEvent, %Macro1Name%
		}
		If A_Index = 7 ;-- Press enter to press ok button on Polar Popup screen. Saving the macro.
		{
			SendEvent, {Enter}
			Sleep, 200
			IfWinactive, AHK_Class #32770
				SendEvent, {Enter 2}
		}
		If A_Index = 8 ;-- Activate the Macro Menu
			SendEvent, !m
		If A_Index = 9 ;-- Select the Edit Macro submenu
			SendEvent, e
		If A_Index = 10 ;-- Select the top option on the menu. Usually the last recorded macro
			SendEvent, 1
		If A_Index = 11 ;-- Delete the previously recorded tab ---
			SendEvent, {Backspace 10}
		If A_Index = 12 ;-- Put in the new script for the macro.
			SendEvent, %Macro1Script%
		If A_Index = 13 ;-- Tab to the OK button
			SendEvent, {Tab 4}
		If A_Index = 14 ;-- Press the OK button
			SendEvent, {Enter}
		If A_Index = 15 ;-- Activat the Macro Menu
			SendEvent, !m
		If A_Index = 16 ;-- Select Assign Key submenu
			SendEvent, a
		If A_Index = 17 ;-- Select the top macro. usually the last recorded macro
			SendEvent, 1
		If A_Index = 18 ;-- Assign SHIFT+CTRL+"Letter, number, ETC"
			SendEvent, ^+7
		If A_Index = 19 ;-- Save key stroke by hitting the ok button.
		{
			SendEvent, {Enter}
			Sleep, 200
			IfWinActive, AHK_Class #32770
				SendEvent, {Enter}
		}
		Sleep, 200
	}
	WinActivate, Help Screen
	Macro1Name :=
	Macro1Script :=
}
return

Build_Macro2_OpenOpenContinue:
Msgbox, 4,, This will create a macro in Polar called Open - Open - Continue and assign it to SHFT+CTRL+8. Do you wish to continue?
IfMsgBox No
	Exit
IfMsgBox Yes
{
	WinActivate, AHK_Class SDI:TN3270Plus
	;--Define output text --- Much easier than doing the whole A%A_Space% and `n and etc in the sendEvent
	Macro2Name = Open - Open - New
	Macro2Script = <PF5><Cursorto 528>o<Enter><PF12><Tab><Tab>o<Enter><PF12><cursordown>
	;--Start a loop to navigate polar menus ----
	Loop, 19
	{
		;-- If Polar is not active and Polar Popup window is not active then exit---
		IfWinNotActive, AHK_Class SDI:TN3270Plus
		{
			;-- Check for polar pop up window ----
			IfWinNotActive, AHK_Class #32770
				Exit
		}
		If A_Index = 1 ;-- Escape to home screen, activate Macro Menu
		{
			SendEvent, {Esc}
			Sleep, 450
			SendEvent, !m
		}
		If A_Index = 2 ;-- Select Start Recording on Macro Menu
			SendEvent, s
		If A_Index = 3 ;-- Do a recordable action for the macro so that when it stops it will ask to save --
			SendEvent, {tab}
		If A_Index = 4 ;-- Activate Macro menu again --
			SendEvent, !m
		If A_Index = 5 ;-- Select Stop Recording on Macro Menu
			SendEvent, o
		If A_Index = 6 ;-- Now that the Polar input window pops up, input name of macro
		{
			SendEvent, %Macro2Name%
		}
		If A_Index = 7 ;-- Press enter to press ok button on Polar Popup screen. Saving the macro.
		{
			SendEvent, {Enter}
			Sleep, 200
			IfWinactive, AHK_Class #32770
				SendEvent, {Enter 2}
		}
		If A_Index = 8 ;-- Activate the Macro Menu
			SendEvent, !m
		If A_Index = 9 ;-- Select the Edit Macro submenu
			SendEvent, e
		If A_Index = 10 ;-- Select the top option on the menu. Usually the last recorded macro
			SendEvent, 1
		If A_Index = 11 ;-- Delete the previously recorded tab ---
			SendEvent, {Backspace 10}
		If A_Index = 12 ;-- Put in the new script for the macro.
			SendEvent, %Macro2Script%
		If A_Index = 13 ;-- Tab to the OK button
			SendEvent, {Tab 4}
		If A_Index = 14 ;-- Press the OK button
			SendEvent, {Enter}
		If A_Index = 15 ;-- Activat the Macro Menu
			SendEvent, !m
		If A_Index = 16 ;-- Select Assign Key submenu
			SendEvent, a
		If A_Index = 17 ;-- Select the top macro. usually the last recorded macro
			SendEvent, 1
		If A_Index = 18 ;-- Assign SHIFT+CTRL+"Letter, number, ETC"
			SendEvent, ^+8
		If A_Index = 19 ;-- Save key stroke by hitting the ok button.
		{
			SendEvent, {Enter}
			Sleep, 200
			IfWinActive, AHK_Class #32770
				SendEvent, {Enter}
		}
		Sleep, 200
	}
	WinActivate, Help Screen
	Macro2Name :=
	Macro2Script :=
}
return

Build_Macro2_OpenCloseNew:
Msgbox, 4,, This will create a macro in Polar called Open - Close - New and assign it to SHFT+CTRL+9. Do you wish to continue?
IfMsgBox No
	Exit
IfMsgBox Yes
{
	WinActivate, AHK_Class SDI:TN3270Plus
	;--Define output text --- Much easier than doing the whole A%A_Space% and `n and etc in the sendEvent
	Macro3Name = Open - Open - New
	Macro3Script = <PF5><Cursorto 528>o<Enter><PF12><Tab><Tab>c<Enter><PF12><,><CursorTo 177><Delete><Delete><Delete><Delete>
	;--Start a loop to navigate polar menus ----
	Loop, 19
	{
		;-- If Polar is not active and Polar Popup window is not active then exit---
		IfWinNotActive, AHK_Class SDI:TN3270Plus
		{
			;-- Check for polar pop up window ----
			IfWinNotActive, AHK_Class #32770
				Exit
		}
		If A_Index = 1 ;-- Escape to home screen, activate Macro Menu
		{
			SendEvent, {Esc}
			Sleep, 450
			SendEvent, !m
		}
		If A_Index = 2 ;-- Select Start Recording on Macro Menu
			SendEvent, s
		If A_Index = 3 ;-- Do a recordable action for the macro so that when it stops it will ask to save --
			SendEvent, {tab}
		If A_Index = 4 ;-- Activate Macro menu again --
			SendEvent, !m
		If A_Index = 5 ;-- Select Stop Recording on Macro Menu
			SendEvent, o
		If A_Index = 6 ;-- Now that the Polar input window pops up, input name of macro
		{
			SendEvent, %Macro3Name%
		}
		If A_Index = 7 ;-- Press enter to press ok button on Polar Popup screen. Saving the macro.
		{
			SendEvent, {Enter}
			Sleep, 200
			IfWinactive, AHK_Class #32770
				SendEvent, {Enter 2}
		}
		If A_Index = 8 ;-- Activate the Macro Menu
			SendEvent, !m
		If A_Index = 9 ;-- Select the Edit Macro submenu
			SendEvent, e
		If A_Index = 10 ;-- Select the top option on the menu. Usually the last recorded macro
			SendEvent, 1
		If A_Index = 11 ;-- Delete the previously recorded tab ---
			SendEvent, {Backspace 10}
		If A_Index = 12 ;-- Put in the new script for the macro.
			SendEvent, %Macro3Script%
		If A_Index = 13 ;-- Tab to the OK button
			SendEvent, {Tab 4}
		If A_Index = 14 ;-- Press the OK button
			SendEvent, {Enter}
		If A_Index = 15 ;-- Activat the Macro Menu
			SendEvent, !m
		If A_Index = 16 ;-- Select Assign Key submenu
			SendEvent, a
		If A_Index = 17 ;-- Select the top macro. usually the last recorded macro
			SendEvent, 1
		If A_Index = 18 ;-- Assign SHIFT+CTRL+"Letter, number, ETC"
			SendEvent, ^+9
		If A_Index = 19 ;-- Save key stroke by hitting the ok button.
		{
			SendEvent, {Enter}
			Sleep, 200
			IfWinActive, AHK_Class #32770
				SendEvent, {Enter}
		}
		Sleep, 200
	}
	WinActivate, Help Screen
	Macro3Name :=
	Macro3Script :=
}
return

;------ String Region ------------------------------------------------------------------

;------------------------------ Test Region ----------------------------------------------
^t::
	Send, ^a^c
	clipwait, 1
	If errorlevel
		Exit
	stringreplace, Clipboard,Clipboard,`t`t,`t,all
	stringreplace, Clipboard,Clipboard,`t`t,`t,all
	stringreplace, Clipboard,Clipboard,%A_Space%%A_Space%,%A_Space%,all
	stringreplace, Clipboard,Clipboard,%A_Space%%A_Space%,%A_Space%,all
	stringreplace, Clipboard,Clipboard,%A_Space%%A_Space%,%A_Space%,all
	stringreplace, Clipboard,Clipboard,%A_Space%,"Space",all
	stringreplace, Clipboard,Clipboard,`t,"Tab",all
	TestVariable := Clipboard
	Msgbox, %TestVariable%
return

;------------------------------------------------------------------------------------------
#IfWinActive, ahk_Class SDI:TN3270Plus
^o::
	UniqueID1 := Winexist("A")
return

^p::
	UniqueID2 := Winexist("A")
return
#IfWinactive



;-------------------------------------------------------------------------------------------
;------------- Reload AutoHotKey Tools ------------------
^Esc::
	Reload
Return

^0::
	User_MouseCoords()
	Gui, New,,Working IT
	Gui, Add, Button, Default gStandardSubmit, Deactivate
	Gui, Show, w150 h50 X%X_Mouse% Y%Y_Mouse%
	IfwinExist, Working IT
	{
		X = 0
		Loop,
		{
			loop, 60
			{
				IfWinNotExist, Working IT
					Exit
				Sleep, 1000
				Tooltip, %X% Minutes`n%A_Index% Seconds`nExtra Information: %ExtraToolTip%`nActive Window: %Title%
				If (A_Index = 30) or (A_Index = 60)
				{
					Random, RandNumber, 1,5
					SendEvent, !{Tab %RandNumber%}
					Sleep, 200
					WinGetTitle, Title, A
				}
			}
			x += 1
		}
	}
return

StandardSubmit:
	Gui, Submit
	tooltip
return

^+z::
    ; Google image search highlighted text
    Send, ^c
    Sleep 50
	parameter = C:\Program Files (x86)\Google\Chrome\Application\chrome.exe https://www.google.com/search?q="%clipboard%"&num=100&source=lnms&sa=X&ved=0ahUKEwjor_7bmOngAhVNuVkKHQG2AKkQ_AUICSgA&biw=1349&bih=645&dpr=1
    Run %parameter%
Return
