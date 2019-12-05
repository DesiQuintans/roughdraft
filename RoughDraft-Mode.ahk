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

*Backspace::
*Delete::
*NumpadDel::
*Insert::
*NumpadIns::
^z::
^+z::
^y::
    Return

TypeAtEnd:
    ; If {End} is sent between every keystroke, then the intelligent Undo of
    ; some programs is defeated and Undo happens for every letter instead of
    ; for every block of letters that was typed consecutively. Therefore, avoid
    ; sending {End} unless the user has not been typing for some time. There is
    ; also a check for -1 because the script initialises with this setting.
        Send {End}
    If (A_TimeSincePriorHotkey > 1000 OR A_TimeSincePriorHotkey == -1) {
    }

    Send {%A_ThisHotkey%}
    Return



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

; Builds hotkeys for sdakeys that fall between two unicode points (inclusive).
; https://autohotkey.com/board/topic/67948-detect-any-letter-key-press/#entry430046
build_hotkeys(from, to, modifier = "", lab = "TypeAtEnd") {
    keys := seq(from, to)

    Loop % keys.MaxIndex() {
        key_name := modifier . Chr(keys[A_Index])

        Hotkey, %key_name%, %lab%
    }
}
