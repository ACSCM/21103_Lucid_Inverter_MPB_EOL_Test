param([switch]$Elevated)
function Check-Admin {
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Check-Admin) -eq $false) {
if ($elevated)
{
# could not elevate, quit
}
else {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}

$networks=@(
	("VLAN_43_VCU_RFEGW", "02-00-00-04-05-00", "192.168.43.4", 43),
   	#@("VLAN_43_TCU", "02-00-00-01-08-00", "192.168.43.8", 43),
    #@("VLAN_43_MPB", "02-00-00-04-03-00", "192.168.43.9", 43),
    @("VLAN_43_BMU", "02-00-00-04-04-00", "192.168.43.5", 43),
    #@("VLAN_43_BCM", "02-00-00-03-05-00", "192.168.43.3", 43),
	#@("VLAN_67_VCU_RFEGW", "02-00-00-04-05-00", "192.168.67.4", 67),
   	#@("VLAN_67_TCU", "02-00-00-01-08-00", "192.168.67.8", 67),
   	#@("VLAN_67_RREGW", "02-00-00-01-05-00", "192.168.67.1", 67),	
    #@("VLAN_67_MPB", "02-00-00-04-03-00", "192.168.67.9", 67),
    #@("VLAN_67_BMU", "02-00-00-04-04-00", "192.168.67.5", 67),
    #@("VLAN_67_BCM", "02-00-00-03-05-00", "192.168.67.3", 67),	
    #@("VLAN_67_LREGW", "02-00-00-02-05-00", "192.168.67.2", 67),	
    #@("VLAN_67_ICC", "02-00-00-03-02-00", "192.168.67.11", 67),	
    #@("VLAN_67_CCC", "02-00-00-02-06-00", "192.168.67.12", 67),	
	#@("VLAN_66_VCU_RFEGW", "02-00-00-04-05-00", "192.168.66.4", 66),	
   	#@("VLAN_66_TCU", "02-00-00-01-08-00", "192.168.66.8", 66),
   	#@("VLAN_66_MCU_R", "02-00-00-02-02-00", "192.168.66.6", 66),
   	#@("VLAN_66_MCU_F", "02-00-00-04-01-00", "192.168.66.7", 66),
    #@("VLAN_66_ICC", "02-00-00-03-02-00", "192.168.66.11", 66),		
    #@("VLAN_66_CCC", "02-00-00-02-06-00", "192.168.66.12", 66),	
    #@("VLAN_66_BMU", "02-00-00-04-04-00", "192.168.66.5", 66),
	@("VLAN_41_VCU_RFEGW", "02-00-00-04-05-00", "192.168.41.4", 41),
   	@("VLAN_41_TCU", "02-00-00-01-08-00", "192.168.41.8", 41)
   	#@("VLAN_41_RREGW", "02-00-00-01-05-00", "192.168.41.1", 41),
    #@("VLAN_41_MPB", "02-00-00-04-03-00", "192.168.41.9", 41),
   	#@("VLAN_41_MCU_R", "02-00-00-02-02-00", "192.168.41.6", 41),
   	#@("VLAN_41_MCU_F", "02-00-00-04-01-00", "192.168.41.7", 41),	
    #@("VLAN_41_LREGW", "02-00-00-02-05-00", "192.168.41.2", 41),
    #@("VLAN_41_BMU", "02-00-00-04-04-00", "192.168.41.5", 41),		
    #@("VLAN_41_BCM", "02-00-00-03-05-00", "192.168.41.3", 41),
    #@("VLAN42_VCU_RFEGW", "02-00-00-04-05-00", "192.168.42.4", 42),
    #@("VLAN42_TCU", "02-00-00-01-08-00", "192.168.42.8", 42),
    #@("VLAN42_MCU_R", "02-00-00-02-02-00", "192.168.42.6", 42),
    #@("VLAN42_MCU_LR", "02-00-00-02-03-00", "192.168.42.29", 42),
    #@("VLAN42_MCU_F", "02-00-00-04-01-00", "192.168.42.7", 42),
    #@("VLAN42_LREGW", "02-00-00-02-05-00", "192.168.42.2", 42)
)
ForEach ($network In $networks)
{
    Add-VMNetworkAdapter -ManagementOS -Name $network[0] -SwitchName "MySwitch" -StaticMacAddress $network[1]
    Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName $network[0] -Access -VlanID $network[3]
    $name="vEthernet ("+$network[0]+")"
    netsh interface ip set address name="$name" static $network[2] 255.255.255.0
}
