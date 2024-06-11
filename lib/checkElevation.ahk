;; https://github.com/jNizM/AHK_Scripts/blob/master/src/process_thread_handle_module/IsProcessElevated.ahk

IsProcessElevated(ProcessID)
{
    if !(hProcess := DllCall("OpenProcess", "uint", 0x0400, "int", 0, "uint", ProcessID, "ptr"))
        return 2
    if !(DllCall("advapi32\OpenProcessToken", "ptr", hProcess, "uint", 0x0008, "ptr*", hToken))
        return 2
    if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 20, "uint*", IsElevated, "uint", 4, "uint*", size))
        return 2
    return IsElevated, DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
}

; 0 => Process is not elevated
; 1 => Process is elevated
; 2 => Error reading process
