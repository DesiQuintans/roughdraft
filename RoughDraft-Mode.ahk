; RoughDraft-Mode
; Author     Desi Quintans
; Website    https://github.com/DesiQuintans/roughdraft
;
; This script removes your ability to delete, replace, or insert text. Since
; you cannot edit what you've already written, you are forced to focus on
; writing new things instead.

#NoEnv
#SingleInstance force
#UseHook
SendMode Input
SetWorkingDir %A_ScriptDir%

;============================== Global variables ==============================

; When was Backspace last pressed?
last_edit := 0

Menu, Tray, Tip, Ctrl + Insert toggles RoughDraft-Mode


;================================ Program logic ===============================

; I want to force the user to always insert new text at the end of the line
; i.e. prevent them from inserting text in an existing block. I do this by
; defining hotkeys for all letters, numbers, and punctuation marks.
;
; https://en.wikipedia.org/wiki/List_of_Unicode_characters#Basic_Latin
; 32-126 are ASCII punctuation, numbers, and lowercase/uppercase letters.

build_hotkeys(33,  47)             ; Punctuation marks
build_hotkeys(58,  64)             ; Punctuation marks
build_hotkeys(91,  96)             ; Punctuation marks
build_hotkeys(123, 126)            ; Punctuation marks
build_hotkeys(48,  57)             ; Numbers 0-9
build_hotkeys(48,  57,  "Numpad")  ; Numpad numbers 0-9
build_hotkeys(97,  122)            ; Lowercase letters
build_hotkeys(97,  122, "+")       ; Uppercase letters (AHK wants + modifier)

TypeAtEnd:
    ; If {End} is sent between every keystroke, then the intelligent Undo of
    ; some programs is defeated and Undo happens for every letter instead of
    ; for every block of letters that was typed consecutively. Therefore, avoid
    ; sending {End} unless the user has not been typing for some time. There is
    ; also a check for -1 because the script initialises with this setting.
    If (A_TimeSincePriorHotkey > 1000 OR A_TimeSincePriorHotkey == -1) {
        SendInput {End}
    }

    send_keystroke(A_ThisHotkey)
    Return


*Backspace::
*Delete::
*NumpadDel::
*Insert::
*NumpadIns::
    Return


Backspace::
^Backspace::
^z::
    ; Allow one edit every 1 second, which should be enough to deal with typos.
    if (A_TickCount - last_edit >= 750) {
        SendInput {End}
        send_keystroke(A_ThisHotkey)

        last_edit := A_TickCount
    }
    Return

^Insert::Suspend

;============================ Supporting functions ============================

; Generate a series of integers between two values (inclusive).
seq(from, to) {
    iterations := (to - from) + 1
    array := []

    Loop, %iterations% {
        array[A_Index] := A_Index + (from - 1)
    }

    Return array
}


; Builds hotkeys for keys that fall between two unicode points (inclusive).
; autohotkey.com/board/topic/67948-detect-any-letter-key-press/#entry430046
build_hotkeys(from, to, modifier = "", lab = "TypeAtEnd") {
    keys := seq(from, to)

    Loop % keys.MaxIndex() {
        key_name := modifier . Chr(keys[A_Index])

        Hotkey, %key_name%, %lab%
    }
}


; Keys with modifiers and keys that are bare need to be sent in different ways.
; Doing `Send {^Backspace}` actually performs `Ctrl+B` and then `ackspace`, so
; it needs to be done as `Send ^{Backspace} to have the desired effect.
send_keystroke(keyname) {
    ; Note that this will only get `^` from `^+w`, so be warned.
    modifier := SubStr(keyname, 1, 1)

    if (StrLen(keyname) > 1 AND (modifier == "+" OR modifier == "^")) {
        SendInput % modifier . "{" . SubStr(keyname, 2) . "}"
    } else {
        SendInput {%keyname%}
    }
}
