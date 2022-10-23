;; https://www.autohotkey.com/boards/viewtopic.php?t=68782

convertStrToHex(string)
{
    VarSetCapacity(bin, StrPut(string, "UTF-8")) && len := StrPut(string, &bin, "UTF-8") - 1 
    if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x4, "ptr", 0, "uint*", size))
        throw Exception("CryptBinaryToString failed", -1)
    VarSetCapacity(buf, size << 1, 0)
    if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x4, "ptr", &buf, "uint*", size))
        throw Exception("CryptBinaryToString failed", -1)
    return StrReplace(StrGet(&buf), " ", "")
}