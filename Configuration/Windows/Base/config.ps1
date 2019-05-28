Function configurate {

echo "########################"
echo "########################"
echo "#####configurating######"
echo "########################"
echo "########################"

# taken from the fireye commando vm
powershell.exe -noprofile -executionpolicy bypass -file "Win10.ps1" -include "Win10.psm1" -preset "cam.preset"

#dpi
Write-Host 'Change to 150% / 144 dpi'
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name LogPixels -Value 144
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Win8DpiScaling 1

# Bye pesky explorer
$shortcut_path = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
Remove-Item $shortcut_path -Force | Out-Null

# enable good logging for powershell
# Should be PS >5.1 now, enable transcription and script block logging
# More info: https://www.fireeye.com/blog/threat-research/2016/02/greater_visibilityt.html
if ($PSVersionTable -And $PSVersionTable.PSVersion.Major -ge 5) {
  $psLoggingPath = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell'
  if (-Not (Test-Path $psLoggingPath)) {
    New-Item -Path $psLoggingPath -Force | Out-Null
  }
  $psLoggingPath = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\Transcription'
  if (-Not (Test-Path $psLoggingPath)) {
    New-Item -Path $psLoggingPath -Force | Out-Null
  }
  New-ItemProperty -Path $psLoggingPath -Name "EnableInvocationHeader" -Value 1 -PropertyType DWORD -Force | Out-Null
  New-ItemProperty -Path $psLoggingPath -Name "EnableTranscripting" -Value 1 -PropertyType DWORD -Force | Out-Null
  New-ItemProperty -Path $psLoggingPath -Name "OutputDirectory" -Value (Join-Path ${Env:UserProfile} "Desktop\PS_Transcripts") -PropertyType String -Force | Out-Null
  
  $psLoggingPath = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
  if (-Not (Test-Path $psLoggingPath)) {
    New-Item -Path $psLoggingPath -Force | Out-Null
  }
  New-ItemProperty -Path $psLoggingPath -Name "EnableScriptBlockLogging" -Value 1 -PropertyType DWORD -Force | Out-Null
}

}
#