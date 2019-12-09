"C:\Dropbox\Autohotkey\Ahk2Exe\Ahk2Exe.exe" /in "RoughDraft-Mode.ahk" /icon "icons\r_blue.ico"

@TIMEOUT 5


@REM Main program icon.
"C:\Dropbox\Apps\ResHacker\ResourceHacker.exe" -open RoughDraft-Mode.exe -save RoughDraft-Mode.exe -action addoverwrite -resource "icons\r_blue.ico" -mask ICONGROUP,159,
@TIMEOUT 1


@REM 'Suspend' icon.
"C:\Dropbox\Apps\ResHacker\ResourceHacker.exe" -open RoughDraft-Mode.exe -save RoughDraft-Mode.exe -action addoverwrite -resource "icons\r_grey.ico" -mask ICONGROUP,206,
@TIMEOUT 1


@PAUSE
