﻿#Persistent
#NoEnv
#Include <classMemory>
#Include <convertToHex>
#SingleInstance, Force
#WinActivateForce
SendMode Input
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
FileEncoding UTF-8

questDict := { "Quest 001": "みーつけた！"
             , "Quest 002": "ごめんねなの！"
             , "Quest 003": "せんせいおしえて！"
             , "Quest 004": "ごはんだよ！"
             , "Quest 005": "おめでとーん！"
             , "Quest 175": "私はマイスターです。何かお困りですか？"
             , "Quest 331": "ベジーク・ベジセルク！"
             , "Quest 392": "ラナルータ"
             , "Quest 421": "われ　かのちをめざす"
             , "Quest 450": "ナドラガンドにヒカリあれ"
             , "Quest 453": "マイユさーん！"
             , "Quest 480": "モモンタル"
             , "Quest 496": "るるるんぽう"
             , "Quest 505 (1)": "おおきくなあれ！タネタネきゅん！"
             , "Quest 505 (2)": "てんまでとどけ！タネきゅんきゅん"
             , "Quest 516": "サインください"
             , "Quest 531": "ようせいさん　ようせいさん"
             , "Quest 580": "ギリウスへいか　ばんざい"
             , "Quest 581": "おくすりのじかんです"
             , "Quest 606": "ベントラー"
             , "Quest 608": "デスマスターはしなない"
             , "Quest 616": "げいじゅつはマデッサンスなり"
             , "Quest 627": "ガッタバ・ヨナクーン"
             , "Quest 660": "まじんのもんよひらけ"
             , "Quest 672": "ことばトハ　いしナリ"
             , "Quest 709": "てんそうしがらん"
             , "Version 3.2": "おままごとしましょー"
             , "Version 3.3 (1)": "にんげん"
             , "Version 3.3 (2)": "われワギにちかう"
             , "Version 3.4": "みのり"
			 , "Version 4.5": "ユマテルのカギ"
             , "Version 5.2 (1)": "リドよめざめよ"
			 , "Version 5.2 (2)": "われじゆうをもとむ"
             , "Version 5.5": "リドよわがともよ"
             , "Version 6.1": "むすすへえまめともりかひしうとんさられわ" }

seasonalDict := { "Halloween Quest": "トリックオアトリート"
                , "Christmas Quest": "メリークリスマス" 
				, "Valentine's Quest": "ハッピーバレンタイン" 
				, "White Day Quest": "ハッピーホワイトデー" }

commonPhrasesDict := { "Thank you!": "ありがとう！"
                     , "Hello!": "こんにちは！"
                     , "Good luck!": "がんばって！"
                     , "Congrats!": "おめでとう！"
                     , "No problem.": "どういたしまして"
                     , "Nice to meet you.": "よろしくお願いします"
                     , "Good job.": "おつかれさまでした"
                     , "Sorry.": "ごめんなさい"
                     , "Are you ready?": "準備OK?"
                     , "I'll do my best!": "がんばります！"
                     , "I understand.": "わかりました"}

; These will change on patches
chatAddress := 0x01F87A5C
chatOffsets := [0x364, 0xFC, 0x0, 0x10, 0x0, 0x10]
nameAddress := 0x01F86D30
nameOffsets := [0x34, 0xB0, 0xE4, 0x30, 0xFC, 0x4, 0x10, 0x0, 0x10]

