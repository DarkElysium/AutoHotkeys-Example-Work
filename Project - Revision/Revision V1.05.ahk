﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

PromoRevisionButton_Click:
	Gui_Text := "Promo Revision"
	Menu_Macroset := 2
	Ifwinactive, Work Tools
	{
		Gui, Submit
		User_MouseCoords()
		Gui, MacroRunning:New,, Macro Set Active...
		Gui, +AlwaysOnTop -SysMenu +ToolWindow
		Gui, Font, s8 w700
		Gui, Add, Text,, %Gui_Text% Active...
		Gui, Font, Norm
		Gui, Add, Button, gGui_Revisions, &Settings and Variables
		Gui, add, button, default gRevisionClose, &De-Activate MacroSet
		Gui, MacroRunning:show, x%X_Mouse% y%Y_Mouse%
		GoSub, Gui_Revisions
	}
return

RevisionClose:
	Gui, Submit
return

Gui_Revisions:
	Gui, ReviseOps:Show, x%X_Mouse% y%Y_Mouse%
	Ifwinnotexist, Options for Promo Revisions
	{
	;----- Main GUI Options --------------------------------------------------------
		gui, ReviseOps:New,, Options for Promo Revisions
		Gui, +Alwaysontop
		;---- Column 1 -----
		gui, add, text, x5 y8, Currency:
		gui, add, text, x5 y+15, Type of Promo:
		Gui, Add, Text, x5 y+15, Quick Stamp:
		;---- Column 2 ------
		gui, add, DropDownList, x100 y5 W60 vRevision_Currency choose%Revision_Currency% Uppercase, |USD||AUD|EUR|GBP
		gui, add, ComboBox, w100 limit3 vRevision_PromotionType Choose%Revision_PromotionType% Uppercase, ||NS|KR|FL|QF|YM|YN|YP
		Gui, Add, DropDownList, w100 AltSubmit vRevision_QuickStamp choose%Revision_QuickStamp%, ||End of Day|ASAP (15 min)|ASAP(1 hour)|WNN

	;----- Gui Revision Options --------------------------------------------------------
		gui, add, groupbox, w220 h100 x5 y95, Revision Options
		;---- Column 1 -----
		gui, Add, text, x14 y115, Start Day:
		gui, add, text, , Start Time:
		gui, Add, Checkbox, y+15 vRevision_TimeStampOnly, Time Stamp Only
		;---- Column 2 -----
		gui, add, edit, w100 x115 y110 limit7 vRevision_Date, %Revision_Date%
		gui, add, edit, w100 limit4 vRevision_Time, %Revision_Time%

	;----- Global Commands and Submit Button --------------------------------------------------------
		gui, add, button, x20 default w100 gSubmitRevisionOptions, Submit
		Gui, Show, x%X_Mouse% y%Y_Mouse%
	}
Return

SubmitRevisionOptions:
	Gui, Submit, NoHide
;-------------- Update GUI Values --------------------------
	GuiControl, ,Revision_PromotionType, |%Revision_PromotionType%||NS|KR|QA|QF|YM|YN|YP
	;----------- Reset Variables ----------------------
		CurrencyError :=
		TypeError :=
	;----------- Check that Variables Exist ----------------
	If Revision_Currency not in AUD,GBP,EUR,USD
		CurrencyError := "No valid Currency Selected..."
	if substr(Revision_PromotionType,1,2) not between AA and ZZ
		TypeError := "No Promotion Type available."
	;---------- Check that a time and date exist -----------
	If Revision_QuickStamp = 1
	{
		if (strlen(Revision_Date) <> 7) or (strlen(Revision_Time) <> 4)
		{
			Msgbox, Need a Date and time for the time stamp.
			Exit
		}
	}
	else If Revision_QuickStamp in 2,3,4
	{
		FormatTime, Revision_Date,,ddMMMyy
		If Revision_QuickStamp = 2 ;---- EOD -----
		{
			Revision_TempHour := 17
			Revision_TempMinute := "00"
		}
		Else if Revision_QuickStamp = 3 ;---- ASAP 15 Minutes -----
		{
			FormatTime, Revision_TempHour,,HH
			FormatTime, Revision_TempMinute,,mm
			Revision_TempMinute := Round(Revision_TempMinute/15)*15
			If (Revision_TempMinute + 15) = 60
			{
				Revision_TempMinute := "00"
				Revision_TempHour := (Revision_TempHour + 1)
			}
			else If (Revision_TempMinute + 15) > 60
			{
				Revision_TempMinute := (Revision_TempMinute + 15) - 60
				Revision_TempHour := (Revision_TempHour + 1)
			}
			else
			{
				Revision_TempMinute := (Revision_TempMinute + 15)
			}
		}
		Else if Revision_QuickStamp = 4 ;---- ASAP 1 Hour -----
		{
			FormatTime, Revision_Date,,ddMMMyy
			FormatTime, Revision_TempHour,,HH
			FormatTime, Revision_TempMinute,,mm
			Revision_TempMinute := Round(Revision_TempMinute/15)*15
			Revision_TempHour := (Revision_TempHour + 1)
		}
		
		;----- Clean up time numbers -------------------
		If strlen(Revision_TempMinute) < 2
			Revision_TempMinute := 0 . Revision_TempMinute
		If strlen(Revision_TempHour) < 2
			Revision_TempHour := 0 . Revision_TempHour
		;---- Assign to Revision_Time ------------------
		Revision_Time := Revision_TempHour . Revision_TempMinute
	}
	else If Revision_QuickStamp = 5
	{			
		Revision_Date := "10Dec18"
		Revision_Time := "1500"
	}
	
	;------- Save Revision Time and Date ---------------------------
	GuiControl, ,Revision_Date, %Revision_Date%
	GuiControl, ,Revision_Time, %Revision_Time%
	;-------- Check that all variables exist -----------------------
	If Revision_Date and Revision_Time and (CurrencyError = "") and (TypeError = "")
		Gui, Submit
	else
		Msgbox % "Looks like some variables are missing...`n" . CurrencyError . "`n" . TypeError
