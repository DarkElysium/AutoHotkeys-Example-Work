#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;------Build Menu Variables -------
BuildMacro_EraseVariables:
	BuildMacro_BBStatus :=
	BuildMacro_CampaignCode1 :=
	BuildMacro_CampaignCode2 :=
	BuildMacro_CampaignCode3 :=
	BuildMacro_CampaignCode4 :=
	BuildMacro_CampaignCode5 :=
	BuildMacro_Currency :=
	BuildMacro_ExpireDate :=
	BuildMacro_ExpireSailBool :=
	BuildMacro_PromotionType :=
	BuildMacro_StartDate :=
	BuildMacro_StartDateBool :=
	BuildMacro_Status1 :=
	BuildMacro_TemplateCode :=
	BuildMacro_TemplateCurrency :=
	BuildMacro_TemplateVoyage :=
return

PromoBuildingButton_Click:
	Gui_Text := "Promo Building"
	Menu_Macroset := 1
	
	Ifwinactive, Work Tools
	{
		Gui, Submit
		User_MouseCoords()
		Gui, MacroRunning:New,, Building Tool Active
		gui, +AlwaysOnTop -SysMenu +ToolWindow
		Gui, Add, Text,, %Gui_Text% Active...
		Gui, Add, Button, default w200 gCreateGui_BuildingScreen, Settings, Variables, and Help
		Gui, add, button, default w100 gokbutton, Deactivate
		gui, MacroRunning:show, x%X_Mouse% y%Y_Mouse%
	}
	
	CreateGui_BuildingScreen:
	;--- Get mouse Coordinates -----
		User_MouseCoords()
	;--- Show BuildOps window at Mouse Coords
		Gui, BuildOps:Show, x%X_Mouse% y%Y_Mouse%

		IfWinNotExist, Options for Building Promotions
		{
			Gosub Gui_Building
			Gui, show, x%X_Mouse% y%Y_Mouse%
		}
return

Gui_Building:
;----- Main GUI Options --------------------------------------------------------
	gui, BuildOps:New,, Options for Building Promotions
	Gui, +Alwaysontop -Sysmenu +ToolWindow
	;------- Currency & Promo Type -------------------
	Gui, Add, Text, w100 Right Section, Currency:
	Gui, Add, Text, wp Y+15 Right, Type of Promo:
	Gui, Add, DropDownList, ys w100 Left vBuildMacro_Currency choose%BuildMacro_Currency% Uppercase, USD||AUD|EUR|GBP
	Gui, Add, Edit, w100 Left Limit3 vBuildMacro_PromotionType Choose%BuildMacro_PromotionType% Uppercase, %BuildMacro_PromotionType%
	
	gui, add, Tab3,x5 y70 h250, Time/Date||Template|Campaigns|Options
;----- Gui Build Options --------------------------------------------------------
	Gui, Tab, Time/Date
	Gui, Add, Text, X20 Y100 w100 Right Section, Start Date:
	Gui, Add, Text, wp Right, Expiration Date:
	Gui, Add, Text, wp Right, Start Date Today?
	Gui, Add, Text, wp Right, Expire on Sail Date?
	Gui, Add, Text, wp Right, Start = Sail Date minus:
	Gui, Add, Edit, ys w100 Limit7 Left UpperCase vBuildMacro_StartDate, %BuildMacro_StartDate%
	Gui, Add, Edit, wp Limit7 Left UpperCase vBuildMacro_ExpireDate, %BuildMacro_ExpireDate%
	Gui, Add, Checkbox, w100 Y+9 Left vBuildMacro_StartDateBool,
	Gui, Add, Checkbox, wp Y+9 Left vBuildMacro_ExpireSailBool,
	Gui, Add, Edit, wp Limit3 left Number vBuildMacro_MinusSailDate, %BuildMacro_MinusSaileDate%
	Gui, Add, Button, w75 Center gBuildMacro_ClearTimeDate, Clear
;----- Gui Template Options ---------------------------------------------------------------------------------
	Gui, Tab, Template
	Gui, Add, Text, X20 Y100 w100 Right Section, Template Voyage:
	Gui, Add, Text, wp Right, Template Promo:
	Gui, Add, Text, wp Right, Template Currency:
	Gui, Add, Edit, ys w100 Left limit5 Uppercase vBuildMacro_TemplateVoyage, %BuildMacro_TemplateVoyage%
	Gui, Add, Edit, wp Left Limit3 Uppercase vBuildMacro_Templatecode, %BuildMacro_TemplateCode%
	Gui, Add, DropDownList, wp Left UpperCase vBuildMacro_TemplateCurrency choose%BuildMacro_TemplateCurrency%, ||USD|AUD|EUR|GBP
	Gui, Add, Button, w75 Center gBuildMacro_ClearTemplate, Clear
;----- Gui Campaign Options --------------------------------------------------------
	Gui, Tab, Campaigns
	Gui, Add, Text, X20 Y100 w100 Right Section, Campaigns:
	Gui, Add, Edit, wp Right Limit10 Uppercase vBuildMacro_CampaignCode1, %BuildMacro_CampaignCode1%
	Gui, Add, Edit, wp Right Limit10 Uppercase vBuildMacro_CampaignCode2, %BuildMacro_CampaignCode2%
	Gui, Add, Edit, wp Right Limit10 Uppercase vBuildMacro_CampaignCode3, %BuildMacro_CampaignCode3%
	Gui, Add, Edit, wp Right Limit10 Uppercase vBuildMacro_CampaignCode4, %BuildMacro_CampaignCode4%
	Gui, Add, Edit, wp Right Limit10 Uppercase vBuildMacro_CampaignCode5, %BuildMacro_CampaignCode5%
	Gui, Add, Text, ys wp Center, Enable Campaign:
	Gui, Add, Checkbox, w100 Y+10 XP+15 vBuildMacro_Campaign1Bool,
	Gui, Add, Checkbox, wp Y+14 xp vBuildMacro_Campaign2Bool,
	Gui, Add, CheckBox, wp Y+14 xp vBuildMacro_Campaign3Bool,
	Gui, Add, Checkbox, wp Y+14 xp vBuildMacro_Campaign4Bool,
	Gui, Add, Checkbox, wp Y+14 xp vBuildMacro_Campaign5Bool,
	Gui, Add, Button, w75 Center gBuildMacro_ClearCampaigns, Clear
	
