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
             , "Quest 422": "ラナルータ"
             , "Quest 450": "ナドラガンドにヒカリあれ"
             , "Quest 453": "マイユさーん！"
             , "Quest 480": "モモンタル"
             , "Quest 496": "るるるんぽう"
             , "Quest 505 (1)": "おおきくなあれ！タネタネきゅん！"
             , "Quest 505 (2)": "てんまでとどけ！タネきゅんきゅん"
             , "Quest 516": "サインください"
             , "Quest 531": "ようせいさん　ようせいさん"
             , "Quest 538": "フミンフキュウ"
             , "Quest 561": "イア・タア・シンパッ・ケウ"
             , "Quest 580": "ギリウスへいか　ばんざい"
             , "Quest 581": "おくすりのじかんです"
             , "Quest 606": "ベントラー"
             , "Quest 608": "デスマスターはしなない"
             , "Quest 616": "げいじゅつはマデッサンスなり"
             , "Quest 627": "ガッタバ・ヨナクーン"
             , "Quest 660": "まじんのもんよひらけ"
             , "Quest 672": "ことばトハ　いしナリ"
             , "Quest 709": "てんそうしがらん"
             , "Quest 728": "げんえいのほろ"
             , "Version 3.2": "おままごとしましょー"
             , "Version 3.3 (1)": "にんげん"
             , "Version 3.3 (2)": "われワギにちかう"
             , "Version 3.4 Sea of Worth": "みのり"
             , "Version 3.4 Sea of Unity": "やすらぎ"
             , "Version 3.4 Sea of Peace": "しあわせ"
             , "Version 3.4 Sea of Doubt": "ためらい"
             , "Version 3.4 Sea of Sleep": "えいえん"
             , "Version 3.4 Sea of Light": "よろこび"
             , "Version 4.0: Dancer 1 (Nina)": "ニイナ"
             , "Version 4.0: Dancer 2 (Cute)": "キュート"
             , "Version 4.0: Dancer 3 (Rominique)": "ロミニク"
             , "Version 4.4 (1)": "よろこびのそのであおう"
             , "Version 4.4 (2)": "フォステイルが！"
             , "Version 4.5": "ユマテルのカギ"
             , "Version 5.2 (1)": "リドよめざめよ"
             , "Version 5.2 (2)": "われじゆうをもとむ"
             , "Version 5.5": "リドよわがともよ"
             , "Version 6.1": "むすすへえまめともりかひしうとんさられわ"
             , "Version 6.5": "こうろのかぎ" }

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
global chatAddress := 0x02015A98
global chatOffsets := [0x364, 0xFC, 0x0, 0x8, 0x2DC, 0x0]
global storageAddress := 0x02015A98
global storageOffsets := [0x364, 0x8, 0x10, 0x4, 0x10, 0x4, 0x4, 0x8, 0x2DC, 0x0]
global friendAddress := 0x02015A98
global friendOffsets := [0x364, 0xFC, 0x10, 0x10, 0x10, 0x10, 0x4, 0x8, 0x2DC, 0x0]
global teamAddress := 0x02015A98
global teamOffsets := [0x364, 0x8, 0x10, 0x4, 0x10, 0x4, 0x4, 0x8, 0x2DC, 0x0]

global dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
global baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")

Gui, 1:Default
Gui, Add, Tab3,, General|Quests|Seasonals|Common Phrases|Storage Name|Add Friend|Team Name
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
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will move your DQX chat cursor to`n   the appropriate position and send the text into the DQX chat window.`n- Note: If you're trying to send using the latin alphabet, things will`n   look weird! This is intended to send Japanese characters
Gui, Add, Edit, r1 vTextToSend w500, %textToSend%
Gui, Add, Button, gSend, Send to DQX
Gui, Add, Button, gCloseApp x+295, Exit Program

Gui, Tab, Quests
Gui, Add, Text,, Select the relevant quest to enter text into the chat.
QuestDDL := 
For index, value in questDict
  QuestDDL := QuestDDL . "|" . index
