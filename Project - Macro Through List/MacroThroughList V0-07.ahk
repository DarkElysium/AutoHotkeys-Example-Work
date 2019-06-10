#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MacroListButton_Click: ;- Activate GUI upon "AutoHotkey Tools" menu click. Allows Macro Through List Ctrl + 1-6 commands to work.
	Gui_Text := "Macro List"
	Menu_Macroset := 3
	
	Ifwinactive, Work Tools
	{
		Gui, Submit
		User_MouseCoords()
		Gui, MacroRunning:New,, Macro Set Active....
		Gui, +AlwaysOnTop
		Gui, Add, Text,, Macro Set: %Gui_Text% Actived
		;---- Create settings and other buttons ------
		Gui, Add, Button, w90 Section gGui_MacroThroughSettings, Settings
		Gui, Add, Button, w60 ys gGui_MacroThroughHelp, Help
		Gui, Add, Button, x10 Default w100 gokbutton, Deactivate
		Gui, MacroRunning:Show, x%X_Mouse% y%Y_Mouse%
	}
return

Gui_MacroThroughSettings: ;- All Macro Through Settings for All Versions (Eventually anyways).
	If MacroList_PauseLength =
	{
		MacroList_PauseLength = 1000
		PauseTime = 1.0
		MacroList_WindowBool = 0
	}
	User_MouseCoords()
	Winget, PolarWindows, List, AHK_Class SDI:TN3270Plus
	Gui, MacroThroughSettings:New,, Macro Through Settings
	Gui, Add, Text,, What Screen should Polar be on?
	Gui, Add, DropDownList, w150 Center vMacroList_PolarScreen, Promotion List||Promotion Terms|Promotion Exceptions|Promotion Amounts|Cruise Consultant - Menu
	Gui, Add, Text, w90 Section Right, Number of Loops:
	Gui, Add, Text, wp Right,Polar Macro Loops?
	Gui, Add, Edit, w45 ys LEFT Limit4 Number VMacroList_LoopNumber, %MacroList_LoopNumber%
	Gui, Add, Edit, wp left limit2 vMacroList_PolarLoop, %MacroList_PolarLoop%
	Gui, Add, Text, x10 vPText, Pause length (%PauseTime% seconds):
	Gui, Add, Slider, x10 w160 Range100-3500 TickInterval200 Tooltip vMacroList_PauseLength gSaveSliderSettings, %MacroList_PauseLength%
	Gui, Add, Checkbox, x10 vMacroList_WindowBool Checked%MacroList_WindowBool%, Use Multple Polar Windows?
	Gui, Add, Text, vPolar1 y+2, Polar ID 1: %PolarWindows1%
	Gui, Add, Text, vPolar2 y+2, Polar ID 2: %PolarWindows2%
	Gui, Add, Text, vPolar3 y+2, Polar ID 3: %PolarWindows3%
	Gui, Add, Text,, 
	Gui, Add, Button, Default x10 w100 Center gSaveSettings, Save
	Gui, +Resize -MaximizeBox
	X_Mouse := X_Mouse + 125
	Gui, Show, W180 X%X_Mouse% yCenter
return

SaveSliderSettings:
	Gui, Submit, NoHide
	PauseTime := substr(MacroList_PauseLength / 1000,1,3)
	Guicontrol,, PText, Pause length (%PauseTime% seconds):
return

MultiPolarWindow:

return

SaveSettings:
	Gui, Submit, NoHide
	MacroList_Boolean :=
	MacroList_ErrorText := "Error: It appears... `n"
	If MacroList_PolarScreen =
	{
		MacroList_Boolean := 1
		MacroList_ErrorText .= "We don't know what screen the macro should start on"
	}
	If MacroList_Boolean
	{
		Msgbox % "Error: `n" . MacroList_ErrorText
		Exit
	}
	Gui, Submit
return

Gui_MacroThroughHelp:
	Gui, MacroThrough:New,, Macro Through Something
	;---- Create Groupbox -----
	Gui, Add, GroupBox, W200 h75, Help with:
	;---- Create Elements after Groupbox ------
	Gui, add, button, x75 gOkButton, Submit
	;---- Creat Groupbox buttons ------
	Gui, Add, Button, w180 y25 x20 gListMacro1Help, Generic Macro CTRL + 1
	Gui, Add, Button, w180 gListMacro3Help, Voyages/Promos CTRL + 3
	Gui, MacroThrough:Show, w220 X%X_Mouse% Y-200
Return