Return

#IfwinActive, AHK_CLass SDI:TN3270Plus
Revision_Step1:
;------ Start Tooltip --------------------
	User_MouseCoords()
	Revision_StatusStep = 1
	Gosub, Revision_StatusUpdate
	GoSub, RevisionStartTimer
	;----- If timestampe only, skip the rest ----------------
	If Revision_TimeStampOnly <> 1
	{
	;----- Full timestamp build -----------------------------------------
	;----- Save Clipboard to variable -------
		Revision_Voyage :=
		Revision_StatusStep = 2
		Gosub, Revision_StatusUpdate
	;---- Clean up Clipboard -------------------
		Revision_Voyage := trim(Clipboard)
		Stringreplace, Revision_Voyage, Revision_Voyage, %A_Space%,,all
		StringReplace, Revision_Voyage, Revision_Voyage, %A_Tab%,,all
		StringReplace, Revision_Voyage, Revision_Voyage, `n,,all
		StringReplace, Revision_Voyage, Revision_Voyage, `r,,all
	;---- Check if Clipboard contains a voyage ----------
		If strlen(Revision_Voyage) between 4 and 5
		{
			User_MouseCoords()
			Revision_StatusStep = 3
			Gosub, Revision_StatusUpdate
		}
		else
		{
			RevisionText .= "No voyage copied...Exiting.`n"
			TooltipNote(RevisionText,1)
			GoSub, Revision_ExitSequence
		}
		Clipboard :=
		;----- Find CPRO Screen ----------------
		loop, 3
		{
			IfWinnotActive, AHK_Class SDI:TN3270Plus
			{
				TooltipNote("Polar Not Active... Exiting.",1)
				GoSub, Revision_ExitSequence
			}
			;------ Fill in clipboard by copying polar screen. Try twice -----------------
			Loop, 2
			{
				Clipboard :=
				Sendevent, ^a^c
				Clipwait, 1
				If Errorlevel and (A_Index = 2)
				{
					TooltipNote("Was not able to copy Polar Screen... Exiting.",1)
					GoSub, Revision_ExitSequence
				}
				else if ErrorLevel
					sleep, 300
				else
					break
			}
			;----- Find Location in Polar ------------------
			Ifinstring, Clipboard, Promotion%A_Space%List
			{
				Break
			}
			Else If Index = 3
			{
				TooltipNote("Did not get to a recognizeable screen... Exiting.",1)
				GoSub, Revision_ExitSequence
			}
			else
			{
				Sleep, 300
				SendEvent, {ESC}
				Sleep, 300
				Sendevent, {F5}CPRO{Enter}
				Sleep, 300
				Sendevent, +{F4}
			}
			sleep, 800
			Revision_StatusStep = 4
			Gosub, Revision_StatusUpdate
		} ;----- End Find CPRO Loop -----------------------------------------------------------
			Revision_StatusStep = 5
			Gosub, Revision_StatusUpdate
		;------- Create Clipboard ----------------------
		Clipboard := "o`t"
		Clipboard .= Revision_Voyage
		If strlen(Revision_Voyage) = 4
			Clipboard .= " "
		Clipboard .= "`tpr`t"
		Clipboard .= Revision_PromotionType
		If strlen(Revision_PromotionType) = 2
			Clipboard .= "*"
		Clipboard .= "`t`t"
		Clipboard .= Revision_Currency
		;----- End Create Clipboard ----------------------------
		;----- Input info into polar ---------------------------
		Loop, 4
		{
			Ifwinnotactive, AHK_Class SDI:TN3270Plus
			{
				TooltipNote("Polar not active... Exiting.",1)
				GoSub, Revision_ExitSequence
			}
			If Revision_TimeStampOnly = 0
			{
				If A_index = 1
				{
					Revision_StatusStep = 6
					Gosub, Revision_StatusUpdate
					SendEvent, {f5}
				}
				If A_Index = 2
				{
					Revision_StatusStep = 7
					Gosub, Revision_StatusUpdate
					sendevent, +{Tab 10}^v{Enter}
				}
				If A_Index = 3
				{
					Revision_StatusStep = 8
					Gosub, Revision_StatusUpdate
					SendEvent, S{Enter}
				}
				If A_Index = 4
				{

					PolarScreenCheck(Revision_Voyage)
					If PolarScreenCheckBool = 0
						GoSub, Revision_ExitSequence
					Revision_StatusStep = 9
					Gosub, Revision_StatusUpdate
					SendEvent, +{F9}
				}
			}
			Sleep, 300
			TooltipNote(RevisionText,1)
		}
	}
	
		Sleep, 300
		Loop, 2
		{
			If A_Index = 1
			{
				Sendevent, ^a^c
				Clipwait,1
				If Errorlevel
					GoSub, Revision_ExitSequence
				If (instr(Clipboard,Revision_Voyage,,1,1) > 1) and (instr(Clipboard,Revision_Currency,,1,1) > 1) and (instr(Clipboard,Revision_PromotionType,,1,1) > 1)
				{
					Revision_StatusStep = 10
					Gosub, Revision_StatusUpdate
					SendEvent, +{f1}
				}
				else
				{
					RevisionText .= "Not on pricing screen... Exiting.`n"
					TooltipNote(RevisionText,1)
					;Msgbox % instr(Clipboard,Revision_Voyage,,1,1) . "`n" . instr(Clipboard,Revision_Currency,,1,1) . "`n" . instr(Clipboard,Revision_PromoType,,1,1)
					GoSub, Revision_ExitSequence
				}
				Sleep, 300
			}
			If A_Index = 2
			{
				Revision_StatusStep = 11
				Gosub, Revision_StatusUpdate
				SendEvent, %Revision_Date%%Revision_Time%
			}
		}
		Revision_StatusStep = 12
		Gosub, Revision_StatusUpdate
