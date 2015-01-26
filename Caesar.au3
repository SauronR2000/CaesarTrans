#pragma compile(Out,caesartrans.exe)
#pragma compile(FileVersion,22.01.20.15)
#pragma compile(FileDescription,Caesar Translator)
#pragma compile(CompanyName,Henrison)
#pragma compile(LegalCopyright,© Henrison. Kostenlose Software, open source. Modifizierung und Weitergabe des Sourcecodes und/oder der kompilierten Version mit Angabe des GitHub Links erlaubt.)
#pragma compile(ProductName,Backuper2)
#pragma compile(ProductVersion,1.0.0.1)
#pragma compile(OriginalFilename,caesartrans.exe)

#NoTrayIcon
#include-once
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
preInitHandler()
Global $aCaesarUC = declareCaesarTable("UC",4)
Global $aCaesarLC = declareCaesarTable("LC",4)
OnAutoItExitRegister("exitAll")

#cs
$_paramNum = $CmdLine[0]
If $_paramNum >= 1 Then
	If $_paramNum == 2 Then
		If $CmdLine[1] == "--throw" or $CmdLine[1] == "-t" then
			If IsInt($CmdLine[2])==1 Then
				Exit $CmdLine[2]
			EndIf
		EndIf
	EndIf
EndIf
#ce

Global $Form1_1, $OutputBox, $Button_Save, $Button_Import, $List1, $LucaInfo, $iCaesar = 0

