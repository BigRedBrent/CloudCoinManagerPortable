If WScript.Arguments.Count = 0 Then
    WScript.Quit
End If

Dim WshShell
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & WScript.Arguments(0) & chr(34) & " -home " & chr(34) & WScript.Arguments(1) & chr(34), 1, True
WshShell.Run "finish.cmd 1"
