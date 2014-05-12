<#

.DESCRIPTION


.NOTES
	Author: Peter Selch Dahl - Installers A/S
	        Customized by Masaki Takeda
	Last Updated: 5/11/2014  
#>

workflow New-AzureVMs
{   
    param()

        $MyConnection = "decode-demo"
        $MyCert = "decode-demo"

    # Get the Azure Automation Connection
    $Con = Get-AutomationConnection -Name $MyConnection
    if ($Con -eq $null)
    {
        Write-Output "Connection entered: $MyConnection does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $SubscriptionID = $Con.SubscriptionID
        $ManagementCertificate = $Con.AutomationCertificateName
       
    }   

    # Get Certificate & print out its properties
    $Cert = Get-AutomationCertificate -Name $MyCert
    if ($Cert -eq $null)
    {
        Write-Output "Certificate entered: $MyCert does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $Thumbprint = $Cert.Thumbprint
    }

        #Set and Select the Azure Subscription
         Set-AzureSubscription `
            -SubscriptionName "Windows Azure Internal Consumption" `
            -Certificate $Cert `
            -SubscriptionId $SubscriptionID `
            -CurrentStorageAccountName "eastjapan"

        #Select Azure Subscription
         Select-AzureSubscription `
            -SubscriptionName "Windows Azure Internal Consumption"


    Write-Output "-------------------------------------------------------------------------"

    Write-Output "仮想マシンを作成します.."

    $image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201404.01-en.us-127GB.vhd"
    $username = "azuredaisuki"
    $password = "P@ssw0rd/1"
    
    $ServiceName1 = "automation-530"
    $vmName1 = "automation-530"

    $ServicceName2 = "puppet-demo530"
    $vmName2 = "puppet-530"

    if(!(Get-AzureVM -Name $vmName1 -ServiceName $ServiceName1 -ErrorAction SilentlyContinue)) {
        New-AzureQuickVM -AdminUsername $username -ImageName $image -Password $password `
            -ServiceName $ServiceName1 -Windows -InstanceSize small -Name $vmName1 `
            -AffinityGroup "japan-east-ag" -WaitForBoot 
        
        Write-Output "仮想マシン $vmName1 を作成しました。"    
    } else {
        Write-Output "仮想マシン $vmName1 は作成済みです。"     
    }

    #$vm2 = New-AzureVMConfig -Name $vmName2 -InstanceSize Small -ImageName $image
    #Add-AzureProvisioningConfig -VM $vm2 -Windows -AdminUsername $username -Password $password
    #New-AzureVM -ServiceName $ServiceName2 -VMs $vm2 -AffinityGroup "japan-east-ag" 

    Write-Output "-------------------------------------------------------------------------"
}