;------ Gui Options ---------
	Gui, Tab, Options
	Gui, Add, Text, X20 Y100 w100 Right Section, CPRO Search Status:
	Gui, Add, DropDownList, ys w50 vBuildMacro_Status1 choose%BuildMacro_Status1%, ||O|T|C
	Gui, Add, Text, x20 y130 w100 Left Section, Build All Options:
	Gui, Add, DropDownList, x20 y145 w200 left vBuildMacro_BuildAllOption Choose%BuildMacro_BuildAllOption% AltSubmit, All Steps||New Voyage - No flags|New Voyage - Change Flags
;------ Gui Other commands ------------
	Gui, Tab
;----- Global Commands and Submit Button --------------------------------------------------------
	gui, add, text, x5 w100 Right Section,Best Buy Flag Status:
	gui, add, DropDownList, ys w100 Center vBuildMacro_BBStatus choose%BuildMacro_BBStatus%, |Yes||No|
	gui, add, button,x5 default w100 Section gsubmitOptions, Submit
	Gui, Add, Button, ys w100 Center gSubmitCancel, Cancel
Return

;------ Submit Button ----------------------------
SubmitOptions:
	Gui, Submit, NoHide
;---- Reset Variables --------------------------------
	Gosub, Reset_BuildVariables
;-------------- Update GUI Values --------------------------
	;----- If Start Date Today is checked, Get Today Variable in Polar Format -----------
	If BuildMacro_StartDateBool
		Formattime, BuildMacro_StartDate,, ddMMMyy
	;----- Add Variables to the menu for the next time it is loaded ----------------
	GuiControl, ,BuildMacro_StartDate, %BuildMacro_StartDate%
	GuiControl, ,BuildMacro_ExpireDate, %BuildMacro_ExpireDate%
	;------ Check if all variables are there ---------------------------------------
	If BuildMacro_PromotionType between AA and ZZ
		Gui, Submit
	else
		Msgbox, Need a valid Promo code to operate.
	;----- Create copies of menu variables to manipulate ---------------------------
	PromoBuild_BestBuy := substr(BuildMacro_BBStatus,1,1)
	PromoBuild_CampaignCode1 := BuildMacro_CampaignCode1
	PromoBuild_CampaignCode2 := BuildMacro_CampaignCode2
	PromoBuild_CampaignCode3 := BuildMacro_CampaignCode3
	Promobuild_CampaignCode4 := BuildMacro_CampaignCode4
	Promobuild_CampaignCode5 := BuildMacro_CampaignCode5
	Promobuild_Currency := BuildMacro_Currency
	PromoBuild_Shutoff := BuildMacro_ExpireDate
	If BuildMacro_Status1 =
		BuildMacro_Status1 := A_Space
	PromoBuild_Status1 := BuildMacro_Status1
	PromoBuild_PromotionType := BuildMacro_PromotionType
	PromoBuild_Effective := BuildMacro_StartDate
;----- Template variables --------------------------------------
	;----- Make Voyage name 5 letters long to erase extra characters when pasted -----------
	If strlen(BuildMacro_TemplateVoyage) = 4
		PromoBuild_TemplateVoyage := BuildMacro_TemplateVoyage . A_Space
	else
		PromoBuild_TemplateVoyage := BuildMacro_TemplateVoyage
	PromoBuild_TemplateCode := BuildMacro_TemplateCode
	;------ If Template Currency is blank, use promotion currency.
	If BuildMacro_TemplateCurrency =
		PromoBuild_TemplateCurrency := BuildMacro_Currency
	else
		PromoBuild_TemplateCurrency := BuildMacro_TemplateCurrency
Return

SubmitCancel:
	Gui, Destroy
Return

BuildMacro_ClearTimeDate:
	GuiControl,, BuildMacro_StartDate,
	GuiControl,, BuildMacro_ExpireDate,
	GuiControl,, BuildMacro_StartDateBool,0
	GuiControl,, BuildMacro_ExpireSailBool,0
return

BuildMacro_ClearTemplate:
	GuiControl,, BuildMacro_TemplateVoyage,
	GuiControl,, BuildMacro_TemplateCode,
	GuiControl,, BuildMacro_TemplateCurrency,
return

BuildMacro_ClearOptions:

return

BuildMacro_ClearCampaigns:
	GuiControl,, BuildMacro_CampaignCode1,
	GuiControl,, BuildMacro_CampaignCode2,
	GuiControl,, BuildMacro_CampaignCode3,
	GuiControl,, BuildMacro_CampaignCode4,
	GuiControl,, BuildMacro_CampaignCode5,
	GuiControl,, BuildMacro_Campaign1Bool,0
	GuiControl,, BuildMacro_Campaign2Bool,0
	GuiControl,, BuildMacro_Campaign3Bool,0
	GuiControl,, BuildMacro_Campaign4Bool,0
	GuiControl,, BuildMacro_Campaign5Bool,0
return

Reset_BuildVariables:
;--------------- Variables ---------------------------------------------
	PromoBuild_AgyType :=
	PromoBuild_Air :=
	PromoBuild_AirDisc :=
	PromoBuild_AmenPoints :=
	PromoBuild_AppAmen :=
	PromoBuild_AppGrp :=
	PromoBuild_Auto :=
	PromoBuild_Benchmark :=
	PromoBuild_BestBuy :=
	PromoBuild_CampaignCode1 :=
	PromoBuild_CampaignCode2 :=
	PromoBuild_CampaignCode3 :=
	PromoBuild_CampaignCode4 :=
	PromoBuild_CampaignActive :=
	PromoBuild_CampaignType :=
	PromoBuild_Child :=
	PromoBuild_CombAir :=
	PromoBuild_Combinable :=
	PromoBuild_Commission :=
	PromoBuild_CRSD1 :=
	PromoBuild_CRSD2 :=
	PromoBuild_Currency :=
	PromoBuild_Desc1 :=
	PromoBuild_Desc2 :=
	PromoBuild_Desc3 :=
	PromoBuild_Desc4 :=
	PromoBuild_Dining :=
	PromoBuild_Effective :=
	PromoBuild_FareType :=
	PromoBuild_GDS :=
	PromoBuild_IncludeAir :=
	PromoBuild_IncludeTFPE :=
	PromoBuild_Ins :=
	PromoBuild_Link :=
	PromoBuild_NCF :=
	PromoBuild_Nonref :=
	PromoBuild_NoTFPE :=
	PromoBuild_PaxType :=
	PromoBuild_PayPen :=
	PromoBuild_Pol :=
	PromoBuild_Print :=
	PromoBuild_Promo :=
	PromoBuild_PromoRemarks1 :=
	PromoBuild_PromoRemarks2 :=
	PromoBuild_PromoRemarks3 :=
	PromoBuild_PromoType :=
	PromoBuild_ProtRate :=
	PromoBuild_Recap :=
	PromoBuild_RES :=
	PromoBuild_RMSType :=
	PromoBuild_SailDate :=
	PromoBuild_SeqLast :=
	PromoBuild_Shutoff :=
	PromoBuild_Status1 :=
	PromoBuild_STW :=
	PromoBuild_TC :=
	PromoBuild_TemplateCode :=
	PromoBuild_TemplateCurrency :=
	PromoBuild_TemplateVoyage :=
	PromoBuild_Tours :=
	PromoBuild_Utxt :=
	PromoBuild_Vat :=
	PromoBuild_Voyage :=
	PromoBuild_Waitlist :=
	PromoBuild_WEB :=
