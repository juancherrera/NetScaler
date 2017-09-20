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

function Add-NSVLAN {
    <#
    .SYNOPSIS
        Add an untagged/unbound VLAN to NetScaler appliance.

    .DESCRIPTION
        Add an untagged/unbound VLAN to NetScaler appliance.

    .EXAMPLE
        Add-NSVLAN -VLANID 150 -AliasName 'testvlan' -MTU 1500

        Adds VLAN 150 with an alias name of 'testvlan' with a MTU of 1500 to the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VLANID
        A positive integer that uniquely identifies a VLAN.

    .PARAMETER AliasName
        A name for the VLAN. Must begin with a letter, a number, or the underscore symbol, and can consist of from 1 to 31 letters, numbers, and the hyphen (-), period (.) pound (#), space ( ), at sign (@), equals (=), colon (:), and underscore (_) characters.

    .PARAMETER IPV6DynamicRouting
        Enable all IPv6 dynamic routing protocols on this VLAN. Note: For the ENABLED setting to work, you must configure IPv6 dynamic routing protocols from the VTYSH command line. Possible values = ENABLED, DISABLED

    .PARAMETER MTU
        Specifies the maximum transmission unit (MTU), in bytes.

    .PARAMETER Force
        Suppress confirmation when adding a DNS suffix.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [int[]]$VLANID,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$AliasName,

        [parameter()]
        [ValidateSet('ENABLED', 'DISABLED')]
        [string[]]$IPV6DynamicRouting = 'DISABLED',

        [parameter()]
        [int]$MTU = 1500,

        [Switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $VLANID) {
            if ($PSCmdlet.ShouldProcess($item, 'Add VLAN suffix')) {
                try {
                    $params = @{
                         id = $item
                         aliasname = $AliasName
                         ipv6dynamicrouting = $IPV6DynamicRouting
                         mtu = $MTU

                    }
                    $response = _InvokeNSRestApi -Session $Session -Method POST -Type vlan -Payload $params -Action add
                }
                catch {
                    throw $_
                }
            }
        }
    }
}