ListMacro1Help:
	User_MouseCoords()
	Gui, Help:New,, Help Window
	Gui, Font, Bold
	Gui, Add, Groupbox, W300 h400, Generic Macro (Ctrl + 1) Help and Guide: 
	;Gui, Add, Text, w300, Generic Macro (Ctrl + 1) Help and Guide:
	Gui, font, Norm
	Gui, Add, Text, w275 x20 y30, `tGeneric Macro is a basic macro that will run a Macro assigned to "CTRL + Q" in Polar the X amount of times you specify. `n`n`tThis Macro will check everytime if... A: Polar is activated and B: if it is starting on the Polar Screen specified when the macro was first activated.`n`n`tThe limiting drawback is knowing what to set the pause length to as making it too short would mean the Macro can possibly be ran twice which often causes polar to crash.`n`n`tOptions Explained:`n`nNumber of Loops: Specify how many times you want to run the macro between 1-9999 times.`n`nPause Between Looops: Specify how long of pause should exist for the macro to run. To quick would cause the macros to overlap and Polar would crash. To long adds up quickly.`n`nPolar Screen: What screen should polar be on for the macro to run. This does not take you to that screen after running a macro but simply ensures that it is starting on the right screen before proceeding.
	Gui, Help:Show, x%X_Mouse% y-200
return

ListMacro3Help:
	User_MouseCoords()
	Gui, Help:New,, Help Window
	Gui, Font, Bold
	Gui, Add, Groupbox, W300 h400, Generic Macro (Ctrl + 1) Help and Guide: 
	;Gui, Add, Text, w300, Generic Macro (Ctrl + 1) Help and Guide:
	Gui, font, Norm
	Gui, Add, Text, w275 x20 y30, `tGeneric Macro is a basic macro that will run a Macro assigned to "CTRL + Q" in Polar the X amount of times you specify. `n`n`tThis Macro will check everytime if... A: Polar is activated and B: if it is starting on the Polar Screen specified when the macro was first activated.`n`n`tThe limiting drawback is knowing what to set the pause length to as making it too short would mean the Macro can possibly be ran twice which often causes polar to crash.`n`n`tOptions Explained:`n`nNumber of Loops: Specify how many times you want to run the macro between 1-9999 times.`n`nPause Between Looops: Specify how long of pause should exist for the macro to run. To quick would cause the macros to overlap and Polar would crash. To long adds up quickly.`n`nPolar Screen: What screen should polar be on for the macro to run. This does not take you to that screen after running a macro but simply ensures that it is starting on the right screen before proceeding.
	Gui, Help:Show, x%X_Mouse% y-200
return

ListMacro1:
;---- Check if Variables Exist
	If MacroList_LoopNumber not between 1 and 9999
		Exit
	If MacroList_PauseLength not between 0.5 and 120
		Exit
;---- Create Pause Length in Milliseconds ----------------
	Temp_PauseLength := MacroList_PauseLength * 1000
;---- Activate Polar -----------------------------
	WinActivate, AHK_Class SDI:TN3270Plus
;---- Record Start Time --------------------------------
	MacroList_TickStart := A_TickCount
;---- Start Loop per number of loops specified ----------------------------------------
	Loop, %MacroList_LoopNumber%
	{
		;----- If Polar is not active, cancel -----------------
		IfWinNotActive, AHK_Class SDI:TN3270Plus
			Exit
		;----- Find out if on correct screen -----------------
		PolarScreenCheck(MacroList_PolarScreen)
		If PolarScreenCheckBool
		{
			;--- Run Macro ---------
			sendevent, ^q
			sleep, %Temp_PauseLength%
		}
		else
		{
			Msgbox % "It appears we did not return to the correct Screen. We ended on loop " . A_Loopindex
			Exit
		}
		;------ A bunch of stats for elapsed time and time left ----------------------------
		MacroList_Elapsed := round((A_TickCount - MacroList_TickStart)/1000,1)
		MacroList_TimeLeft := round((MacroList_Elapsed/A_Index)*(MacroList_LoopNumber - A_Index))
		MacroList_Minutes := (MacroList_TimeLeft/60)
		MacroList_Minutes := substr(MacroList_Minutes,1,instr(MacroList_Minutes,".",,1,1)-1)
		MacroList_Seconds := MacroList_TimeLeft-(MacroList_Minutes*60)
		MacroList_Seconds := Round(MacroList_Seconds)
		If MacroList_Elapsed > 60
			MacroList_Elapsed := substr(MacroList_Elapsed/60,1,instr(MacroList_Elapsed/60,".",,1,1)-1) . ":" . Round(MacroList_Elapsed - (substr(MacroList_Elapsed/60,1,instr(MacroList_Elapsed/60,".",,1,1)-1)*60))
		User_MouseCoords()
		TooltipText := 
		tooltipnote(A_Loopfield . "`n" . A_index . " of " . MacroList_LoopNumber . " Complete",1)
	}
return

ListMacro2:
;--- List Macro. Parse list and runs CTRL+Q Macro X amount of times.
;---- Create Temp Pause Length ------------------------
	Temp_PauseLength := MacroList_PauseLength * 1000
;---- Activate Polar -----------------------------
	WinActivate, AHK_Class SDI:TN3270Plus