return


;------------ Global Commands ----------------------------------------------------
#IfWinExist, Building Tool Active
$^1::
	BuildProgressToolTip :=
	gosub, StartTicker
	gosub, Building_Step1
	gosub, EndTicker
return


$^2::
	BuildProgressToolTip :=
	gosub, StartTicker
	gosub, Building_Step2
	gosub, EndTicker
return

$^3::
	BuildProgressToolTip :=
	gosub, StartTicker
	gosub, Building_Step3
	gosub, EndTicker
return

$^4::
	BuildProgressToolTip :=
	gosub, StartTicker
	gosub, Building_Step4
	gosub, EndTicker
return

$^5::
	gosub, Building_Step5
return

$^6::
	GoSub, StartTicker
	gosub, Building_Step6  ;Sub to run all steps. Currently, May change.
	gosub, Endticker
return

$^7::
	GoSub, Building_Step7
return
#IfWinExist

;---------------------------------------------------------------------------
;--------------------------- Macros ------------------------------------------------
;---------------------------------------------------------------------------
#IfwinActive ahk_Class SDI:TN3270Plus
Building_Step1:
	BuildTooltip :=
	;---------- Check Variables Exist before continueing ----------------------------
	If BuildMacro_Currency not in AUD,GBP,EUR,USD
	{
		BuildToolTip := "No Currency variable exist"
		UserMsg_Notif(BuildToolTip)
		Exit
	}
	If substr(BuildMacro_PromotionType,1,1) not between A and Z
	{
		BuildToolTip := "Promotion Type appears to be incorrect"
		UserMsg_Notif(BuildToolTip)
		Exit
	}
	;---------- Reset THIS Voyage Variables ------------------------------------------
	PromoBuild_PromotionType := BuildMacro_PromotionType
	PromotionCode_Old :=
	PromotionCode_New :=
	PromoArray :=
	;---------- Check Clipboard for Voyage, if possibly Voyage then ----------------------------
	IfnotEqual, Clipboard,""
	{
		BuildProgressToolTip := "Checking Clipboard Conents..."
		TooltipNote(BuildProgressToolTip,1)
		;------ Remove extras from clipboard -----------
		PromoBuild_Voyage := Clipboard
		StringReplace,PromoBuild_Voyage,PromoBuild_Voyage,%A_Space%,,All
		StringReplace,PromoBuild_Voyage,PromoBuild_Voyage,`t,,All
		StringReplace,PromoBuild_Voyage,PromoBuild_Voyage,`n,,All
		StringReplace,PromoBuild_Voyage,PromoBuild_Voyage,`r,,All
		;------ Check length as voyage shouldn't be longer then 5 characters --------------
		If strlen(PromoBuild_Voyage) > 5 ;----- If it is longer then 5 characters ------
		{
			BuildtoolTip := "Clipboard appears to be to long to be a Voyage... `n Clipboard: " . PromoBuild_Voyage
			UserMsg_Notif(BuildtoolTip)
			Exit
		}
		else
		{
			If strlen(PromoBuild_Voyage) = 4
				PromoBuild_Voyage := PromoBuild_Voyage . A_Space
		}
		User_MouseCoords()
		BuildProgressToolTip := "Clipboard verified as voyage: " . PromoBuild_Voyage
		TooltipNote(BuildProgressToolTip,1)
	}
	else
	{
		BuildTooltip := "No voyage in Clipboard"
		UserMsg_Notif(BuildtoolTip)
		exit
	}
	;----------- End Clipboard Check For Voyage -------------------------------
	;----------- Check if Promo to use is specified ---------------------------
	If strlen(PromoBuild_PromotionType) = 3 and strLen(PromoBuild_TemplateVoyage) > 3
	{
		PromotionCode_New := PromoBuild_PromotionType
	}
	else
	{
		;----------- Start CPRO steps to find Voyage and Promo Numbers ---------------------
		User_MouseCoords()
		BuildProgressToolTip := BuildProgressToolTip . "`n Starting CPRO..."
		TooltipNote(BuildProgressToolTip,1)
		;----- Start CPRO -------
		loop, 5
		{
			IfWinNotActive, AHK_Class SDI:TN3270Plus
				Exit
			;----- Copy Screen until on CPRO Promotion List Screen -------
			Gosub, Building_CopyPolarScreen
			;----- Check what Screen we are on ------------------
			Ifinstring, Clipboard, Promotion%A_Space%List
			{
				sendevent, {F5}+{tab 10}
				break
			}
			Else Ifinstring, Clipboard, Cruise%A_Space%Consultant
				Sendevent, {f5}CPro{Enter}
			else if instr(Clipboard, "Promotion Terms",,1,1) and instr(Clipboard, "CPRO",,1,1)
				SendEvent, +{f4}
			else
				SendEvent, {Esc}
			Sleep, 350
		} ;--- End of 5 part Loop to start CPRO -----
		;---- Put Voyage back in Clipboard ----------
		Clipboard := PromoBuild_Voyage
		;-------------------------------------------------------------------------------------
		;-------------- Step Two, Input CPRO Search Information ---------------------
		;-------------------------------------------------------------------------------------
		User_MouseCoords()
		BuildProgressToolTip := BuildProgressToolTip . "`n Searching for promos..."
		TooltipNote(BuildProgressToolTip,1)
		;----- Input Build Status (Open/Closed/Test), Voyage, and PR -----------------
		IfWinNotActive, AHK_Class SDI:TN3270Plus
			exit
		SendEvent, %PromoBuild_Status1%%PromoBuild_Voyage%PR
		;--------- Loop 3 times to search for next promo ------------------------
		Loop, 3
		{
			;---- Reset Variables used in this step ------------
			TryAgain :=
			;--- Fill in the rest of the fields such as Promotion Type and Currency ----
			IfWinNotActive, AHK_Class SDI:TN3270Plus
				exit
			SendEvent, %PromoBuild_PromotionType%{*}{Tab}
			If BuildMacro_PromotionType not in PC,US
				SendEvent, %PromoBuild_Currency%
			else
				Sendevent, +{End}
			SendEvent, {Enter}
			Sleep, 450
			;---- Copy Screen for results --------------
			Gosub, Building_CopyPolarScreen
			;--- Check to see if we used last Promo for each currency ---
			;---- For USD Currency, Check if all promos are used -----------------
			If PromoBuild_Currency = USD
			{
				If BuildMacro_PromotionType in PC,US,UG
				{
					TestArray := 
					Test1 := Promobuild_PromotionType . "8"
					Test2 := Promobuild_PromotionType . "9"
					Test3 := Promobuild_PromotionType . "Y"
					Test4 := Promobuild_PromotionType . "Z"
					IfNotInString, Test2, Clipboard
					{
						If instr(Clipboard, Test1) and instr(Clipboard, Test3) and instr(Clipboard, Test4)
							TryAgain = 1
					}
				}
				else if BuildMacro_PromotionType in RH
				{
					TryAgain = 0
					If Clipboard Contains %Promobuild_PromotionType%B
						Exit
				}
				else
				{
					TryAgain = 0
				}
			}
			Else if PromoBuild_Currency in AUD,EUR,GBP
			{
				If Clipboard contains %PromoBuild_PromotionType%J,%PromoBuild_PromotionType%R,%PromoBuild_PromotionType%Z
					TryAgain = 1
			}
			else
			{
				Exit
			}
			;--- If we used the last promo for the currency then get next PromoType Code ----
			If TryAgain = 1
			{
				;------ Prefill Error Tooltip ----------------
				BuildTooltip := "Did not find an open promo code..."
				;------ Get Coordinates of mouse ------------------
				User_MouseCoords()
				;------ Update Build Progress -----------------
				BuildProgressToolTip := BuildProgressToolTip . "`n No available promos found... `n Trying next Promo Code: "
				TooltipNote(BuildProgressToolTip,1)
				If (BuildMacro_PromotionType = "PC") and (PromoBuild_PromotionType = "PC")
				{
					PromoBuild_PromotionType = PD
				}
				Else If (BuildMacro_PromotionType = "US") and ((PromoBuild_PromotionType = "US") or (PromoBuild_PromotionType = "UT"))
				{
					If PromoBuild_PromotionType = US
						PromoBuild_PromotionType = UT
					else if Promobuild_PromotionType = UT
						PromoBuild_PromotionType = UF
					else
						Exit
				}
				Else If (BuildMacro_PromotionType = "UG") and ((PromoBuild_PromotionType = "UG") or (PromoBuild_PromotionType = "UH"))
				{
					If Promobuild_PromotionType = UG
						Promobuild_PromotionType = UH
					Else if PromoBuild_PromotionType = UH
						PromoBuild_PromotionType = UI
					else
						Exit
				}
				Else If BuildMacro_PromotionType = "RH"
				{
					PromoBuild_PromotionType = RT
				}
				else
				{
					UserMsg_Notif(BuildtoolTip)
					exit
				}
				;----- Update Build Progress --------
				BuildProgressToolTip := BuildProgressToolTip . PromoBuild_PromotionType
				TooltipNote(BuildProgressToolTip,1)
				;------ Back track to Promo code line ----------------
				Send +{Tab 7}
				Sleep, 700
			}
			else
			{
				break
			}
		}
		;-------------------------------------------------------------------------------------
		;-------------- Step Three, Evaluate list and find open Promo Code ---------------------
		;-------------------------------------------------------------------------------------
		User_MouseCoords()
		BuildProgressToolTip := BuildProgressToolTip . "`n Finding an open Promo Code..."
		TooltipNote(BuildProgressToolTip,1)
		;------------ Get Promo Number, New and Old ----------------------------
		;--------------------------------------------
		Gosub, Building_CopyPolarScreen
		Ifinstring, Clipboard, Promotion%A_Space%List
		{
		;------ Set up Standard All Currency Variables --------------
			If PromoBuild_Currency = USD
			{
				If PromoBuild_PromotionType in PC,PD,RH,RT,US,UT,UI,UG,UH,UF
				{
					PromoArray := ["1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
				}
				else
				{
					PromoArray := ["1","2","3","4","5","6","7","8","9","A","B"]
				}
			}
			else
			{
				If PromoBuild_Currency = GBP
				{
					PromoArray := ["C","D","E","F","G","H","I","J"]
				}
				If PromoBuild_Currency = EUR
				{
					PromoArray := ["K","L","M","N","O","P","Q","R"]
				}
				If PromoBuild_Currency = AUD
				{
					PromoArray := ["S","T","U","V","W","X","Y","Z"]
				}
			}
			;-------- Find a voyage that doesn't exist -----------------------------------
			Loop, 2
			{
				Loop % PromoArray.length()
				{
					ClipSearch := PromoBuild_Currency . A_Tab . PromoBuild_Promotiontype . PromoArray[A_Index]
					ClipSearch2 := PromoBuild_Currency . A_Space . PromoBuild_Promotiontype . PromoArray[A_Index]
					If (instr(Clipboard, ClipSearch,False,1,1)) or (Instr(Clipboard,ClipSearch2,False,1,1))
					{
						PromotionCode_Old := PromoBuild_Promotiontype . PromoArray[A_Index]
						continue
					}
					else
					{
						If BuildMacro_PromotionType in PC,US,UG
						{
							ClipSearch := "GBP" . A_Tab . Promobuild_PromotionType . PromoArray[A_Index]
							ClipSearch2 := "GBP" . A_Space . Promobuild_PromotionType . PromoArray[A_Index]
							If (instr(Clipboard, ClipSearch,False,1,1)) or (Instr(Clipboard,ClipSearch2,False,1,1))
							{
								PromotionCode_Old := PromoBuild_Promotiontype . PromoArray[A_Index]
								continue
							}
							ClipSearch := "EUR" . A_Tab . Promobuild_PromotionType . PromoArray[A_Index]
							ClipSearch2 := "EUR" . A_Space . Promobuild_PromotionType . PromoArray[A_Index]
							If (instr(Clipboard, ClipSearch,False,1,1)) or (Instr(Clipboard,ClipSearch2,False,1,1))
							{
								PromotionCode_Old := PromoBuild_Promotiontype . PromoArray[A_Index]
								continue
							}
							ClipSearch := "AUD" . A_Tab . Promobuild_PromotionType . PromoArray[A_Index]
							ClipSearch2 := "AUD" . A_Space . Promobuild_PromotionType . PromoArray[A_Index]
							If (instr(Clipboard, ClipSearch,False,1,1)) or (Instr(Clipboard,ClipSearch2,False,1,1))
							{
								PromotionCode_Old := PromoBuild_Promotiontype . PromoArray[A_Index]
								continue
							}
						}
						PromotionCode_New := PromoBuild_Promotiontype . PromoArray[A_Index]
						If strlen(PromotionCode_Old) < 3
						{
							If PromoBuild_Promotiontype in UT,UF
							{
								If PromoBuild_Promotiontype = UF
									PromotionCode_Old = UTZ
								else if PromoBuild_Promotiontype = UT
									PromotionCode_Old = USZ
							}
							else if PromoBuild_Promotiontype in UH,UI
							{
								If PromoBuild_Promotiontype = UI
									PromotionCode_Old = UHZ
								else if PromoBuild_Promotiontype = UH
									PromotionCode_Old = UGZ
							}
						}
						break
					}
				}
			}
			User_MouseCoords()
			if strlen(PromoBuild_TemplateVoyage) > 2
				BuildProgressToolTip := BuildProgressToolTip . "`n Template: " . PromoBuild_TemplateVoyage . "`n Template Code: " . PromoBuild_TemplateCode . "`n Empty Promo Code: " . PromotionCode_New
			else
				BuildProgressToolTip := BuildProgressToolTip . "`n Previous Promo: " . PromotionCode_Old . "`n Empty Promo Code: " . PromotionCode_New
			TooltipNote(BuildProgressToolTip,1)
		}
		;------------ Check to see if we can overrite Last Entry -----------------
		Ifinstring, Clipboard, %PromotionCode_Old%%A_Tab%%A_Space%%A_Tab%O%A_Tab%%A_Space%%A_Space%%A_Space%0
		{
			If PromoBuild_Promotiontype not in PC,PD,US,UT,UI,UG,UH,UF,LG
			{
				Msgbox,4,Alternative Option,This has 0 passengers. Lets close and change it!
					
				IfMsgBox Yes
				{
					;------ Close and change the promo ------------------
					Loop, 4
					{
						IfWinNotActive, AHK_Class SDI:TN3270Plus
							Exit
						If A_Index = 1
							sendevent, +{tab 10}o{enter}
						If A_Index = 2
							Sendevent, s{enter}
						If A_Index = 3
							SendEvent, {tab 2}c{enter}
						If A_Index = 4
							SendEvent, +{F9}
						Sleep, 350
					}
						Exit
				}
			}
		} ;------------- End Promo Close and change Script ----------------
	}
Return

Building_Step2:
	;---- Check if variables exist to continue with this step -----------------
	If (strlen(PromoBuild_PromotionType) < 2) or (strlen(PromoBuild_PromotionType) > 3) or (strlen(PromoBuild_Currency) <> 3) or (strlen(PromotionCode_New) <> 3)
	{
		Msgbox, Exit1
		Exit
	}
	If (strlen(PromoBuild_TemplateVoyage) < 2) and (strlen(PromotionCode_Old) < 2)
	{
		Msgbox, Exit2
		Exit
	}
	;----- Copy screen to check that we are on the right screen to continue ------------
	Gosub, Building_CopyPolarScreen
	;----- Switch screen to start APRO ------------------------
	Ifinstring, Clipboard, Promotion%A_Space%List
		Send {f9}
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Starting APRO..."
	TooltipNote(BuildProgressToolTip,1)
;----- Start Apro -----------
	Loop, 3 
	{
		IfWinNotActive, AHK_Class SDI:TN3270Plus
			exit
		If A_Index = 1
			SendEvent {esc}
		If A_Index = 2
			Sendevent Apro{Enter}
		If A_Index = 3
			SendEvent {Tab}
		Sleep, 350
	}
	Sleep, 450
	
;------ Input APRO info ---------------
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Filling in APRO..."
	TooltipNote(BuildProgressToolTip,1)
	Loop, 2
	{
		IfWinNotActive, AHK_Class SDI:TN3270Plus
			Exit
		;-------- Step 1, input new voyage info ---------------------
		If A_Index = 1
		{
			SendEvent, %PromoBuild_Voyage%{Tab}
			SendEvent, %PromotionCode_New%
			SendEvent, %PromoBuild_Currency%+{Enter}
		}
		;-------- Step 2, Input old or template voyage info ---------
		If A_Index = 2
		{
			If PromoBuild_TemplateVoyage
			{
				SendEvent, %PromoBuild_TemplateVoyage%
				SendEvent, %PromoBuild_Templatecode%
				SendEvent, %PromoBuild_Templatecurrency%
			}
			else
			{
				SendEvent, {Tab}
				SendEvent, %PromotionCode_Old%
				SendEvent, %PromoBuild_Currency%
			}
		}
	}
	Sleep, 300
	send {Enter}
	Sleep, 450
Return

Building_Step3:
;----- Copy Screen -------
	Gosub, Building_CopyPolarScreen
	;----- Define reset Variables ---------------
	BuildPromo_TermsScreen :=
	PromoBuild_Desc1 :=
	PromoBuild_Desc2 :=
	TestString :=
	BuildPromo_TermsScreen := Clipboard
	If (BuildPromo_TermsScreen = ) or (instr(BuildPromo_TermsScreen,"Promotion Terms",,1,1) < 1)
		Exit
	;----- Get Voyage Sail Date / Format Menu Start Date ---------------
	gosub, DaysToSailDate
	;----- Update Status -----------------
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Evaluating Promotion Terms Page..."
	TooltipNote(BuildProgressToolTip,1)
;-----------------------------------------------------------------------------------------------------------
;------------------------------ Evaluate Promotion Terms Page ---------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
		If BuildMacro_PromotionType in LG
		{
			BuildPromo_NewEffective := Substr(BuildPromo_TermsScreen,instr(BuildPromo_TermsScreen, "Effective:",,1,1))
			BuildPromo_NewEffective := Substr(BuildPromo_NewEffective,strlen("Effective:")+2,7)
			BuildPromo_NewEffective := "0" . (Substr(BuildPromo_NewEffective,2,1)+1) . Substr(BuildPromo_NewEffective,3)
		}
	;------------------- Check RMS Type ----------------------------
		TooltipNote(BuildProgressToolTip . "`n RMS Type: ...",1)
		;------------------ Campaigns ----------------------------------------------------
		If BuildMacro_PromotionType in US,UY
		{
			TestString1 = RMS%A_Space%Type:%A_Tab%F
			TestString2 = RMS%A_Space%Type:%A_Space%F
			If instr(BuildPromo_TermsScreen,TestString1,False,1,1) or instr(BuildPromo_TermsScreen,TestString2,False,1,1)
				BuildProgressTollTip := BuildProgressToolTip . "`n RMS Type: Flat Rate..."
			else
				UserMsg_Notif("RMS type appears to be incorrect for a US flat rate Campaign")
		}
		If BuildMacro_PromotionType in UG
		{
			TestString1 = RMS%A_Space%Type:%A_Tab%A
			TestString2 = RMS%A_Space%Type:%A_Space%A
			If instr(BuildPromo_TermsScreen,TestString1,False,1,1) or instr(BuildPromo_TermsScreen,TestString2,False,1,1)
				BuildProgressTollTip := BuildProgressToolTip . "`n RMS Type: Dollars/Percent Off..."
			else
				UserMsg_Notif("RMS type appears to be incorrect for a US Dollars/Percent off rate Campaign")
		}
		;----------------- Other Promos --------------------------------------------------------------
		
		;------------------- END RMS Type Check ------------------------------------------------------
		TooltipNote(BuildProgressToolTip,1)
	;----- Campaign Variable Management ---------------------------------------------------------------------------
		If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
		{
			;--- Combinable Flag -------------------
			BuildProgressToolTip := BuildProgressToolTip . "`n Combinable: "
			TooltipNote(BuildProgressToolTip,1)
			If BuildMacro_PromotionType in US,UT,UQ,UG,UI,UH,UY
			{
				TestString1 = Combinable:%A_Tab%U
				TestString2 = Combinable:%A_Space%U
				If instr(BuildPromo_TermsScreen,TestString1,False,1,1) or instr(BuildPromo_TermsScreen,TestString2,False,1,1)
					BuildProgressToolTip := BuildProgressToolTip . "Correct..."
				else
					UserMsg_Notif("Combinable flag should be U")
			}
			else If BuildMacro_PromotionType in PC
			{
				Ifinstring, BuildPromo_TermsScreen, Combinable:%A_Tab%N
				TestString1 = Combinable:%A_Tab%N
				TestString2 = Combinable:%A_Space%N
				If instr(BuildPromo_TermsScreen,TestString1,False,1,1) or instr(BuildPromo_TermsScreen,TestString2,False,1,1)
					BuildProgressToolTip := BuildProgressToolTip . "Correct..."
				else
					UserMsg_Notif("Combinable Flag Should be N")
			}
			else
				BuildProgressToolTip := BuildProgressToolTip . "Not Checked"
			TooltipNote(BuildProgressToolTip,1)
		}
	;----- Create Campaign Description Text ------------
		PromoBuild_Desc1 :=
		PromoBuild_Desc2 :=
		If BuildMacro_Campaign1Bool
			PromoBuild_Desc1 := PromoBuild_CampaignCode1 . " "
		If BuildMacro_Campaign2Bool
			PromoBuild_Desc1 := PromoBuild_Desc1 . PromoBuild_CampaignCode2 . " "
		If BuildMacro_Campaign3Bool
			PromoBuild_Desc1 := PromoBuild_Desc1 . PromoBuild_CampaignCode3 . " " 
		If BuildMacro_Campaign4Bool
		{
			PromoBuild_Desc1Length := StrLen(PromoBuild_Desc1)
			PromoBuild_Desc1Length := PromoBuild_Desc1Length + strlen(PromoBuild_CampaignCode4)
			If PromoBuild_Desc1Length > 40
			{
				PromoBuild_Desc2 := PromoBuild_CampaignCode4 . " "
				PromoBuild_DescBool := 1
			}
			else
			{
				PromoBuild_Desc1 := PromoBuild_Desc1 . PromoBuild_CampaignCode4
				PromoBuild_DescBool := 0
			}
		}
		If BuildMacro_Campaign5Bool
		{
			PromoBuild_Desc1Length := StrLen(PromoBuild_Desc1)
			PromoBuild_Desc1Length := PromoBuild_Desc1Length + strlen(PromoBuild_CampaignCode5)
			If PromoBuild_Desc1Length > 40
			{
				PromoBuild_Desc2 := PromoBuild_Desc2 . PromoBuild_CampaignCode5
				PromoBuild_DescBool := 1
			}
			else
			{
				PromoBuild_Desc1 := PromoBuild_Desc1 . PromoBuild_CampaignCode5
				PromoBuild_DescBool := 0
			}
		}
		
	;----- Create Promo Description Text for GAP -------------------
		PromoBuild_NoGapLine1 := "Not Eligible For Gap"
		PromoBuild_NoGapLine2 := "Does Qualify Towards TC Credit"
	;----- Create Tooltip for days to Sail -------------------------
		User_MouseCoords()
		BuildProgressToolTip := BuildProgressToolTip . "`n Promo Start is " . PromoBuild_DaysToSail . " Days From Sail Date"
		TooltipNote(BuildProgressToolTip,1)
;-----------------------------------------------------------------------------------------------------------
;------------------------------ Input Flags, Description, and etc ---------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
	IfWinNotActive, AHK_Class SDI:TN3270Plus
		Exit
	Sendevent, {f5}
	Sleep, 400
	;------ Voy:	Promo:	Loc:	St:	Curr:	Templ:	Sim Deal: ----------------------------------------------------
		TestString1 = St:`tT
		TestString2 = St:%A_Space%T
		If instr(BuildPromo_TermsScreen, TestString1) or instr(BuildPromo_TermsScreen, TestString2)
			Sendevent, +{Enter}
		else
			UserMsg_Notif("Voyage not in T Status, Something must have gone wrong")
	;------ Rpt 381: ----------------------------------------------------
		SendEvent, +{Enter}
	;------ Desc:	Meta 1-2: ----------------------------------------------------
		If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
		{
			Ifnotinstring, PromoBuild_Desc1, BuildPromo_TermsScreen
				SendEvent, +{end}%PromoBuild_Desc1%
		}
		SendEvent, +{Enter}
	;------ Desc2:	Replaces: ----------------------------------------------------
		If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
		{
			If PromoBuild_DescBool
				SendEvent, +{End}%PromoBuild_Desc2%
			Else If PromoBuild_DaysToSailBool
				SendEvent, +{End}%PromoBuild_NoGapLine1%
			Else
				SendEvent, +{End}
		}
		SendEvent, +{Enter}
	;------ Desc3:	Max Pax: ----------------------------------------------------
		If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
		{
			If PromoBuild_DescBool and PromoBuild_DaysToSailBool
				SendEvent, +{End}%PromoBuild_NoGapLine1%
			else if PromoBuild_DaysToSailBool
				SendEvent, +{End}%PromoBuild_NoGapLine2%
			else
				SendEvent, +{End}
		}
		SendEvent, +{Enter}
	;------ Desc4: ----------------------------------------------------
		If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
		{
			If PromoBuild_DescBool and PromoBuild_DaysToSailBool
				SendEvent, +{End}%PromoBuild_NoGapLine2%
			else
				SendEvent, +{End}
		}		
		SendEvent, +{Enter}
	;------ CrsD:	CrsD 2:		Cntl:	Cntl Promo: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ RMS Type:	Benchmark:	Fare Type: ----------------------------------------------------
	If PromoBuild_KR
	{
		Sendevent, {tab}
		SendEvent, KR1
	}
	SendEvent, +{Enter}
	;------ Promo Type:	Pax Type:	Combinable:	STW:	Opened:	"Date"	"User" ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Tours Elig:	Avl To W/L:	Changed:	"Date"	"User" ----------------------------------------------------
	SendEvent, +{Enter}
	;------ PayPen Cruz:	Child/Infant:	No TF&PE:	History: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ NCF:	Best Buy:	Non-Ref:	Prot Rate:	Effective:	30AUG18 ----------------------------------------------------
	SendEvent, {Tab} ;---- Past NCF Flag ----
	If (PromoBuild_BestBuy <> "") and (PromoBuild_PromotionType <> "LG") ;---- Input BB Flag or skip it ----
		SendEvent, %PromoBuild_BestBuy%
	else
		SendEvent, {Tab}
	SendEvent, {Tab} ;---- Past Non-Ref Tab -----
	SendEvent, {Tab} ;---- Past ProtRate Flag ----
	If PromoBuild_Effective ;--- Effective date -----
		SendEvent, %PromoBuild_Effective%
	else if BuildMacro_PromotionType in LG
		sendevent, %BuildPromo_NewEffective%
	else
		SendEvent, +{Enter}
	;------ RES:	GDS:	WEB:	Pol:	Auto:	Recap:	Shut Off: 	04MAY19 ----------------------------------------------------
	SendEvent, {Tab 5}
	If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
	{
		If PromoBuild_DaystoSailBool
			SendEvent, Y
		else
			SendEvent, N
	}
	else
		SendEvent, {Tab}
	If Promobuild_ShutOff
		SendEvent, %PromoBuild_Shutoff%
	else if BuildMacro_ExpireSailBool
		SendEvent, %PromoBuild_SailDate%
	else
		SendEvent, +{Enter}
	;------ Seq Last:	Commission:	Vat:	Ins:	Prt:	Grace: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Include Air:	Air:	Combo Air:	Link:	Activate: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Fare Includes TF&PE:	Dining Ctl:	Air Disc:	Communicated: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Agy Type:		Prot Agt Comm: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ AVAL Misc Display:	Exclude from BFF: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ App Grp:	App Amen:	Amen Pts:	Grp Exp Dt:	TC:	 ----------------------------------------------------
	If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
	{
		SendEvent, {Tab 1}
		If PromoBuild_DaystoSailBool
			SendEvent, N
		else
			SendEvent, Y
	}
	SendEvent, +{Enter}
	;------ Excl Inherit CN:	Web Sales And Desc:	Campaign: Active:	Type: ----------------------------------------------------
	If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
		SendEvent, {Tab 4}P
	else
		SendEvent, +{Enter}
	;------ Campaign1: Campaign2:	Campaign3:	Campaign4: ----------------------------------------------------
	If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
	{
		If BuildMacro_Campaign1Bool
		{
			SendEvent, +{End}%PromoBuild_CampaignCode1%
			if strlen(PromoBuild_CampaignCode1) < 10
				SendEvent, {Tab}
		}
		If BuildMacro_Campaign2Bool
		{
			SendEvent, +{End}%PromoBuild_CampaignCode2%
			if strlen(PromoBuild_CampaignCode2) < 10
				SendEvent, {Tab}
		}
		If BuildMacro_Campaign3Bool
		{
			SendEvent, +{End}%PromoBuild_CampaignCode3%
			if strlen(PromoBuild_CampaignCode3) < 10
				SendEvent, {Tab}
		}
	}
	SendEvent, +{Enter}
	;------ Campaign5: Campaign6:	Campaign7:	Campaign8: ----------------------------------------------------
	If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
	{
		If BuildMacro_Campaign4Bool
		{
			SendEvent, +{End}%PromoBuild_CampaignCode4%+{Tab}
			if strlen(PromoBuild_CampaignCode4) < 10
				SendEvent, {Tab}
		}
		If BuildMacro_Campaign5Bool
		{
			SendEvent, +{End}%PromoBuild_CampaignCode5%+{Tab}
			if strlen(PromoBuild_CampaignCode5) < 10
				SendEvent, {Tab}
		}
	}
	SendEvent, +{Enter}
	;------ Campaign9: Campaign10:	Campaign11:	Campaign12: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Campaign13: Campaign14:	Campaign15:	Campaign16: ----------------------------------------------------
	SendEvent, +{Enter} 
	;------ Campaign17: Campaign18:	Campaign19:	Campaign20: ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Promo Remarks: (64 characters max) ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Promo Remark2: (64 characters max) ----------------------------------------------------
	SendEvent, +{Enter}
	;------ Promo Remarks3: (64 characters max) ----------------------------------------------------
	SendEvent, +{Enter}
	;------ UTXT Extended Remarks: ----------------------------------------------------
	If BuildMacro_PromotionType in PC,PD,US,UT,UQ,UG,UI,UH,UY
	{
		Sendevent, +{End}
		If PromoBuild_DaystoSailBool
			SendEvent, TCONLY
	}
	SendEvent, +{Enter}
SendEvent, {Enter}
User_MouseCoords()
BuildProgressToolTip := BuildProgressToolTip . "`n Promotion Screen Complete..."
TooltipNote(BuildProgressToolTip,1)
Return

Building_Step4:
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Moving to Pricing Screen..."
	TooltipNote(BuildProgressToolTip,1)
	Loop, 2
	{
		Clipboard :=
		Sendevent, ^a^c
		clipwait, 1
		If ErrorLevel
			Exit
		IfInString, Clipboard, Promotion%A_Space%Terms
		{
			Sendevent, +{f9}
		}
		else IfInString, Clipboard, Promotion%A_Space%Amounts
		{
			User_MouseCoords()
			BuildProgressToolTip := BuildProgressToolTip . "`n Moving Cursor to beginning..."
			TooltipNote(BuildProgressToolTip,1)
		;----Acct# 12345 C Bs -------
			SendEvent, +{Enter 1}
		;---- Meta: Double: Single: -------
			SendEvent, +{Enter 1}
		;---- Cat: APO: Double: Single: Third: Fourth: Upper Child: Fifth: ---------
			SendEvent,{Tab 2}
			break
		}
		else
		{
			Msgbox, We are lost....
			Exit
		}
		Sleep, 450
	}
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Complete."
	TooltipNote(BuildProgressToolTip,1)
return

Building_Step5:
	Sleep, 450
	Send {f9}
	sleep, 600
	setkeydelay, 100
	sendevent, +{tab 10}o{tab 2}%PromotionCode_Old%{enter}
	Sleep, 450
	Sendevent, s{enter}
	Sleep, 350
	;---- Change Promo PromoBuild_Status -------
	;	Sendevent, {Tab 2}o
	;---------------------------------
	;Sleep, 350
	Send ^a^c
	Sleep, 300
	Sleep, 200
	Send %Var_DayMonthYear%{Enter}
	Sleep, 450
	If Promotiontype = KA
		Send, ^!k
	else
		Send ^!{Home}
	Sleep, 400
	If Promotiontype = KA
		Send Refer to %PromotionCode_New%{Enter}
	else
		Send Expired Refer to %PromotionCode_New%{enter}
Return

Building_Step6:
	Gosub Building_Step1
	Sleep, 250
	GoSub, Building_Step2
	If BuildMacro_BuildAllOption <> 2
	{
		Sleep, 250
		GoSub, Building_Step3
		If BuildMacro_BuildAllOption <> 3
		{
			Sleep, 600
			GoSub Building_Step4
		}
	}
return
#IfWinActive

Building_Step7:
	Gosub, Build_ParseList
return


StartTicker:
	Var1 := A_TickCount
	StartTime := A_Now
return

EndTicker:
	Var2 := (A_Tickcount - Var1)/1000
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Took " . Var2 . " seconds."
	TooltipNote(BuildProgressToolTip,1)
return

DaysToSailDate:
;------- The Promo Screen Sail Date of the Voyage--------------------
	;---- Erase variables ------------------
	PromoBuild_SailDate :=
	PromoBuild_SailDate1 :=
	;---- Input Promo Screen Sail Date of voyage into Variable -----------------
	PromoBuild_SailDate := substr(BuildPromo_TermsScreen,Instr(BuildPromo_TermsScreen,"/",,1,1)+1,7)
	;---- Seperate Voyage Sail Date into Day, Month, Year -----------------
	Day := SubStr(PromoBuild_SailDate,1,2)
	Month := SubStr(PromoBuild_SailDate, 3,3)
	Year := SubStr(PromoBuild_SailDate,6,2)
	;---- Convert Text to a number -------------
	If PromoBuild_SailDate <> 
	{
		If Month = JAN
			Month = 01
		If Month = FEB
			Month = 02
		If Month = MAR
			Month = 03
		If Month = APR
			Month = 04
		If Month = MAY
			Month = 05
		If Month = JUN
			Month = 06
		If Month = JUL
			Month = 07
		If Month = AUG
			Month = 08
		If Month = SEP
			Month = 09
		If Month = OCT
			Month = 10
		If Month = NOV
			Month = 11
		If Month = DEC
			Month = 12
		;------- Format to a Date ------------
		PromoBuild_SailDate1 = 20%Year%%Month%%Day%
	}
	
	;---- Seperate Start Date if one exist -----------
	If BuildMacro_StartDateBool
	{
		FormatTime, BuildMacro_StartDate1,, yyyyMMdd
		FormatTime, BuildMacro_StartDate, %BuildMacro_StartDate1%, ddMMMyy
	}
	else if BuildMacro_StartDate <>
	{
		Day := SubStr(BuildMacro_StartDate,1,2)
		Month := SubStr(BuildMacro_StartDate, 3,3)
		Year := SubStr(BuildMacro_StartDate,6,2)
		
		If BuildMacro_StartDate <> 
		{
			If Month = JAN
				Month = 01
			If Month = FEB
				Month = 02
			If Month = MAR
				Month = 03
			If Month = APR
				Month = 04
			If Month = MAY
				Month = 05
			If Month = JUN
				Month = 06
			If Month = JUL
				Month = 07
			If Month = AUG
				Month = 08
			If Month = SEP
				Month = 09
			If Month = OCT
				Month = 10
			If Month = NOV
				Month = 11
			If Month = DEC
				Month = 12
			BuildMacro_StartDate1 = 20%Year%%Month%%Day%
		}
	}
	else if BuildMacro_MinusSailDate <>
	{
		PromoBuild_Effective := PromoBuild_SailDate1
		PromoBuild_Effective += -%BuildMacro_MinusSailDate%, Days
		Formattime, PromoBuild_Effective, %PromoBuild_Effective%, ddMMMyy
	}
	
	PromoBuild_DaystoSail := PromoBuild_SailDate1
	PromoBuild_DaystoSail -= BuildMacro_StartDate1, Days
	If PromoBuild_DaystoSail < 120
		PromoBuild_DaystoSailBool := 1
	else
		PromoBuild_DaysToSailBool := 0
return

Building_CopyPolarScreen:
	Loop, 2
	{
		Ifwinnotactive, AHK_Class SDI:TN3270Plus
			Exit
		ClipboardSaved := Clipboard
		Clipboard :=
		Sleep, 300
		SendEvent, ^a^c
		Clipwait, 1
		If (Errorlevel) and (A_index > 1)
		{
			Clipboard := ClipboardSaved
			BuildTooltip := "Failed to copy screen..."
			UserMsg_Notif(BuildtoolTip)
			Exit
		}
		else if ErrorLevel
			Sleep, 500
		else
			break
	}
return

Build_ParseList:
Winactivate, AHK_Class SDI:TN320PLUS
Loop, Parse, Clipboard,`n
{
	Clipboard :=
	TempClip := A_LoopField
	StringReplace, TempClip, TempClip, `t,,All
	StringReplace, TempClip, TempClip, %A_Space%,,All
	StringReplace, TempClip, TempClip, `n,,All
	Clipboard := TempClip
	
	Var1 := A_TickCount
	StartTime := A_Now
	Gosub Building_Step1
	Sleep, 250
	GoSub, Building_Step2
	If BuildMacro_BuildAllOption = 2
		Exit
	Sleep, 750
	GoSub, Building_Step3
	If BuildMacro_BuildAllOption = 3
		Exit
	Var2 := (A_Tickcount - Var1)/1000
	User_MouseCoords()
	BuildProgressToolTip := BuildProgressToolTip . "`n Took " . Var2 . " seconds."
	TooltipNote(BuildProgressToolTip,1)
	Sleep, 500
}
Return

Pause::
	Pause
return

