; The name of the installer
Name "Rediscover Installer"

; The file to write
OutFile "Rediscover-0.0.2.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Rediscover

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Rediscover" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "Rediscover (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "rediscover.exe"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\Rediscover "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rediscover" "DisplayName" "Rediscover"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rediscover" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rediscover" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rediscover" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Rediscover"
  CreateShortCut "$SMPROGRAMS\Rediscover\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Rediscover\Rediscover.lnk" "$INSTDIR\rediscover.exe" "" "$INSTDIR\rediscover.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rediscover"
  DeleteRegKey HKLM SOFTWARE\NSIS_Example2

  ; Remove files and uninstaller
  Delete $INSTDIR\rediscover.exe
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Rediscover\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Rediscover"
  RMDir "$INSTDIR"

SectionEnd
