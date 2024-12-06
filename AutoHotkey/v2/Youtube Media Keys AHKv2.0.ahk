#Requires AutoHotkey v2.0
;	*** environment configuration ***
Persistent
#SingleInstance Force
;	SetWorkingDir, %A_ScriptDir%
;	DetectHiddenWindows, On
;	SetTitleMatchMode, 2
;	SetBatchLines -1
;	#NoTrayIcon
;	#Warn All, OutputDebug

;	*** Youtube - Google Chrome *** custom 'Media Keys'
;	REF: https://www.reddit.com/r/AutoHotkey/comments/198mq5k/comment/ki8dhoo/

TraySetIcon "C:\_PENsTools_\AutoHotkey_\AHK-Shorties\_icons_\Music Icon - Sixteenth Note v1.0.ico", 1

#HotIf WinExist('YouTube - Google Chrome')
$^Media_Play_Pause:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("k")
    WinActivate(last)
}
$^!Up:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("{Up}")
;    Send("{Volume_Up}")
    WinActivate(last)
}#HotIf
$^!Down:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("{Down}")
;    Send("{Volume_Down}")
    WinActivate(last)
}#HotIf
$^!Left:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("{Left}")
;    Send("{Media_Prev}")
    WinActivate(last)
}#HotIf
$^!Right:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("{Right}")
;    Send("{Media_Next}")
    WinActivate(last)
}#HotIf
$^!RShift:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("{Media_Play_Pause}")
    WinActivate(last)
}#HotIf
$^!LShift:: {
    youtube := 'YouTube - Google Chrome ahk_exe chrome.exe'
    last := WinActive('A')
    WinActivate(youtube)
    WinWaitActive(youtube)
    Send("m")
    WinActivate(last)
}#HotIf

^Escape::ExitApp
!Escape::Reload
