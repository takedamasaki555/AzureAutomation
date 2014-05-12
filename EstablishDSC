$ServiceName1 = "automation-530"
$vmName1      = "automation-530"
$tmpfile      = "d:\CloudService.tmp"

$WinRMCertificateThumbprint = (Get-AzureVM -ServiceName $Servicename1 -Name $vmname1 `
| Select-Object -ExpandProperty VM).DefaultWinRMCertificateThumbprint
(Get-AzureCertificate -ServiceName $Servicename1 -Thumbprint $WinRMCertificateThumbprint -ThumbprintAlgorithm SHA1).Data `
| Out-File $tmpfile
 
$X509Object = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $tmpfile
$X509Store = New-Object System.Security.Cryptography.X509Certificates.X509Store "Root", "LocalMachine"
$X509Store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$X509Store.Add($X509Object)
$X509Store.Close()
 
Remove-Item $tmpfile

$cimSessionOption = New-CimSessionOption -UseSsl
$cimSession = New-CimSession -SessionOption $cimSessionOption -ComputerName "$ServiceName1.CloudApp.net" `
  -Port 5986 -Authentication Negotiate -Credential (Get-Credential)