;---- Record Start Time --------------------------------
	MacroList_TickStart := A_TickCount
;---- Start Loop per number of loops specified ----------------------------------------
	ParseVariable := Clipboard
	Loop, parse, ParseVariable,`n,`r`n%A_Space%
	{
		PolarScreenCheck(MacroList_PolarScreen)
		If PolarScreenCheckBool
		{
			If strlen(A_Loopfield) < 4
				Exit
			
			Sendevent, %A_Loopfield%{Enter}
			Sleep, 350
			;--- Run Macro ---------
			Loop, %MacroList_PolarLoop%
			{
				sendevent, ^q
				sleep, %Temp_PauseLength%
			}
			;SendEvent, +{Tab 9}+{End}
			;------ A bunch of stats for elapsed time and time left ----------------------------
			MacroList_Elapsed := round((A_TickCount - MacroList_TickStart)/1000,1)
			MacroList_TimeLeft := round((MacroList_Elapsed/A_Index)*(MacroList_LoopNumber - A_Index))
			MacroList_Minutes := (MacroList_TimeLeft/60)
			MacroList_Minutes := substr(MacroList_Minutes,1,instr(MacroList_Minutes,".",,1,1)-1)
			MacroList_Seconds := MacroList_TimeLeft-(MacroList_Minutes*60)
			MacroList_Seconds := Round(MacroList_Seconds)
			If MacroList_Elapsed > 60
				MacroList_Elapsed := substr(MacroList_Elapsed/60,1,instr(MacroList_Elapsed/60,".",,1,1)-1) . ":" . Round(MacroList_Elapsed - (substr(MacroList_Elapsed/60,1,instr(MacroList_Elapsed/60,".",,1,1)-1)*60))
			User_MouseCoords()
			TooltipText := 
			tooltipnote(A_Loopfield . "`n" . A_index . " of " . MacroList_LoopNumber . " Complete",1)
		}
		Else
		{
			Exit
		}
	}
return

ListMacro3: ;--- List Macro. Parse list and runs CTRL+Q Macro X amount of times.
;---- Activate Polar -----------------------------
	WinActivate, AHK_Class SDI:TN3270Plus
;---- Record Start Time --------------------------------
	MacroList_TickStart := A_TickCount
;---- Create Variable For Clipboard ---------------------
	ParseList := Clipboard
	Clipboard :=
;---- Find out if it is Voyage and promos through a loop count -----
	TabCount = 0
	TestClip := substr(Clipboard,1,instr(Clipboard,"`n",False,1,1))
	Loop,
	{
		If instr(TestClip,"`t",False,1,A_Index) = 0
			break
		else
			TabCount ++
	}
	If TabCount > 1
	{
		Msgbox, To many tabs... %TabCount%
		Exit
	}
;---- Start Loop per number of loops specified ----------------------------------------
	Loop, parse, ParseList,`n
	{
		Tooltip, %A_Loopfield%
		;----- If Polar is not active, cancel -----------------
		IfWinNotActive, AHK_Class SDI:TN3270Plus
			Exit
		;----- Empty Clipboard --------------
		Clipboard :=
		;----- Copy Polar Page ----------------
		If MacroList_PolarScreen <>
		{
			PolarScreenCheck(MacroList_PolarScreen)
			If PolarScreenCheckBool = 0
			{
				Msgbox, Not on correct screen
				Exit
			}
		}
		;--- Record to file which voyage and promo is being worked -----------
		FileAppend, %A_LoopField%`n, C:\Users\c-jkvame\Desktop\VoyageAndPromoStatus.txt
		;--- Parse Loopfield to seperate the 2 variables (Voyage and Promo)
		Loop, Parse, A_Loopfield, `t
		{
			If A_index = 1
			{
				;----- If field is blank then exit --------------------
				If strlen(A_LoopField) < 4 and A_index = 1
					Exit
				SendEvent, %A_Loopfield%
				If strlen(A_Loopfield) < 5
					SendEvent, %A_Loopfield%{Tab}
			}
			If A_Index = 2
			{
				SendEvent, PR%A_Loopfield%
			}
		}
		;---- Run Macro in Polar. It should start and end at the Voyage Input field on Promotion List Screen
		SendEvent, ^q
		;---- Window switching if checkbox is checked and another windows is open ---------
		If (MacroList_WindowBool) and (PolarWindows2)
		{
			IfWinactive, ahk_ID %PolarWindows1%
				Winactivate, ahk_ID %PolarWindows2%
			Ifwinactive, ahk_ID %PolarWindows2%
			{
				If PolarWindows3 <>
					Winactivate, ahk_ID %PolarWindows3%
				else
					WinActivate, ahk_ID %PolarWindows1%
			}
			else
				Winactivate, ahk_ID %PolarWindows1%
		}
		;---- Pause before doing it all again. Trying to run 2 macros at once causes Polar to crash.
		sleep, %MacroList_PauseLength%
	}
return