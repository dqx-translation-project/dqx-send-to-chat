#Persistent
#NoEnv
#Include <classMemory>
#Include <convertToHex>
#Include <checkElevation>
#Include <JSON>
#SingleInstance, Force
#WinActivateForce
SendMode Input
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
FileEncoding UTF-8

; This should be updated every time we compile a new version and push it out to users.
; It is used to check for updates against GitHub's tagging scheme.
;
; Versioning scheme:
;   vX.X.X.Y => v = static; X.X.X = DQX version; Y = Send to Chat revision (starts at 0)
global scriptVer := "v7.4.1.1"

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
global chatAddress := 0x01C312D8
global chatOffsets := [0x364, 0x104, 0x0, 0x10, 0x0, 0x10]

;=== Auto update ===============================================
oWhr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
url := "https://api.github.com/repos/dqx-translation-project/dqx-send-to-chat/releases/latest"
oWhr.Open("GET", url, 0)
oWhr.Send()
oWhr.WaitForResponse()
jsonResponse := JSON.Load(oWhr.ResponseText)
latestVersion := (jsonResponse.tag_name)

if (oWhr.Status != 200) {
  statusCode := oWhr.Status
  message := oWhr.StatusText
  MsgBox, 4112,, Failed to check for updates.`n`nStatus code: %statusCode% `nMessage: %message%
}
else {
  if (latestVersion != scriptVer) {
    MsgBox, 4, Send to Chat: Update available, A new version of Send to Chat is available.`n`nCurrent version: %scriptVer%`nLatest Version: %latestVersion%`n`nDo you wish to update?

    ; IfMsgBox *requires* curly braces to be below the function for some reason.
    IfMsgBox, Yes
    {
      UrlDownloadToFile, https://github.com/dqx-translation-project/dqx-send-to-chat/releases/latest/download/send_to_chat.exe, .\send_to_chat_new.exe
      if (ErrorLevel) {
        FileDelete, .\send_to_chat_new.exe
        MsgBox, 4112,, Update failed. Please try again later.`n`nError level: %ErrorLevel%
      }
      else {
        FileMove, .\send_to_chat.exe, A_Temp\send_to_chat_old.exe, 1
        FileMove, .\send_to_chat_new.exe, .\send_to_chat.exe, 1
        MsgBox, Update successful. Send to Chat will now relaunch.
        Reload
      }
    }
  }
}

; Delete old executable if exists.
FileDelete, A_Temp\send_to_chat_old.exe

questDict := { "Asfeld: Chapter 5": "わかめ かめかめ うみのさち"
             , "Asfeld: Place of Prayer": "オープンザチャクラ"
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
             , "Quest 485 (Utopia: Boss Unlock)": "りゅうとうしがあらわれた！コマンド？"
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
                     , "Are you ready?": "準備ＯＫ？"
                     , "I'll do my best!": "がんばります！"
                     , "I understand.": "わかりました" }

; Adds image to compiled exe. Writes the file to the user's filesystem
; and deletes it when the program closes. Stores image in %APPDATA%\Temp
if (A_IsCompiled) {
  bannerImage := A_Temp . "\sendtochat.png"
}
else
  bannerImage := ".\imgs\sendtochat.png"

FileInstall, .\imgs\sendtochat.png, %bannerImage%

Gui, +AlwaysOnTop

; General tab
Gui, 1:Default
Gui, Add, Tab3,, General|Quests|Common Phrases
Gui, Add, Picture, w225 h-1, %bannerImage%
Gui, Font, s16, Segoe UI
Gui, Add, Text,, How to use?
Gui, Font, s12, Segoe UI
Gui, Add, Text, y+1, -> Open a fresh chat box in game and switch to the desired chat category
Gui, Font, s12 Italic, Segoe UI
message := "    (do not open the chat box through the frequent phrases menu or DQX will crash)"
Gui, Add, Text, y+1, %message%
Gui, Font, s12 Norm, Segoe UI
Gui, Add, Text, y+1, -> Bring this program into focus and paste the Japanese text you want to send
message := "-> Click 'Send to DQX'. The program will move your DQX chat cursor to the`n     appropriate position and send the text into the DQX chat window"
Gui, Add, Text, y+1, %message%
Gui, Font, s12 Norm, Segoe UI
Gui, Add, Edit, r1 vTextToSend w600 x21 y278, %textToSend%
Gui, Add, Button, gSend, Send to DQX
Gui, Add, Button, gCloseApp x+392, Exit Program

; Quests tab
Gui, Tab, Quests
Gui, Add, Text,, Select the relevant quest to enter text into the chat.
QuestDDL :=
For index, value in questDict
  QuestDDL := QuestDDL . "|" . index