QuestDDL := SubStr(QuestDDL, 2)
Gui, Add, DropDownList, vQuestSelect w500, %QuestDDL%
Gui, Add, Button, gQuestSend x21 y110, Send to DQX

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
Gui, Add, Text,y+1, - Press the button mapped to 'Confirm' on your controller.`n   (Using a keyboard won't work properly)
Gui, Add, Text,y+1, - Finally, select the 'Confirm' option in game. The storage is now renamed.
Gui, Font, s14, Segoe UI
Gui, Add, Text,x20 y+10, Maximum 8 Characters
Gui, Add, Text,x20 y+1, Alphanumeric characters, dashes and spaces only.
Gui, Font, s12, Segoe UI
Gui, Add, Edit, r1 vNameToSend w500, %NameToSend%
Gui, Add, Button, gStorageSend, Send to DQX

Gui, Tab, Add Friend
Gui, Font, s16, Segoe UI
Gui, Add, Text,, Enter a name when adding a friend or team member using`n'Enter Name && ID'.
Gui, Font, s12, Segoe UI
Gui, Add, Text,y+1, - Open the command menu and select the 'Misc.' option.
Gui, Add, Text,y+1, - To add a friend, select 'Friends' then 'Add Friend'.
Gui, Add, Text,y+1, - To add a team member, select 'Team' then 'Invite to Team'.
Gui, Add, Text,y+1, - Select 'Enter Name && ID'.
Gui, Add, Text,y+1, - Press the button mapped to 'Confirm' on your controller'.
Gui, Add, Text,y+1, - The cursor will be in the name text box at this point.
Gui, Add, Text,y+1, - Enter the Japanese name of the player you want to add below.
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will enter the name into the text box.
Gui, Add, Text,y+1, - Press the button mapped to 'Confirm' on your controller.`n   (Using a keyboard won't work properly. The cursor may automatically move to`n    the Player ID box if the name contains 6 characters)
Gui, Add, Text,y+1, - Finally, enter the Player ID and select the 'Confirm' option in game.
Gui, Font, s14, Segoe UI
Gui, Add, Text,x20 y+10, Maximum 6 Characters
Gui, Add, Text,x20 y+1, Characters used during player name creation only.
Gui, Font, s12, Segoe UI
Gui, Add, Edit, r1 vFriendToSend w500, %FriendToSend%
Gui, Add, Button, gFriendSend, Send to DQX