Gui, 1:Default
Gui, Add, Tab3,, General|Quests|Seasonals|Common Phrases|Storage Name
Gui, Font, s16, Segoe UI
Gui, Add, Text,, What is this?
Gui, Font, s12, Segoe UI
Gui, Add, Text,, A small program to get around no copy/paste support in DQX.
Gui, Add, Text,y+1, Helpful for quests where you need to type Japanese to proceed, but`nyou don't know how.  :(
Gui, Font, s16, Segoe UI
Gui, Add, Text,, How to use:
Gui, Font, s12, Segoe UI
Gui, Add, Text,y+1, - Open a fresh chat box in game and switch to the desired chat category
Gui, Add, Text,y+1, - Bring this program into focus and paste the Japanese text you want to`n   send to DQX
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will move your DQX chat cursor to`n   the appropriate position and send the text into the DQX chat window
Gui, Add, Edit, r1 vTextToSend w500, %textToSend%
Gui, Add, Button, gSend, Send to DQX
Gui, Add, Button, gCloseApp x+295, Exit Program

Gui, Tab, Quests
Gui, Add, Text,, Press a button to enter what you need to say to continue the quest.
For index, value in questDict
  If (A_Index < 11)
    Gui, Add, Button, gQuestSend, %index%
  Else If (A_Index = 11)
    Gui, Add, Button, gQuestSend x+10 y79, %index%
  Else If (A_Index > 11 and A_Index < 21)
    Gui, Add, Button, gQuestSend, %index%
  Else If (A_Index = 21)
    Gui, Add, Button, gQuestSend x+20 y79, %index%
  Else If (A_Index > 21 and A_Index < 31)
    Gui, Add, Button, gQuestSend, %index%
  Else If (A_Index = 31)
    Gui, Add, Button, gQuestSend x+30 y79, %index%
  Else If (A_Index > 31 and A_Index < 41)
    Gui, Add, Button, gQuestSend, %index%

Gui, Tab, Seasonals
Gui, Add, Text,, Press a button to enter what you need to say to continue the quest.
For index, value in seasonalDict
  Gui, Add, Button, gSeasonalSend, %index%

Gui, Tab, Common Phrases
Gui, Add, Text,, Press a button to enter a common phrase into the chat.
For index, value in commonPhrasesDict
  If (A_Index < 11)
    Gui, Add, Button, gPhraseSend, %index%
  Else If (A_Index = 11)
    Gui, Add, Button, gPhraseSend x+100 y79, %index%
  Else If (A_Index > 11 and A_Index < 21)
    Gui, Add, Button, gPhraseSend, %index%
  Else If (A_Index = 21)
    Gui, Add, Button, gPhraseSend x+100 y79, %index%
  Else If (A_Index > 21 and A_Index < 31)
    Gui, Add, Button, gPhraseSend, %index%

Gui, Tab, Storage Name
Gui, Font, s16, Segoe UI
Gui, Add, Text,, Change the name of your storage.
Gui, Font, s12, Segoe UI
Gui, Add, Text,y+1, - Go to a depository and select the option 'Change Name'.
Gui, Add, Text,y+1, - Select the Storage that you would like to change.
Gui, Add, Text,y+1, - The cursor will be in the name text box at this point.
Gui, Add, Text,y+1, - Enter the name you want below.
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will enter the name into the text box.
Gui, Add, Text,y+1, - Press the button mapped to 'Confirm' on your controller.`n    (Using a keyboard won't work properly)
Gui, Add, Text,y+1, - Finally, select the confirm option in game. The storage is now renamed.
Gui, Font, s14, Segoe UI
Gui, Add, Text,x20 y+10, Maximum 8 Characters
Gui, Add, Text,x20 y+1, Alphanumeric characters, dashes and spaces only.
Gui, Font, s12, Segoe UI
Gui, Add, Edit, r1 vNameToSend w500, %NameToSend%
Gui, Add, Button, gStorageSend, Send to DQX

Gui, +alwaysontop
Gui, Show, Autosize
Return

CloseApp:
  ExitApp

Send:
  GuiControlGet, TextToSend
  text_len := StrLen(TextToSend)
  sanitizedBytes := StrReplace(convertStrToHex(textToSend), "`r`n", "")
  numberToArrowOver := StrLen(sanitizedBytes) // 2

  Process, Exist, DQXGame.exe
  if ErrorLevel
  {
    WinActivate, ahk_exe DQXGame.exe
    ;; Have to move the chat cursor to the position to where it should be for the text to send correctly
    Loop {
      Sleep 50
      Send {Right}
    }
    Until A_Index = numberToArrowOver

    dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
    baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")
    dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(textToSend), chatOffsets*)
    if (text_len > 13)
    {
      Loop, 15 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(TextToSend), chatOffsets*)
      Loop, 8 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(TextToSend), chatOffsets*)
    }
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

