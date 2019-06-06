$passwordsec = convertto-securestring "Passw0rd!" -asplaintext -force
Install-WindowsFeature -Name AD-Domain-Services -includemanagementtools
Install-ADDSForest -domainname "ad.contoso.com" -InstallDns -Force -Confirm:$false -SafeModeAdministratorPassword $passwordsec

# Enable reversible encryption
#set-adaccountcontrol -AllowReversiblepasswordEncryption:$true

# dump .dit to a file we can get at
#ntdsutil.exe "activate instance ntds" ifm "create full C:\vagrant\ntds2" quit