Gui, Tab, Team Name
Gui, Font, s16, Segoe UI
Gui, Add, Text,, Enter a team name when forming a team.
Gui, Font, s12, Segoe UI
Gui, Add, Text,y+1, - Talk to a Team Ambassador in town and select 'Form Team'.
Gui, Add, Text,y+1, - Select 'Yes' to register a team.
Gui, Add, Text,y+1, - Continue until the cursor is in the team name text box.
Gui, Add, Text,y+1, - Enter the name you want below.
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will enter the name into the text box.
Gui, Add, Text,y+1, - Press the button mapped to 'Confirm' on your controller.`n   (Using a keyboard won't work properly.)
Gui, Add, Text,y+1, - Finally, select the 'Confirm' option in game.
Gui, Font, s14, Segoe UI
Gui, Add, Text,x20 y+10, Maximum 10 Characters
Gui, Add, Text,x20 y+1, Alphanumeric characters, dashes and spaces only.
Gui, Font, s12, Segoe UI
Gui, Add, Edit, r1 vTeamToSend w500, %TeamToSend%
Gui, Add, Button, gTeamSend, Send to DQX

Gui, +alwaysontop
Gui, Show, Autosize
Return

CloseApp:
  ExitApp

Send:
  GuiControlGet, TextToSend

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(TextToSend)
  else
    msgBox "DQX window not found."
  Return

QuestSend:
  GuiControlGet, QuestSelect
  questText := questDict[QuestSelect]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(questText)
  else
    msgBox "DQX window not found."
  Return

SeasonalSend:
  GuiControlGet, getQuestNumber,, % A_GuiControl
  seasonalText := seasonalDict[getQuestNumber]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(seasonalText)
  else
    msgBox "DQX window not found."
  Return

PhraseSend:
  GuiControlGet, getPhrase,, % A_GuiControl
  phraseText := commonPhrasesDict[getPhrase]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(phraseText)
  else
    msgBox "DQX window not found."
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
      dqx.writeBytes(baseAddress + storageAddress, hexName, storageOffsets*)
    }
    else
    {
      msgBox "DQX window not found."
    }
    Return
  }
  
FriendSend:
  GuiControlGet, FriendToSend
  numChars := StrLen(FriendToSend)
  if (numChars > 6){
    {
      MsgBox, 4096, Attention!, Name must be 6 characters or less!
    }
  Return
  }
  else If RegExMatch(FriendToSend, "[ゐゑヰヱ]"){
    {
      MsgBox, 4096, Attention!, Name must contain characters used during player name creation only!
    }
  Return
  }
  else If RegExMatch(FriendToSend, "[^ぁ-んァ-ンヴ・ー～]"){
    {
      MsgBox, 4096, Attention!, Name must contain characters used during player name creation only!
    }
  Return
  }
  else
  {
    hexName := convertStrToHex(FriendToSend)
    addByte := 00
    num_bytes_to_add := 19 - (numChars * 3)
    loop, %num_bytes_to_add%
    {
      hexName = %hexName%%addByte%
    }
    Process, Exist, DQXGame.exe
    if ErrorLevel
    {
      WinActivate, ahk_exe DQXGame.exe
      dqx.writeBytes(baseAddress + friendAddress, hexName, friendOffsets*)
    }
    else
    {
      msgBox "DQX window not found."
    }
    Return
  }

TeamSend:
  GuiControlGet, TeamToSend
  numChars := StrLen(TeamToSend)
  if (numChars > 10){
    {
      MsgBox, 4096, Attention!, Name must be 10 characters or less!
    }
  Return
  }
  else If RegExMatch(TeamToSend, "[^a-zA-Z0-9\s\-]"){
    {
      MsgBox, 4096, Attention!, Name must contain letters, numbers, dashes and spaces only!
    }
  Return
  }
  else
  {
    TeamToSend := replaceTeamHalfwidth(TeamToSend)
    replaceTeamHalfwidth(TeamToSend) {
      TeamToSend := StrReplace(TeamToSend, "`r`n`", "")
      StringCaseSense, On
      Loop, 26
      {
        TeamToSend := StrReplace(TeamToSend, Chr(65 - 1 + A_Index), Chr(65313 - 1 + A_Index))
        TeamToSend := StrReplace(TeamToSend, Chr(97 - 1 + A_Index), Chr(65345 - 1 + A_Index))
      }
      Loop, 10
      {
        TeamToSend := StrReplace(TeamToSend, Chr(48 - 1 + A_Index), Chr(65296 - 1 + A_Index))
      }
      TeamToSend := StrReplace(TeamToSend, Chr(45), Chr(12540))
      TeamToSend := StrReplace(TeamToSend, Chr(32), Chr(12288))
      return, TeamToSend
    }
    StringCaseSense, Off
    hexName := convertStrToHex(TeamToSend)
    addByte := 00
    num_bytes_to_add := 31 - (numChars * 3)
    loop, %num_bytes_to_add%
    {
      hexName = %hexName%%addByte%
    }
    Process, Exist, DQXGame.exe
    if ErrorLevel
    {
      WinActivate, ahk_exe DQXGame.exe
      dqx.writeBytes(baseAddress + teamAddress, hexName, teamOffsets*)
    }
    else
    {
      msgBox "DQX window not found."
    }
    Return
  }

WriteToDQX(textToSend)
{
  ; Iterate over each character in the phrase
  Loop, Parse, textToSend
  {
    ;; Have to move the chat cursor to the position to where it should be for the text to send correctly
    WinActivate, ahk_exe DQXGame.exe
    Sleep 50
    Send {Right}
    Sleep 50
    Send {Right}
    Sleep 50
    Send {Right}
    Sleep 50
    if (A_Index = 1)
      startAddress := dqx.getAddressFromOffsets(baseAddress + chatAddress, chatOffsets*)
    dqx.writeBytes(startAddress, convertStrToHex(A_LoopField))
    startAddress := startAddress + 3 ; We do this as each JP character takes 3 bytes.
    ; For phrases that use all 20 available JP characters in the chatbox,
    ; we need to arrow over to the left once, and then back to the right to
    ; get it to properly send.
    if (A_Index = 20)
    {
      Send {Left}
      Sleep 50
      Send {Right}
    }
  }
}