QuestSend:
  GuiControlGet, getQuestNumber,, % A_GuiControl
  questText := questDict[getQuestNumber]
  text_len := StrLen(questText)
  sanitizedBytes := StrReplace(convertStrToHex(questText), "`r`n", "")
  numberToArrowOver := StrLen(sanitizedBytes) // 2

  Process, Exist, DQXGame.exe
  if ErrorLevel
  {
    WinActivate, ahk_exe DQXGame.exe
    ;; Have to move the chat cursor to the position to where it should be for the text to send correctly
    Loop {
      Sleep 50
      Send {Right}
    }
    Until A_Index = numberToArrowOver

    dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
    baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")
    dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(questText), chatOffsets*)
    if (text_len > 13)
    {
      Loop, 15 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(questText), chatOffsets*)
      Loop, 8 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(questText), chatOffsets*)
    }
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

SeasonalSend:
  GuiControlGet, getQuestNumber,, % A_GuiControl
  questText := seasonalDict[getQuestNumber]
  text_len := StrLen(questText)
  sanitizedBytes := StrReplace(convertStrToHex(questText), "`r`n", "")
  numberToArrowOver := StrLen(sanitizedBytes) // 2

  Process, Exist, DQXGame.exe
  if ErrorLevel
  {
    WinActivate, ahk_exe DQXGame.exe
    ;; Have to move the chat cursor to the position to where it should be for the text to send correctly
    Loop {
      Sleep 50
      Send {Right}
    }
    Until A_Index = numberToArrowOver

    dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
    baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")
    dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(questText), chatOffsets*)
    if (text_len > 13)
    {
      Loop, 15 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(questText), chatOffsets*)
      Loop, 8 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(questText), chatOffsets*)
    }
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

PhraseSend:
  GuiControlGet, getPhrase,, % A_GuiControl
  phraseText := commonPhrasesDict[getPhrase]
  text_len := StrLen(phraseText)
  sanitizedBytes := StrReplace(convertStrToHex(phraseText), "`r`n", "")
  numberToArrowOver := StrLen(sanitizedBytes) // 2

  Process, Exist, DQXGame.exe
  if ErrorLevel
  {
    WinActivate, ahk_exe DQXGame.exe
    ;; Have to move the chat cursor to the position to where it should be for the text to send correctly
    Loop {
      Sleep 50
      Send {Right}
    }
    Until A_Index = numberToArrowOver

    dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
    baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")
    dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(phraseText), chatOffsets*)
    if (text_len > 13)
    {
      Loop, 15 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(phraseText), chatOffsets*)
      Loop, 8 {
        Sleep 50
        Send {Space}
      }
      dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(phraseText), chatOffsets*)
    }
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

StorageSend:
  GuiControlGet, NameToSend
  numChars := StrLen(NameToSend)
  if (numChars > 8){
    {
      MsgBox, 4096, Attention!, Name must be 8 characters or less!
    }
  Return
  }
  else If RegExMatch(NameToSend, "[^a-zA-Z0-9\s\-]"){
    {
      MsgBox, 4096, Attention!, Name must contain letters, numbers, dashes and spaces only!
    }
  Return
  }
  else
  {
    NameToSend := replaceHalfwidth(NameToSend)
    replaceHalfwidth(NameToSend) {
      NameToSend := StrReplace(NameToSend, "`r`n`", "")
      StringCaseSense, On
      Loop, 26
      {
        NameToSend := StrReplace(NameToSend, Chr(65 - 1 + A_Index), Chr(65313 - 1 + A_Index))
        NameToSend := StrReplace(NameToSend, Chr(97 - 1 + A_Index), Chr(65345 - 1 + A_Index))
      }
      Loop, 10
      {
        NameToSend := StrReplace(NameToSend, Chr(48 - 1 + A_Index), Chr(65296 - 1 + A_Index))
      }
      NameToSend := StrReplace(NameToSend, Chr(45), Chr(12540))
      NameToSend := StrReplace(NameToSend, Chr(32), Chr(12288))
      return, NameToSend
    }
    StringCaseSense, Off
    hexName := convertStrToHex(NameToSend)
    addByte := 00
    num_bytes_to_add := 25 - (numChars * 3)
    loop, %num_bytes_to_add%
    {
      hexName = %hexName%%addByte%
    }
    Process, Exist, DQXGame.exe
    if ErrorLevel
    {
      WinActivate, ahk_exe DQXGame.exe
      dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
      baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")
      dqx.writeBytes(baseAddress + nameAddress, hexName, nameOffsets*)
    }
    else
    {
      msgBox "DQX window not found."
    }
    Return
  }