QuestDDL := SubStr(QuestDDL, 2)
Gui, Add, DropDownList, vQuestSelect w600 gUpdateQuestPreview, %QuestDDL%
Gui, Add, Text, x21 y255, Text that will be sent:
Gui, Add, Edit, vQuestPreview w600 x21 y278 ReadOnly -WantReturn,
Gui, Add, Button, gQuestSend, Send to DQX
Gui, Add, Button, gCloseApp x+392, Exit Program


; Common Phrases tab
Gui, Tab, Common Phrases
Gui, Add, Text,, Press a button to enter a common phrase into the chat.

; Button layout settings
guiWidth := 600
btnWidth := guiWidth // 3 - 15  ; subtract spacing
btnHeight := 30
marginX := 40
marginY := 70
spacingX := 5
spacingY := 5

index := 0
For phrase, translation in commonPhrasesDict {
    row := index // 3
    col := Mod(index, 3)
    x := marginX + (btnWidth + spacingX) * col
    y := marginY + (btnHeight + spacingY) * row

    Gui, Add, Button, x%x% y%y% w%btnWidth% h%btnHeight% gPhraseFocus, %phrase%
    index++
}

Gui, Add, Text, x21 y255, Text that will be sent:
Gui, Add, Edit, vPhrasePreview w600 x21 y278 ReadOnly -WantReturn,  ; This will show the phrase text preview
Gui, Add, Button, gPhraseSend, Send to DQX
Gui, Add, Button, gCloseApp x+392, Exit Program

Gui, Show, Autosize, Send to Chat (%scriptVer%)
Return


CloseApp:
  if (A_IsCompiled)
    FileDelete, %bannerImage%
  ExitApp


GuiClose:
  if (A_IsCompiled)
    FileDelete, %bannerImage%
  ExitApp


Send:
  GuiControlGet, TextToSend

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(TextToSend)
  else
    MsgBox, 4112,, DQX window not found. Is it open?  ; 4112 = 4096 + 16 (always on top + error)
  Return


UpdateQuestPreview:
  GuiControlGet, QuestSelect,, QuestSelect
  questText := questDict[QuestSelect]
  GuiControl,, QuestPreview, %questText%
Return


QuestSend:
  GuiControlGet, QuestSelect
  questText := questDict[QuestSelect]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(questText)
  else
    MsgBox, 4112,, DQX window not found. Is it open?
  Return


PhraseFocus:
  GuiControlGet, getPhrase,, % A_GuiControl
  phraseText := commonPhrasesDict[getPhrase]

  GuiControl,, PhrasePreview, %phraseText%
Return


PhraseSend:
  GuiControlGet, PhrasePreview,, PhrasePreview
  phraseText := commonPhrasesDict[getPhrase]

  Process, Exist, DQXGame.exe
  if ErrorLevel
    WriteToDQX(phraseText)
  else
    MsgBox, 4112,, DQX window not found. Is it open?
  Return


WriteToDQX(textToSend) {
  ; Check that DQX is running before attempting to write anything.
  Process, Exist, DQXGame.exe
  pid := ErrorLevel
  if (pid = 0) {
    MsgBox, 4112,, Could not get DQXGame.exe process id.
    ExitApp
  }

  ; If DQX is elevated, make sure this program is too.
  is_elevated := IsProcessElevated(pid)
  if (is_elevated != 0) {
    if (A_IsAdmin = 0) {
      MsgBox, 4112,, DQX is running as admin, but this program is not. Re-launch Send to Chat as an administrator and try again.
      ExitApp
    }
  }

  ; Instantiate a new memory object each run. Users tend to forget to relaunch the program after restarting DQX.
  dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
  baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")

  Loop, Parse, textToSend
  {
    ; Instead of naturally sending text to the client, we read the requested text, convert it into utf-8 bytes
    ; and write it directly into the game's chat buffer.
    ;
    ; To imitate typing into the buffer, we need to trick the game into thinking we typed into it. We do this by
    ; arrowing over the number of bytes a character would have been (3), then inserting the character into the buffer.
    WinActivate, ahk_exe DQXGame.exe
    Send {Right}
    Sleep 25
    Send {Right}
    Sleep 25
    Send {Right}
    Sleep 25

    ; For phrases that use all 20 available JP characters in the chatbox,
    ; we need to arrow over to the left once, and then back to the right to
    ; get it to properly send.
    if (A_Index = 20) {
      Send {Left}
      Sleep 25
      Send {Right}
    }
  }

  startAddress := dqx.getAddressFromOffsets(baseAddress + chatAddress, chatOffsets*)
  dqx.writeBytes(startAddress, convertStrToHex(textToSend))

}