Revision_ExitSequence:
	GoSub, RevisionStopTimer
	Exit
return

RevisionStartTimer:
;--------- Create Timer --------------
	TimerVarA := A_TickCount
	RevisionText .= "Timer Started...`n"
	TooltipNote(RevisionText,1)
return

RevisionStopTimer:
;----- Display timer ---------------------
	TimerVarB := (A_Tickcount - TimerVarA)/1000
	RevisionText .= TimerVarB . " Seconds"
	TooltipNote(RevisionText,1)
return

Revision_StatusUpdate:
If status_Step = 1
	RevisionText = Revision macro started...`n
else if status_step = 2
	RevisionText .= "Confirming Voyage..."
else if status_step = 3
	RevisionText .= Revision_Voyage . "`n"
else if status_step = 4
	RevisionText .= "Found location in polar...`n"
else if status_step = 5
	RevisionText .= "Checking for what promo to look for...`n"
else if status_step = 6
	RevisionText .= "Refreshing screen/cursor location...`n"
else if status_step = 7
	RevisionText .= "Entering search info...`n"
else if status_step = 8
	RevisionText .= "Selecting open promo...`n"
else if status_step = 9
	RevisionText .= "Navigating to pricing screen...`n"
else if status_step = 10
	RevisionText .= "Creating timestamp...`n"
else if status_step = 11
	RevisionText .= "Adding in start date and time...`n"
else if status_step = 12
	RevisionText .= "Complete. Awaiting finalization.`n"
TooltipNote(RevisionText,1)
return

Revision_ExitReason:
	TooltipNote("Polar Not Active... Exiting.",1)
	RevisionText .= "No voyage copied...Exiting.`n"
	TooltipNote("Was not able to copy Polar Screen... Exiting.",1)
	TooltipNote("Did not get to a recognizeable screen... Exiting.",1)
	TooltipNote("Polar not active... Exiting.",1)
	RevisionText .= "Not on pricing screen... Exiting.`n"
return
		
		
