#Persistent
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
             , "Quest 505a": "おおきくなあれ！タネタネきゅん！"
             , "Quest 505b": "てんまでとどけ！タネきゅんきゅん"
             , "Quest 516": "サインください"
             , "Quest 531": "ようせいさん　ようせいさん"
             , "Quest 580": "ギリウスへいか　ばんざい"
             , "Quest 606": "ベントラー"
             , "Quest 608": "デスマスターはしなない"
             , "Quest 616": "げいじゅつはマデッサンスなり"
             , "Quest 627": "ガッタバ・ヨナクーン"
             , "Quest 660": "まじんのもんよひらけ"
             , "Quest 672": "ことばトハ　いしナリ"
			 , "Quest 709": "てんそうしがらん" }

seasonalDict := { "Halloween Quest": "トリックオアトリート"
                , "Christmas Quest": "メリークリスマス" }

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
chatAddress := 0x01F5F958
chatOffsets := [0x364, 0xFC, 0x0, 0x10, 0x0, 0x10]

Gui, 1:Default
Gui, Add, Tab3,, General|Quests|Seasonals|Common Phrases
Gui, Font, s16, Segoe UI
Gui, Add, Text,, What is this?
Gui, Font, s12, Segoe UI
Gui, Add, Text,, A small program to get around no copy/paste support in DQX.
Gui, Add, Text,y+1, Helpful for quests where you need to type Japanese to proceed,`n  but you don't know how. :(
Gui, Font, s16, Segoe UI
Gui, Add, Text,, How to use:
Gui, Font, s12, Segoe UI
Gui, Add, Link,, - Open DQX with something like <a href="https://xupefei.github.io/Locale-Emulator/">Locale Emulator</a> to allow typing in`n    Japanese (you don't need the Japanese IME keyboard active for this)
Gui, Add, Text,y+1, - Open a fresh chat box in game and switch to the desired chat category
Gui, Add, Text,y+1, - Bring this program into focus and paste the Japanese text you want to `n    send to DQX
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will move your DQX chat cursor to`n    the appropriate position and send the text into the DQX chat window
Gui, Add, Edit, r1 vTextToSend w500, %textToSend%
Gui, Add, Button, gSend, Send to DQX
Gui, Add, Button, gCloseApp x+295, Exit Program

Gui, Tab, Quests
Gui, Add, Text,, Press a button to enter what you need to say to continue the quest.
For index, value in questDict
  If (A_Index < 11)
    Gui, Add, Button, gQuestSend, %index%
  Else If (A_Index = 11)
    Gui, Add, Button, gQuestSend x+10 y58, %index%
  Else If (A_Index > 11 and A_Index < 21)
    Gui, Add, Button, gQuestSend, %index%
  Else If (A_Index = 21)
    Gui, Add, Button, gQuestSend x+20 y58, %index%
  Else If (A_Index > 21 and A_Index < 31)
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
    Gui, Add, Button, gPhraseSend x+10 y58, %index%
  Else If (A_Index > 11 and A_Index < 21)
    Gui, Add, Button, gPhraseSend, %index%
  Else If (A_Index = 21)
    Gui, Add, Button, gPhraseSend x+20 y58, %index%
  Else If (A_Index > 21 and A_Index < 31)
    Gui, Add, Button, gPhraseSend, %index%


Gui, +alwaysontop
Gui, Show, Autosize
Return

CloseApp:
  ExitApp

Send:
  GuiControlGet, TextToSend
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
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

QuestSend:
  GuiControlGet, getQuestNumber,, % A_GuiControl
  questText := questDict[getQuestNumber]
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
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

SeasonalSend:
  GuiControlGet, getQuestNumber,, % A_GuiControl
  questText := seasonalDict[getQuestNumber]
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
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return

PhraseSend:
  GuiControlGet, getPhrase,, % A_GuiControl
  phraseText := commonPhrasesDict[getPhrase]
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
  }
  else
  {
    msgBox "DQX window not found."
  }
  Return
