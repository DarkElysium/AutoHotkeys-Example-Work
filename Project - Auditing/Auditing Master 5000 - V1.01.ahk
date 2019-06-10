﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

AuditingButton:
	Gui_Text := "Auditing"
	Menu_Macroset := 4
	
	Ifwinactive, Work Tools
	{
		Gui, Submit
		
		User_MouseCoords()
		
		Gui, MacroRunning:New,, Macro Set Active...
		gui, +AlwaysOnTop
		Gui, Add, Text,, %Gui_Text% Active...
		Gui, add, button, default w100 gokbutton, Deactivate
		gui, MacroRunning:show, x%X_Mouse% y%Y_Mouse%
	}
return

!s::
	Msgbox,4,Save New Version?, "Would you like to save a new version?"
		IfMsgbox yes
		{
			Loop, 30
			{
				y :=
				If %A_Index% < 10
					y := "0" . A_Index
				else
					y := A_Index
				
				ChiChi := "Auditing Master 5000 - V1." . y . ".ahk"
				IfnotExist, %ChiChi%
					break
				LastChiChi := ChiChi
			}
			filecopy, %lastChiChi%, %ChiChi%
			Msgbox, "Be sure to close this script and open the new one"
		}
		IfMsgbox no
		{
			
		}
return

#IfWinActive ahk_Class SDI:TN3270Plus
AuditingCommand1:
	Clipboard :=
	Sendevent, ^a^c
	Clipwait,1
	if errorlevel
	{
		msgbox, did not copy rates...
		Exit
	}
	;StringReplace, Clipboard, Clipboard, `t, Tab,All
	StringReplace, Clipboard, Clipboard, %A_Space%,,All
	;Msgbox % Clipboard
	IfInString, Clipboard, PromotionTerms
	{
		TemplateScreen1 := Clipboard
	;----- Find todays date on Template Screen 1 -------------
		IfInString, TemplateScreen1, PHRS
			TemplateToday := substr(TemplateScreen1,instr(TemplateScreen1, "PHRS",false, 1,1)+5,7)
		else
			TemplateToday := substr(TemplateScreen1,instr(TemplateScreen1, PBRS,false, 1,1)+5,7)
	;---- Seperate Product Load section and extract Voyage, Sail Date, lenght/product, ship, and ports
		TemplateProduct := substr(TemplateScreen1, instr(TemplateScreen1, "Product:",1,1)+8,Instr(TemplateScreen1, "Voy:",False,1,1)-instr(TemplateScreen1, "Product:",1,1)-8)
		StringReplace, TemplateProduct, TemplateProduct,`t,,all
		StringReplace, TemplateProduct, TemplateProduct, %A_Space%,,All
		StringReplace, TemplateProduct, TemplateProduct, `n,,All
		StringReplace, TemplateProduct, TemplateProduct, `r,,All
		Stringsplit, TemplateProduct, TemplateProduct, `/
		TemplateScreen_Voyage := TemplateProduct1
		TemplateScreen_SailDate := TemplateProduct2
		StringSplit, TemplateProduct3, TemplateScreen_SailInfo,`-
		TemplateScreen_SailLength := substr(TemplateProduct3,1,3)
		TemplateScreen_SailProduct := substr(TemplateProduct3,5,3)
		Templatescreen_Ship := TemplateProduct4
		TemplateScreen_Ports := TemplateProduct5
	;--- Get Promo Number
		TemplateScreen_Promo := substr(TemplateScreen1,instr(TemplateScreen1, "Promo:",false,1,1)+7,3)
	;--- Get TemplateScreen Status
		TemplateScreen_Status := substr(TemplateScreen1,instr(templateScreen1, "St:`t",False,1,1)+4,1)
	;--- Get TemplateScreen Currency
		TemplateScreen_Currency := Substr(TemplateScreen1,instr(TemplateScreen1, "Curr:`t",False,1,1)+6,3)
	;--- Get Description more or less
		TemplateScreen_Description := substr(TemplateScreen1,instr(TemplateScreen1,"Desc:",1,1)+6)
		TemplateScreen_Description := Substr(TemplateScreen_Description,1,instr(Templatescreen_description,"CrsD:",1,1))
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, %a_Space%,,All
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, `t,,All
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, `r,,All
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, `n,,All
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, Meta1-2:,`n,All
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, Replaces:,`n,All
		StringReplace, TemplateScreen_Description, TemplateScreen_Description, MaxPax:0,`n,All
	;--- Get Crsd
		TemplateScreen_CRSD := substr(TemplateScreen1, instr(TemplateScreen1,"Crsd:",False,1,1)+6)
		TemplateScreen_CRSD := substr(TemplateScreen_CRSD,1,instr(TemplateScreen_CRSD,"Cntl:",false,1,1))
		TemplateScreen_CRSD := substr(TemplateScreen_CRSD,1,instr(TemplateScreen_CRSD,A_Tab,false,1,1))
	
	}
	;msgbox % TemplateScreen1
	listvars
