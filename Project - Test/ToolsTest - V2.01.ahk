#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
	SetTitleMatchMode, 1
	winGetTitle, WorkingSpreadsheet, , Copy of DE Excludes, Microsoft Visual Basic
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	CoordMode, Menu, Screen
	Gosub, CreateGUI
return

#include, *i %A_ScriptDir%\Library.ahk

CreateGUI:
	ListOfMacros_Array := Array()
	Loop, Read, ListOfMacros.txt
		ListOfMacros_Array[A_Index] := A_LoopReadLine
	Loop % ListOfMacros_Array.Length()
	{
		If A_Index = 1
			ListText := "|"
		ListText := ListText . "|" . ListOfMacros_Array[A_Index]
		tooltip % A_Index . " - " . ListOfMacros_Array[A_Index]
	}
	WinClose, ListOfMacros.txt
	
	User_MouseCoords()
	Gui, TestScripts:New,, Test Region
	Gui, +AlwaysOnTop -Sysmenu +ToolWindow
	Gui, Add, Text,, Which Script to run? CTRL+1
	Gui, Add, DropdownList, gTest_MenuSelect vTest_Macro sort,%ListText%
	Gui, Add, Text,, Add/Remove Macro Scripts
	Gui, Add, Edit, w120 x10 y70 vAddRemoveMe, 
	Gui, Add, Button, x10 y95 w60 gAddMacro, Add
	Gui, Add, Button, x80 y95 w60 gRemoveMacro, Remove
	Gui, add, button, x10 default w120 gTest_SubmitButton, Deactivate
	Gui, Submit, NoHide
	Gui, TestScripts:show, x%X_Mouse% y%Y_Mouse%
Return

;------ Submit and hide GUI Interface ---------------
Test_SubmitButton:
	Gui, Submit
	ExitApp
return

;----- Submit and don't hide. Used to udpate value in dropdownlist ------------------
Test_MenuSelect:
	Gui, Submit, NoHide
return

AddMacro:
	Gui, Submit
	FileAppend, `n%AddRemoveMe%, ListOfMacros.txt
	GoSub, CreateGUI
return

RemoveMacro:
	Gui, Submit
	Loop % ListOfMacros_Array.length()
	{
		TempArrayVar := ListOfMacros_Array[A_Index]
		Ifinstring, AddRemoveMe, %TempArrayVar%
		{
			ListOfMacros_Array.RemoveAt(A_Index)
		}
	}
	FileDelete, ListOfMacros.txt
	FileOpen(ListOfMacros.txt, "w")
	Loop % ListOfMacros_Array.Length()
	{
		TempVarName := ListOfMacros_Array[A_Index]
		FileAppend, %TempVarName%, ListOfMacros.txt
		If A_Index < ListOfMacros_Array.Length()
			FileAppend, `n, ListOfMacros.txt
	}
	GoSub, CreateGUI
Return

;---- Run Macro selected from list -------------------------------
#IfWinExist, Test Region
^1::
Test_PrimaryMacro:
	Gosub, %Test_Macro%
Return
#IfWinExist

!ESC::Reload

;---- Test Macros -------------------------------------------------
ReformatClipboard:
	Redefineme := Clipboard
	Stringreplace, Redefineme, Redefineme,`t,{Tab},all
	StringReplace, Redefineme, Redefineme,`r,{Return},all
	StringReplace, Redefineme, Redefineme,`n,{Newline}`n,all
	StringReplace, Redefineme, Redefineme,%A_Space%,{Space},all
	Msgbox, %Redefineme%
return

Testscript1:
	Array := ["TestScript1","TestScript2","TestScript3","TestScript4"]
	Loop % Array.Length()
	{
		If A_Index = 1
			ListText := "|"
		ListText := ListText . "|" . Array[A_Index]
		tooltip, %A_Index%
	}
Return

TestScript2:
IP := 600
WinActivate, AHK_Class SDI:TN3270Plus
Loop, Parse, Clipboard, `n, `t `n `r %A_Space%
{
	If A_Loopfield =
		Exit
	SendEvent, %A_Loopfield%{enter}
	Sleep, %IP%
	Loop, 4
	{
		IfWinactive, AHK_Class SDI:TN3270Plus
		{
			SendEvent, s{Enter}
			Sleep, %IP%
			SendEvent, +{f10}
			Sleep, %IP%
			SendEvent, ^a^c
			Clipwait, 1
			If Errorlevel
				Exit
			IfNotInString, Clipboard, Promotion%A_Space%History
			{
				ExtraTooltip := A_Loopfield
			}
			Value1 := Instr(Clipboard, "Z`*`*",,1,1)
			Value2 := Instr(Clipboard, "J`*`*",,1,1)
			
			If Value1 and Value2
			{
				SendEvent, +{f10}Audited{Enter}
				Sleep, %IP%
				SendEvent, {f12 2}{Down}
				Sleep, %IP%
			}
		}
	}
	SendEvent, +{Enter 2}{Tab}+{End}
}
return

