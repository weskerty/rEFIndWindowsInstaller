!include x64.nsh

OutFile "rEFInd.exe"
Icon "F:\Documentos\LinuxMint\ICO\rEFInd.ico"
RequestExecutionLevel highest
InstallDir "C:\rEFInd"
Name "rEFInd"

Function .onInit
    Call Is64Bit
    Pop $0
    StrCmp $0 0 Not64Bit
    Return

    Not64Bit:
    MessageBox MB_OK "Solo-Only PC 64bits."
    Quit
FunctionEnd

Function Is64Bit
    ${If} ${RunningX64}
        StrCpy $0 1
    ${Else}
        StrCpy $0 0
    ${EndIf}
FunctionEnd

Section "MainSection" SEC01
    CreateDirectory "$INSTDIR"
    SetOutPath "$INSTDIR"
    File /r "F:\Documentos\LinuxMint\rEFInd\*.*"
    ExecWait '"$WINDIR\SysNative\cmd.exe" /c "$INSTDIR\rEFInd64.bat"'
    ExecShell "open" "$INSTDIR"
    
    Quit
SectionEnd
