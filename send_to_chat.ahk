#Persistent
#NoEnv
#Include <classMemory>
#Include <convertToHex>
#Include <checkElevation>
#SingleInstance, Force
#WinActivateForce
SendMode Input
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
FileEncoding UTF-8


; These will change on patches
; How do you find this?
; * Open a chat box in-game (shift+enter)
; * Type something unique (I use bananaparrot)
; * Search for the text in cheat engine
; * Edit each result until you see it change on screen in your chat box
; * When you find the one that changes, do a pointer scan on it. This will gives you hundreds of thousands of results
; * Search for something else unique (bananasandapples)
; * Find the address that updates the text on-screen
; * Re-scan using your same pointer scan session with the new address
; * Re-launch the game, leaving Cheat Engine open so you don't lose your pointer scan session
; * Do the above chat tasks you just did again (type, edit, scan)
; * This should give you a list of pointers that are pointing at the chat buffer
; * Update the address + pointers below and test
global chatAddress := 0x01B8B7B4
global chatOffsets := [0x8, 0x8C, 0x8, 0x90, 0x2DC, 0x0]

questDict := { "Asfeld: Chapter 5": "わかめ かめかめ うみのさち"
             , "Quest 001": "みーつけた！"
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
             , "Quest 578": "われらみなレトリウスのこ"
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
             , "Quest 761": "うんめいとは"
             , "Seasonal: Christmas Quest": "メリークリスマス"
             , "Seasonal: Halloween Quest": "トリックオアトリート"
             , "Seasonal: Valentine's Quest": "ハッピーバレンタイン"
             , "Seasonal: White Day Quest": "ハッピーホワイトデー"
             , "Utopia Q485 Boss Unlock": "りゅうとうしがあらわれた！コマンド？"
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
             , "Version 6.5": "こうろのかぎ"
             , "Version 7.0": "まれびと" 
             , "Version 7.1 (1)": "ニワトリ" 
             , "Version 7.1 (2)": "ネズミ" 
             , "Version 7.2": "だんざいのけん！" }

commonPhrasesDict := { "Thank you!": "ありがとう！"
                     , "Hello!": "こんにちは！"
                     , "Good luck!": "がんばって！"
                     , "Congrats!": "おめでとう！"
                     , "No problem.": "どういたしまして"
                     , "Nice to meet you.": "よろしくお願いします"
                     , "Nice job, everyone!": "おつかれさまでした"
                     , "Sorry.": "ごめんなさい"
                     , "Are you ready?": "準備OK?"
                     , "I'll do my best!": "がんばります！"
                     , "I understand.": "わかりました"}


Gui, 1:Default
Gui, Add, Tab3,, General|Quests|Common Phrases
Gui, Font, s16, Segoe UI
Gui, Add, Text,, What is this?
Gui, Font, s12, Segoe UI
Gui, Add, Text,, A small program to get around no copy/paste support in DQX.
Gui, Font, s16, Segoe UI
Gui, Add, Text,, How to use:
Gui, Font, s12, Segoe UI
Gui, Add, Text,y+1, - Open a fresh chat box in game and switch to the desired chat category`n  (do not open the chat box through the frequent phrases menu or DQX will crash)
Gui, Add, Text,y+1, - Bring this program into focus and paste the Japanese text you want to send to DQX
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will move your DQX chat cursor to the appropriate`n  position and send the text into the DQX chat window.`n- Note: If you're trying to send using the latin alphabet, things will look weird!`n  This is intended to send Japanese characters. If you're just seeing blank characters`n  get inserted, try opening and closing the chat box a few times.
Gui, Add, Edit, r1 vTextToSend w600, %textToSend%
Gui, Add, Button, gSend, Send to DQX
Gui, Add, Button, gCloseApp x+392, Exit Program

Gui, Tab, Quests
Gui, Add, Text,, Select the relevant quest to enter text into the chat.
QuestDDL :=
For index, value in questDict
  QuestDDL := QuestDDL . "|" . index
QuestDDL := SubStr(QuestDDL, 2)
Gui, Add, DropDownList, vQuestSelect w500, %QuestDDL%
Gui, Add, Button, gQuestSend x21 y133, Send to DQX

Gui, Tab, Common Phrases
Gui, Add, Text,, Press a button to enter a common phrase into the chat.
For index, value in commonPhrasesDict
  If (A_Index < 11)
    Gui, Add, Button, gPhraseSend, %index%
  Else If (A_Index = 11)
    Gui, Add, Button, gPhraseSend x+100 y97, %index%
  Else If (A_Index > 11 and A_Index < 21)
    Gui, Add, Button, gPhraseSend, %index%
  Else If (A_Index = 21)
    Gui, Add, Button, gPhraseSend x+100 y97, %index%
  Else If (A_Index > 21 and A_Index < 31)
    Gui, Add, Button, gPhraseSend, %index%

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
    MsgBox, 4096,, DQX window not found. Is it open?
  Return


QuestSend:
  GuiControlGet, QuestSelect
  questText := questDict[QuestSelect]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(questText)
  else
    MsgBox, 4096,, DQX window not found. Is it open?
  Return


PhraseSend:
  GuiControlGet, getPhrase,, % A_GuiControl
  phraseText := commonPhrasesDict[getPhrase]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(phraseText)
  else
    MsgBox, 4096,, DQX window not found. Is it open?
  Return


WriteToDQX(textToSend) {
  ; Check that DQX is running before attempting to write anything.
  Process, Exist, DQXGame.exe
  pid := ErrorLevel
  if (pid = 0) {
    MsgBox, 4096,, Could not get DQXGame.exe process id.
    ExitApp
  }

  ; If DQX is elevated, make sure this program is too.
  is_elevated := IsProcessElevated(pid)
  if (is_elevated != 0) {
    if (A_IsAdmin = 0) {
      MsgBox, 4096,, DQX is running as admin, but this program is not. Re-launch send to chat as an administrator and try again.
      ExitApp
    }
  }

  ; Instantiate a new memory object each run. Users tend to forget to relaunch the program after restarting DQX.
  dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
  baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")

  Loop, Parse, textToSend
  {
    ; Instead of naturally sending text to the client, we read the requested text, convert it into utf-8 bytes
    ; and write it directly into the game's chat buffer. We do this because users tend to not have the
    ; Japanese language / keyboard installed on their computers. Additionally, the game may not have been launched
    ; with CreateProcessW support (only CreateProcessA). This bypasses the need to do this.
    ;
    ; To imitate typing into the buffer, we need to trick the game into thinking we typed into it. We do this by
    ; arrowing over the number of bytes a character would have been (3), then inserting the character into the buffer.
    WinActivate, ahk_exe DQXGame.exe
    Send {Right}
    Sleep 50
    WinActivate, ahk_exe DQXGame.exe
    Send {Right}
    Sleep 50
    WinActivate, ahk_exe DQXGame.exe
    Send {Right}
    Sleep 50

    if (A_Index = 1)
      startAddress := dqx.getAddressFromOffsets(baseAddress + chatAddress, chatOffsets*)

    dqx.writeBytes(startAddress, convertStrToHex(A_LoopField))
    startAddress := startAddress + 3 ; We do this as each JP character takes 3 bytes.

    ; For phrases that use all 20 available JP characters in the chatbox,
    ; we need to arrow over to the left once, and then back to the right to
    ; get it to properly send.
    if (A_Index = 20) {
      WinActivate, ahk_exe DQXGame.exe
      Send {Left}
      Sleep 50
      Send {Right}
    }
  }
}