TestScript3:
	ClipSearch := "USD" . A_Tab . "UG" . "G"
	ClipSearch2 := "USD" . A_Space . "UG" . "G"
	If (instr(Clipboard, ClipSearch,False,1,1)) or (Instr(Clipboard,ClipSearch2,False,1,1))
	{
		x := (instr(Clipboard, ClipSearch,False,1,1))
		y := (Instr(Clipboard,ClipSearch2,False,1,1))
		PromotionCode_Old := PromoBuild_Promotiontype . PromoArray[A_Index]
		Msgbox, Came back true `n %ClipSearch% `n %x%`n %ClipSearch2%`n %y%
	}
return

TestScript4:
	TodayVal += -2,Days
	Msgbox, %TodayVal%
return

TestScript5:
Inputbox, TestString, Enter Text to search, Enter Text
PolarScreenCheck(TestString)
If PolarScreenCheckBool
	Msgbox, Found it in %Clipboard%
else
	Msgbox, It still continued
return

TestScript_MakePolarMacro:
Msgbox, 4,, This will create a macro in Polar called Open - Open - New and assign it to SHFT+CTRL+7. Do you wish to continue?
IfMsgBox No
	Exit
IfMsgBox Yes
{
	WinActivate, AHK_Class SDI:TN3270Plus
	Macro1Name = Open - Open - New
	Macro1Script = <PF5><Cursorto 528>o<Enter><PF12><Tab><Tab>o<Enter><PF12><,><CursorTo 177><Delete><Delete><Delete><Delete>
		Loop, 19
		{
			IfWinNotActive, AHK_Class SDI:TN3270Plus
			{
				IfWinNotActive, AHK_Class #32770
					Exit
			}
			If A_Index = 1
				SendEvent, !m
			If A_Index = 2
				SendEvent, s
			If A_Index = 3
				SendEvent, {tab}
			If A_Index = 4
				SendEvent, !m
			If A_Index = 5
				SendEvent, o
			If A_Index = 6
			{
				SendEvent, %Macro1Name%
			}
			If A_Index = 7
				SendEvent, {Enter}
			If A_Index = 8
				SendEvent, !m
			If A_Index = 9
				SendEvent, e
			If A_Index = 10
				SendEvent, 1
			If A_Index = 11
				SendEvent, {Backspace 10}
			If A_Index = 12
				SendEvent, %Macro1Script%
			If A_Index = 13
				SendEvent, {Tab 4}
			If A_Index = 14
				SendEvent, {Enter}
			If A_Index = 15
				SendEvent, !m
			If A_Index = 16
				SendEvent, a
			If A_Index = 17
				SendEvent, 1
			If A_Index = 18
				SendEvent, ^+6
			If A_Index = 19
				SendEvent, {Enter}
			Sleep, 200
		}
}
return

AuditExceptionsTest:
	Sleep, 350
	Temp_Clipboard := Clipboard
	Clipboard :=
		Loop, 2
		{
			IfWinNotExist, AHK_Class SDI:TN3270Plus
				exit
			IfWinNotActive, AHK_Class SDI:TN3270Plus
				WinActivate, AHK_Class SDI:TN3270Plus
			IfWinNotActive, AHK_Class SDI:TN3270Plus
				exit
			SendEvent, ^a^c
			Clipwait, 1
			If ErrorLevel
			{
				TooltipNote("Clipboard appears to still be empty...")
				ErrorLevel = 0
				If A_Index = 2
				{
					TooltipNote("Failed to copy polar screen")
					exit
				}
			}
			else
			{
				TooltipNote("Clipboard Filled, Searching for Variable")
				Break
			}
		}
	
	If (instr(Temp_Clipboard, "MN*",,1,1)) and (instr(Temp_Clipboard, "MV*",,1,1)) and (instr(Temp_Clipboard, "MH*",,1,1)) and (instr(Temp_Clipboard, "MS*",,1,1)) and (instr(Temp_Clipboard, "MT*",,1,1)) and (instr(Temp_Clipboard, "M**",,1,1)= 0)
	{
		Tooltip, Passed
		SendEvent, ^q
	}
	else
	{
		Msgbox, Nope Sorry %Var_To_Check%
		Exit
	}
return

