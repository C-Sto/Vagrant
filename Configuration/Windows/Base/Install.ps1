# Install new user
param (
  [string]$password = "",
  [string]$username = ""
)
if ($username -eq "") { $username = Read-Host "Username"}
if ($password -eq "") { $sPassword = Read-Host "Password" -AsSecureString }else{$sPassword = $password|convertto-securestring -asplaintext -force}



New-LocalUser $username -Password $sPassword
net user administrator /active:no
#add to local admins
Add-LocalGroupMember -group "Administrators" -Member $username

# Install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install stuff
choco feature enable -n allowGlobalConfirmation
choco feature disable -n showdownloadprogress
choco upgrade git -r
choco upgrade golang -r
choco upgrade vscode -r 
choco upgrade 7zip -r

# kick off configuration script
.\config.ps1

# remove vagrant user
remove-localuser -Name "vagrant"

# do this last to prevent silly lols