return

AuditingCommand2:
;Cheap and dirty template to audit from
	SendEvent, ^a^c
	clipwait, 1
	if errorlevel
		Exit

	StringReplace, Clipboard, Clipboard, %A_Space%,,All
	StringReplace, Clipboard, Clipboard, `t,,All
	StringReplace, Clipboard, Clipboard, `r,,All
	StringReplace, Clipboard, Clipboard, `n,,All
	
	TemplateTest := Clipboard
	TemplateTest := substr(Templatetest,instr(TemplateTest,"Curr:",False,1,1))
	TemplateTest := substr(TemplateTest,1,instr(TemplateTest,"13Temp",1,1))
	TemplateOpened := substr(TemplateTest,instr(TemplateTest,"Opened:",False,1,1),21)
	TemplateChanged := substr(TemplateTest,instr(TemplateTest,"Changed:",False,1,1),22)
	TemplateEffective := substr(TemplateTest,instr(TemplateTest,"Effective:",False,1,1),17)
	TemplateActivate := substr(TemplateTest,instr(TemplateTest,"Activate:",False,1,1),16)
	TemplateShutoff := substr(TemplateTest,instr(TemplateTest,"Shutoff:",False,1,1),15)
	
	StringReplace, TemplateTest, TemplateTest, %TemplateOpened%,,All
	StringReplace, TemplateTest, TemplateTest, %TemplateChanged%,,All
	StringReplace, TemplateTest, TemplateTest, %TemplateEffective%,,All
	StringReplace, TemplateTest, TemplateTest, %TemplateActivate%,,All
	StringReplace, TemplateTest, TemplateTest, %TemplateShutoff%,,All
	;Msgbox % TemplateTest
	;ListVars
	
return

AuditingCommand3:
;Cheap and dirty version of a promo to compare to template
	SendEvent, ^a^c
	clipwait, 1
	if errorlevel
		Exit

	StringReplace, Clipboard, Clipboard, %A_Space%,,All
	StringReplace, Clipboard, Clipboard, `t,,All
	StringReplace, Clipboard, Clipboard, `r,,All
	StringReplace, Clipboard, Clipboard, `n,,All
	
	AuditingTest := Clipboard
	AuditingTest := substr(Auditingtest,instr(AuditingTest,"Curr:",False,1,1))
	AuditingTest := substr(AuditingTest,1,instr(AuditingTest,"13Temp",1,1))
	AuditingOpened := substr(AuditingTest,instr(AuditingTest,"Opened:",False,1,1),21)
	AuditingChanged := substr(AuditingTest,instr(AuditingTest,"Changed:",False,1,1),Instr(AuditingTest,"PayPen",False,1,1)-instr(AuditingTest,"Changed:",false,1,1))
	AuditingEffective := substr(AuditingTest,instr(AuditingTest,"Effective:",False,1,1),17)
	AuditingActivate := substr(AuditingTest,instr(AuditingTest,"Activate:",False,1,1),16)
	AuditingShutoff := substr(AuditingTest,instr(AuditingTest,"Shutoff:",False,1,1),15)
	
	StringReplace, AuditingTest, AuditingTest, %AuditingOpened%,,All
	StringReplace, AuditingTest, AuditingTest, %AuditingChanged%,,All
	StringReplace, AuditingTest, AuditingTest, %AuditingEffective%,,All
	StringReplace, AuditingTest, AuditingTest, %AuditingActivate%,,All
	StringReplace, AuditingTest, AuditingTest, %AuditingShutoff%,,All
	
	ifequal, TemplateTest, %AuditingTest%
	{
		send, +{f9}
		sleep, 450
		gosub, CopyPolarRates
	}
	else
		msgbox % TemplateTest "`n" AuditingTest
return

#IfWinActive
