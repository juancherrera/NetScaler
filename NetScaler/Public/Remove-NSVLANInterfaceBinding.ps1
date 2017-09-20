<#
Copyright 2017 Juan C. Herrera

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function Remove-NSVLANInterfaceBinding {
    <#
    .SYNOPSIS
        Removes the binding of an interface as well as untagged/unbound from NetScaler appliance.

    .DESCRIPTION
        Removes the binding of an interface as well as untagged/unbound from NetScaler appliance.

    .EXAMPLE
        Remove-NSVLANInterfaceBinding -VLANID 150 -interface '0/1' -tagged

        Adds binding for interface '0/1' and tags the vlan on the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VLANID
        A positive integer that uniquely identifies a VLAN.

    .PARAMETER Interface
        The interface to be bound to the VLAN, specified in slot/port notation (for example, 1/3).

    .PARAMETER Tagged
        Make the interface an 802.1q tagged interface.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$VLANID,

        [parameter()]
        [string[]]$Interface = '0/1',

        [Switch]$Force

    )

    begin {
        _AssertSessionActive
    }

    process {

        $params = @{
            id = $VLANID
            ifnum = $Interface
        }

        foreach ($item in $VLANID) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Remove VLAN interaface binding')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type vlan_interface_binding -Resource $item -Arguments $params -Action delete
                }
                catch {
                    throw $_
                }
            }
        }
    }
}