#Region ### START Koda GUI section ### Form=c:\users\henrison\documents\meine dateien\anderes\anderes anderes\sach\autoit\_git\autoit_caesar\koda\form1.kxf
$Form1_1 = GUICreate(" Caesar Translator ", 804, 446, ((@DesktopWidth / 100) * 50) - (804 / 2), ((@DesktopHeight / 100) * 50) - (446 / 2))
Global $InputBox = GUICtrlCreateEdit("", 0, 0, 369, 305)
GUICtrlSetData(-1, "")
$OutputBox = GUICtrlCreateEdit("", 432, 0, 369, 305)
GUICtrlSetData(-1, "")
GUICtrlSetState(-1, $GUI_DISABLE)
$LucaInfo = GUICtrlCreateLabel("Henrison's Caesar Translator", 120, 384, 564, 40)
GUICtrlSetFont(-1, 27, 400, 0, "Terminal")
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetCursor (-1, 4)
$Button_Save = GUICtrlCreateButton("Speichern...", 424, 304, 379, 57)
GUICtrlSetFont(-1, 15, 400, 0, "Terminal")
GUICtrlSetTip(-1, "Strg+S")
GUICtrlSetCursor (-1, 3)
$Button_Import = GUICtrlCreateButton("Importieren...", 0, 304, 379, 57)
GUICtrlSetFont(-1, 15, 400, 0, "Terminal")
GUICtrlSetTip(-1, "Strg+O")
GUICtrlSetCursor (-1, 3)
$List1 = GUICtrlCreateList("", 368, 32, 65, 71)
GUICtrlSetData(-1, "Caesar_3|Caesar_5|Caesar_7|Caesar_9|kein Code")
GUICtrlSetCursor (-1, 0)
$Label2 = GUICtrlCreateLabel("Codierung:", 376, 8, 55, 17)
$Label3 = GUICtrlCreateLabel("-->", 376, 136, 58, 28)
GUICtrlSetFont(-1, 19, 800, 0, "Terminal")
GUICtrlSetColor(-1, 0x808000)
$Label4 = GUICtrlCreateLabel("-->", 376, 200, 58, 28)
GUICtrlSetFont(-1, 19, 800, 0, "Terminal")
GUICtrlSetColor(-1, 0x808000)
$Button_Translate = GUICtrlCreateButton("------->", 376, 168, 51, 25)
GUICtrlSetTip(-1, "Strg+T")
Dim $Form1_1_AccelTable[3][2] = [["^s", $Button_Save],["^o", $Button_Import],["^t", $Button_Translate]]
GUISetAccelerators($Form1_1_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			$var = MsgBox(1,"Caesar Translator","Wirklich beenden?","",$Form1_1)
			if $var == 1 then Exit 0

		Case $Button_Translate
			$sInputText = GUICtrlRead($InputBox)
$sOutputText = ""
For $i = 0 to StringLen($sInputText)-1
	$sTmp = StringLeft(StringRight($sInputText,StringLen($sInputText)-$i),1)
	If StringIsAlpha($sTmp)==1 then
		$hTmp = StringToBinary($sTmp)
		$iTmp = Int($hTmp)
		If $iTmp >= 65 and $iTmp <= 90 then $tTmp = $aCaesarUC[$iTmp][$iCaesar]
		If $iTmp >= 97 and $iTmp <= 122 then $tTmp = $aCaesarLC[$iTmp][$iCaesar]

		$sOutputText &= $tTmp
	Else
	$sOutputText &= $sTmp
	EndIf
Next





#cs			For $i = 90 to 65 step -1
				;_ArrayDisplay($aCaesarUC)
				;testVar("StringReplace("&$sInputText&","&$aCaesarUC[$i][0]&","&$aCaesarUC[$i][$iCaesar])
				$sOutputText = StringReplace($sInputText,$aCaesarUC[$i][0],$aCaesarUC[$i][$iCaesar])
				testVar($i&" "&$sOutputText&" "&$aCaesarUC[$i][0]&" "&$aCaesarUC[$i][$iCaesar])
			Next
			For $i = 122 to 97 step -1
				;_ArrayDisplay($aCaesarUC)
				$sOutputText = StringReplace($sInputText,$aCaesarLC[$i][0],$aCaesarLC[$i][$iCaesar])
#ce			Next

			GUICtrlSetData($OutputBox,$sOutputText)
		Case $LucaInfo
			testVar(Chr(7)&" Tja Lucca, ich bin fertig, wann bekomm ich deine Version zu sehen? :P")
		Case $Button_Save
			$sCodedText = GUICtrlRead($OutputBox)
			$sSaveToPath = FileSaveDialog("Codierten Text speichern als...", @DesktopDir, "Textdatei (*.txt)|Alle Dateien (*.*)", 2+16,"",$Form1_1)
			$fhSaveToFile = FileOpen($sSaveToPath,2+8+128)
			FileWrite($fhSaveToFile,$sCodedText)
			FileClose($fhSaveToFile)

		Case $Button_Import
			$sImportText = "Datei leer oder beschädigt!"
			$sImportFile = FileOpenDialog("Datei zum Codieren auswählen", @DesktopDir, "Textdateien (*.txt)",1+2,"",$Form1_1)
			$fhImportFile = FileOpen($sImportFile,0+128)
			$sImportText = FileRead($fhImportFile)
			GUICtrlSetData($InputBox,$sImportText)
		Case $List1
			$sCaesarCode = GUICtrlRead($List1)
			Switch $sCaesarCode
				Case "kein Code"
					$iCaesar = 0
				Case "Caesar_3"
					$iCaesar = 1
				Case "Caesar_5"
					$iCaesar = 2
				Case "Caesar_7"
					$iCaesar = 3
				Case "Caesar_9"
					$iCaesar = 4
			EndSwitch

	EndSwitch
WEnd

Func declareCaesarTable($case,$col)
	Switch $case
		Case "UC"
		dim $taCaesarUC[91][$col+1]
		For $i = 0 to $col
			For $j = 65 to 90
				If $j+$i*2 <= 90 then
					$taCaesarUC[$j][$i] = Chr($j+$i*2)
				Else
					$taCaesarUC[$j][$i] = Chr(($j+$i*2)-26)
				EndIf
			Next
			;_ArrayDisplay($aCaesarUC)
		Next
		Return $taCaesarUC

		Case "LC"
		dim $taCaesarLC[123][$col+1]
		For $i = 0 to $col
			For $j = 97 to 122
				If $j+$i*2 <= 122 then
					$taCaesarLC[$j][$i] = Chr($j+$i*2)
				Else
					$taCaesarLC[$j][$i] = Chr(($j+$i*2)-26)
				EndIf
			Next
			;_ArrayDisplay($aCaesarLC)
		Next
		Return $taCaesarLC
	EndSwitch
EndFunc


Func testVar($var)
	MsgBox(0,"",$var)
EndFunc

Func preInitHandler()
	Global $aErrorList[299]
	For $i = 2 to 298
		$aErrorList[$i] = "Unbekannter Fehler"
	Next


EndFunc

Func exitAll()
	If @exitCode == -1 Or @exitCode == 1 Then MsgBox(16, "SCHWERWIEGENDER FEHELER!", "Es ist ein schwerwiegender Fehler aufgetreten aufgrund dessen die Ausführung unterbrochen wurde." & @CRLF & @CRLF & "Error " & @exitCode)
	If @exitCode > 0 Then MsgBox(16, "caesartrans.exe HAT EIN PROBLEM FESTGESTELLT!", "Während des Ausführens wurde ein Problem festgestellt und das Programm musste beendet werden." & @CRLF & "Bitte melde den folgenden Fehler-Code:" & @CRLF & @CRLF & "Error " & @exitCode & @CRLF & $aErrorList[@exitCode])
	;Exit @exitCode
EndFunc   ;==>exitAll