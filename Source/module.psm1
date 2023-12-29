$Script:Error_Strings = @{
    ErrorOpeningHandle = 'Error opening WiFi handle. Message {0}'
    HandleClosed = 'Handle successfully closed.'
    ErrorClosingHandle = 'Error closing handle. Message {0}'
    ErrorGettingProfile = 'Error getting profile info. Error code: {0}'
    ProfileNotFound = 'Profile {0} not found. Note ProfileName is case sensitive.'
    ErrorDeletingProfile = 'Error deleting profile. Message {0}'
    ShouldProcessDelete = 'Deletion of profile {0}'
    ErrorWlanConnect = 'Error connecting to {0} : {1}'
    SuccessWlanConnect = 'Successfully connected to {0} : {1}'
    ErrorReasonCode = 'Failed to format reason code. Error message: {0}'
    ErrorFreeMemory = 'Failed to free memory. Error message: {0}'
    ErrorGetAvailableNetworkList = 'Error invoking WlanGetAvailableNetworkList. Message {0}'
    ErrorGetNetworkBssList = 'Error invoking WlanGetAvailableNetworkList. Message {0}'
    ErrorWiFiInterfaceNotFound = 'Wi-Fi interface not found on the system.'
    ErrorNotWiFiAdapter = 'Adapter with name: {0} is not a WiFi capable.'
    ErrorNoWiFiAdaptersFound = 'No wifi interfaces found.'
    ErrorMoreThanOneInterface = 'More than one Wi-Fi interface found. Please specify a specific interface.'
    ErrorNeedSingleAdapterName = 'More than one Wi-Fi adapter found. Please specify a single adapter name.'
    ErrorFailedWithExitCode = 'Failed with exit code {0}.'
}

function Connect-WiFiProfile {
    [OutputType([void])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ProfileName,

        [Parameter()]
        [ValidateSet('Profile', 'TemporaryProfile', 'DiscoverySecure', 'DiscoveryUnsecure', 'Auto')]
        [System.String]
        $ConnectionMode = 'Profile',

        [Parameter()]
        [ValidateSet('Any', 'Independent', 'Infrastructure')]
        [System.String]
        $Dot11BssType = 'Any',

        [Parameter()]
        [System.String]
        $WiFiAdapterName
    )

    begin {
        $interfaceInfo = Get-InterfaceInfo -WiFiAdapterName $WiFiAdapterName

        if ($interfaceInfo.Count -gt 1) {
            throw $Script:Error_Strings.ErrorMoreThanOneInterface
        }
    }
    process {
        try {
            $clientHandle = New-WiFiHandle
            $connectionParameterList = New-WiFiConnectionParameter -ProfileName $ProfileName -ConnectionMode $ConnectionMode -Dot11BssType $Dot11BssType
            Invoke-WlanConnect -ClientHandle $clientHandle -InterfaceGuid $interfaceInfo.InterfaceGuid -ConnectionParameterList $connectionParameterList
        }
        catch {
        }
        finally {
            if ($clientHandle) {
                Remove-WiFiHandle -ClientHandle $clientHandle
            }
        }
    }
}

function Get-WiFiAvailableNetwork {
    [CmdletBinding()]
    [OutputType([WiFi.ProfileManagement+WLAN_AVAILABLE_NETWORK])]
    param
    (
        [Parameter()]
        [System.String]
        $WiFiAdapterName,

        [Parameter()]
        [switch]
        $InvokeScan
    )

    try {
        if ($InvokeScan.IsPresent) {
            Search-WiFiNetwork -WiFiAdapterName $WiFiAdapterName
            Start-Sleep -Seconds 4
        }

        $interfaceInfo = Get-InterfaceInfo -WiFiAdapterName $WiFiAdapterName

        $flag = 0
        $networkList = @()
        $pointerCollection = @()
        $clientHandle = New-WiFiHandle

        foreach ($interface in $interfaceInfo) {
            $networkPointer = 0
            $result = [WiFi.ProfileManagement]::WlanGetAvailableNetworkList(
                $clientHandle,
                $interface.InterfaceGuid,
                $flag,
                [IntPtr]::zero,
                [ref] $networkPointer
            )

            if ($result -ne 0) {
                throw $($Script:Error_Strings.ErrorGetAvailableNetworkList -f $result)
            }

            $availableNetworks = [WiFi.ProfileManagement+WLAN_AVAILABLE_NETWORK_LIST]::new($networkPointer)
            $pointerCollection += $networkPointer

            foreach ($network in $availableNetworks.wlanAvailableNetwork) {
                $networkResult = [WiFi.ProfileManagement+WLAN_AVAILABLE_NETWORK] $network
                $networkList += Add-DefaultProperty -InputObject $networkResult -InterfaceInfo $interface
            }
        }

        $networkList
    }
    catch {
        $PSItem
    }
    finally {
        Invoke-WlanFreeMemory -Pointer $pointerCollection

        if ($clientHandle) {
            Remove-WiFiHandle -ClientHandle $clientHandle
        }
    }
}

function New-WiFiProfile {
    [CmdletBinding(DefaultParameterSetName = 'UsingArguments')]
    param
    (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'UsingArguments')]
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'UsingArgumentsWithEAP')]
        [Alias('SSID', 'Name')]
        [System.String]
        $ProfileName,

        [Parameter(ParameterSetName = 'UsingArguments')]
        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [ValidateSet('manual', 'auto')]
        [System.String]
        $ConnectionMode = 'auto',

        [Parameter(ParameterSetName = 'UsingArguments')]
        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [ValidateSet('open', 'shared', 'WPA', 'WPAPSK', 'WPA2', 'WPA2PSK', 'WPA3SAE', 'WPA3ENT192', 'OWE')]
        [System.String]
        $Authentication = 'WPA2PSK',

        [Parameter(ParameterSetName = 'UsingArguments')]
        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [ValidateSet('none', 'WEP', 'TKIP', 'AES', 'GCMP256')]
        [System.String]
        $Encryption = 'AES',

        [Parameter(ParameterSetName = 'UsingArguments')]
        [System.String]
        $Password,

        [Parameter(ParameterSetName = 'UsingArguments')]
        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [System.Boolean]
        $ConnectHiddenSSID = $false,

        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [ValidateSet('PEAP', 'TLS')]
        [System.String]
        $EAPType,

        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [AllowEmptyString()]
        [System.String]
        $ServerNames = '',

        [Parameter(ParameterSetName = 'UsingArgumentsWithEAP')]
        [System.String]
        $TrustedRootCA,

        [Parameter()]
        [System.String]
        $WiFiAdapterName,

        [Parameter(Mandatory = $true, ParameterSetName = 'UsingXml')]
        [System.String]
        $XmlProfile,

        [Parameter(DontShow = $true)]
        [System.Boolean]
        $Overwrite = $false
    )

    try {
        $interfaceInfo = Get-InterfaceInfo -WiFiAdapterName $WiFiAdapterName

        if ($interfaceInfo.Count -gt 1) {
            throw $Script:Error_Strings.ErrorNeedSingleAdapterName
        }

        $clientHandle = New-WiFiHandle
        $flags = 0
        $reasonCode = [IntPtr]::Zero

        if ($XmlProfile) {
            $profileXML = $XmlProfile
        }
        else {
            $newProfileParameters = @{
                ProfileName       = $ProfileName
                ConnectionMode    = $ConnectionMode
                Authentication    = $Authentication
                Encryption        = $Encryption
                Password          = $Password
                ConnectHiddenSSID = $ConnectHiddenSSID
                EAPType           = $EAPType
                ServerNames       = $ServerNames
                TrustedRootCA     = $TrustedRootCA
            }

            $profileXML = New-WiFiProfileXml @newProfileParameters
        }

        $profilePointer = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($profileXML)

        [WiFi.ProfileManagement]::WlanSetProfile(
            $clientHandle,
            [ref] $interfaceInfo.InterfaceGuid,
            $flags,
            $profilePointer,
            [IntPtr]::Zero,
            $Overwrite,
            [IntPtr]::Zero,
            [ref]$reasonCode
        )
    }
    catch {
        $PSItem
    }
    finally {
        if ($clientHandle) {
            Remove-WiFiHandle -ClientHandle $clientHandle
        }
    }
}

function Search-WiFiNetwork {
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $WiFiAdapterName
    )

    try {
        $interfaceInfo = Get-InterfaceInfo -WiFiAdapterName $WiFiAdapterName

        $clientHandle = New-WiFiHandle

        foreach ($interface in $interfaceInfo) {
            $resultCode = [WiFi.ProfileManagement]::WlanScan(
                $clientHandle,
                [ref] $interface.InterfaceGuid,
                [IntPtr]::zero,
                [IntPtr]::zero,
                [IntPtr]::zero
            )

            if ($resultCode -ne 0) {
                $resultCode
            }
        }
    }
    catch {
        $PSItem
    }
    finally {
        if ($clientHandle) {
            Remove-WiFiHandle -ClientHandle $clientHandle
        }
    }
}

function Add-DefaultProperty {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [object]
        $InputObject,

        [Parameter(Mandatory)]
        [object]
        $InterfaceInfo
    )

    Add-Member -InputObject $InputObject -MemberType 'NoteProperty' -Name 'WiFiAdapterName' -Value $InterfaceInfo.Name -Force
    Add-Member -InputObject $InputObject -MemberType 'NoteProperty' -Name 'InterfaceGuid' -Value $InterfaceInfo.InterfaceGuid -Force

    if ($InputObject -is [WiFi.ProfileManagement+WLAN_CONNECTION_ATTRIBUTES]) {
        $apMac = [System.BitConverter]::ToString($InputObject.wlanAssociationAttributes._dot11Bssid)
        Add-Member -InputObject $InputObject -MemberType 'NoteProperty' -Name 'APMacAddress' -Value $apMac -Force
    }

    return $InputObject
}

function Get-InterfaceInfo {
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $WiFiAdapterName
    )

    $result = @()
    $wifiAdapters = @()
    $getNetAdapterParams = @()

    $wifiInterfaces = Get-WiFiInterface

    if (!$WiFiAdapterName) {
        foreach ($wifiInterface in $wifiInterfaces) {
            $getNetAdapterParams += @(
                @{InterfaceDescription = $wifiInterface.Description }
            )
        }
    }
    else {
        $getNetAdapterParams = @(
            @{Name = $WiFiAdapterName }
        )
    }

    foreach ($getNetAdapterParam in $getNetAdapterParams) {
        $wifiAdapters = Get-NetAdapter @getNetAdapterParam
    }

    foreach ($wifiAdapter in $wifiAdapters) {
        if ($wifiAdapter.InterfaceGuid -notin $wifiInterfaces.Guid) {
            throw $($Script:Error_Strings.ErrorNotWiFiAdapter -f $wifiAdapter.Name)
        }
        else {
            $result += $wifiAdapter
        }
    }

    if ($result.Count -eq 0) {
        throw $Script:Error_Strings.ErrorNoWiFiAdaptersFound
    }
    return $result
}

function Get-WiFiInterface {
    [CmdletBinding()]
    [OutputType([WiFi.ProfileManagement+WLAN_INTERFACE_INFO])]
    param ()

    $interfaceListPtr = 0
    $clientHandle = New-WiFiHandle

    try {
        [void] [WiFi.ProfileManagement]::WlanEnumInterfaces($clientHandle, [IntPtr]::zero, [ref] $interfaceListPtr)
        $wiFiInterfaceList = [WiFi.ProfileManagement+WLAN_INTERFACE_INFO_LIST]::new($interfaceListPtr)

        foreach ($wlanInterfaceInfo in $wiFiInterfaceList.wlanInterfaceInfo) {
            [WiFi.ProfileManagement+WLAN_INTERFACE_INFO] $wlanInterfaceInfo
        }
    }
    catch {
    }
    finally {
        Remove-WiFiHandle -ClientHandle $clientHandle
    }
}

function Invoke-WlanConnect {
    [OutputType([void])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IntPtr]
        $ClientHandle,

        [Parameter(Mandatory = $true)]
        [System.Guid]
        $InterfaceGuid,

        [Parameter(Mandatory = $true)]
        [WiFi.ProfileManagement+WLAN_CONNECTION_PARAMETERS]
        $ConnectionParameterList
    )

    $result = [WiFi.ProfileManagement]::WlanConnect(
        $ClientHandle,
        [ref] $InterfaceGuid,
        [ref] $ConnectionParameterList,
        [IntPtr]::Zero
    )

    if ($result -ne 0) {
        throw $($Script:Error_Strings.ErrorWlanConnect -f $ConnectionParameterList.strProfile, $result)
    }
}

function Invoke-WlanFreeMemory {
    [OutputType([void])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IntPtr[]]
        $Pointer
    )

    foreach ($ptr in $Pointer) {
        if ($ptr -ne 0) {
            try {
                [WiFi.ProfileManagement]::WlanFreeMemory($ptr)
            }
            catch {
                throw $($Script:Error_Strings.ErrorFreeMemory -f $errorMessage)
            }
        }
    }
}

function New-WiFiConnectionParameter {
    [OutputType([WiFi.ProfileManagement+WLAN_CONNECTION_PARAMETERS])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ProfileName,

        [Parameter()]
        [ValidateSet('Profile', 'TemporaryProfile', 'DiscoverySecure', 'DiscoveryUnsecure', 'Auto')]
        [System.String]
        $ConnectionMode = 'Profile',

        [Parameter()]
        [ValidateSet('Any', 'Independent', 'Infrastructure')]
        [WiFi.ProfileManagement+DOT11_BSS_TYPE]
        $Dot11BssType = 'Any',

        [Parameter()]
        [WiFi.ProfileManagement+WlanConnectionFlag]
        $Flag = 'Default'
    )

    try {
        $connectionModeResolver = @{
            Profile           = 'wlan_connection_mode_profile'
            TemporaryProfile  = 'wlan_connection_mode_temporary_profile'
            DiscoverySecure   = 'wlan_connection_mode_discovery_secure'
            DiscoveryUnsecure = 'wlan_connection_mode_discovery_unsecure'
            Auto              = 'wlan_connection_mode_auto'
        }

        $connectionParameters = [WiFi.ProfileManagement+WLAN_CONNECTION_PARAMETERS]::new()
        $connectionParameters.strProfile = $ProfileName
        $connectionParameters.wlanConnectionMode = [WiFi.ProfileManagement+WLAN_CONNECTION_MODE]::$($connectionModeResolver[$ConnectionMode])
        $connectionParameters.dot11BssType = [WiFi.ProfileManagement+DOT11_BSS_TYPE]::$Dot11BssType
        $connectionParameters.dwFlags = [WiFi.ProfileManagement+WlanConnectionFlag]::$Flag
    }
    catch {
        throw $PSItem
    }

    return $connectionParameters
}

function New-WiFiHandle {    
    [CmdletBinding()]
    [OutputType([System.IntPtr])]
    param()

    $maxClient = 2
    [Ref]$negotiatedVersion = 0
    $clientHandle = [IntPtr]::zero

    $result = [WiFi.ProfileManagement]::WlanOpenHandle(
        $maxClient,
        [IntPtr]::Zero,
        $negotiatedVersion,
        [ref] $clientHandle
    )
    
    if ($result -eq 0) {
        return $clientHandle
    }
    else {
        throw $($Script:Error_Strings.ErrorOpeningHandle -f $result)
    }
}

$Script:WiFiProfileXmlPersonal = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
  <name>{0}</name>
  <SSIDConfig>
    <SSID>
      <name>{0}</name>
    </SSID>
    <nonBroadcast>{1}</nonBroadcast>
  </SSIDConfig>
  <connectionType>ESS</connectionType>
  <connectionMode>{2}</connectionMode>
  <MSM>
    <security>
      <authEncryption>
        <authentication>{3}</authentication>
        <encryption>{4}</encryption>
        <useOneX>false</useOneX>
      </authEncryption>
      <sharedKey>
        <keyType>passPhrase</keyType>
        <protected>false</protected>
        <keyMaterial>{5}</keyMaterial>
      </sharedKey>
    </security>
  </MSM>
</WLANProfile>
"@

$Script:WiFiProfileXmlEapPeap = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
  <name>{0}</name>
  <SSIDConfig>
    <SSID>
      <name>{0}</name>
    </SSID>
    <nonBroadcast>{1}</nonBroadcast>
  </SSIDConfig>
  <connectionType>ESS</connectionType>
  <connectionMode>{2}</connectionMode>
  <MSM>
    <security>
      <authEncryption>
        <authentication>{3}</authentication>
        <encryption>{4}</encryption>
        <useOneX>true</useOneX>
      </authEncryption>
      <PMKCacheMode>enabled</PMKCacheMode>
      <PMKCacheTTL>720</PMKCacheTTL>
      <PMKCacheSize>128</PMKCacheSize>
      <preAuthMode>disabled</preAuthMode>
      <OneX xmlns="http://www.microsoft.com/networking/OneX/v1">
        <authMode>machineOrUser</authMode>
        <EAPConfig>
          <EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig">
            <EapMethod>
              <Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type>
              <VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorId>
              <VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorType>
              <AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</AuthorId>
            </EapMethod>
            <Config xmlns="http://www.microsoft.com/provisioning/EapHostConfig">
              <Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1">
                <Type>25</Type>
                <EapType xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV1">
                  <ServerValidation>
                    <DisableUserPromptForServerValidation>false</DisableUserPromptForServerValidation>
                    <ServerNames></ServerNames>
                    <TrustedRootCA></TrustedRootCA>
                  </ServerValidation>
                  <FastReconnect>true</FastReconnect>
                  <InnerEapOptional>false</InnerEapOptional>
                  <Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1">
                    <Type>26</Type>
                    <EapType xmlns="http://www.microsoft.com/provisioning/MsChapV2ConnectionPropertiesV1">
                      <UseWinLogonCredentials>false</UseWinLogonCredentials>
                    </EapType>
                  </Eap>
                  <EnableQuarantineChecks>false</EnableQuarantineChecks>
                  <RequireCryptoBinding>false</RequireCryptoBinding>
                  <PeapExtensions>
                    <PerformServerValidation xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</PerformServerValidation>
                    <AcceptServerName xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</AcceptServerName>
                    <PeapExtensionsV2 xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">
                      <AllowPromptingWhenServerCANotFound xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV3">true</AllowPromptingWhenServerCANotFound>
                    </PeapExtensionsV2>
                  </PeapExtensions>
                </EapType>
              </Eap>
            </Config>
          </EapHostConfig>
        </EAPConfig>
      </OneX>
    </security>
  </MSM>
</WLANProfile>
"@

$Script:WiFiProfileXmlEapTls = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
  <name>{0}</name>
  <SSIDConfig>
    <SSID>
      <name>{0}</name>
    </SSID>
    <nonBroadcast>{1}</nonBroadcast>
  </SSIDConfig>
  <connectionType>ESS</connectionType>
  <connectionMode>{2}</connectionMode>
  <MSM>
    <security>
      <authEncryption>
        <authentication>{3}</authentication>
        <encryption>{4}</encryption>
        <useOneX>true</useOneX>
      </authEncryption>
      <PMKCacheMode>enabled</PMKCacheMode>
      <PMKCacheTTL>720</PMKCacheTTL>
      <PMKCacheSize>128</PMKCacheSize>
      <preAuthMode>disabled</preAuthMode>
      <OneX xmlns="http://www.microsoft.com/networking/OneX/v1">
        <authMode>machineOrUser</authMode>
        <EAPConfig>
          <EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig">
            <EapMethod>
              <Type xmlns="http://www.microsoft.com/provisioning/EapCommon">13</Type>
              <VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorId>
              <VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorType>
              <AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</AuthorId>
            </EapMethod>
            <Config xmlns:baseEap="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1" xmlns:eapTls="http://www.microsoft.com/provisioning/EapTlsConnectionPropertiesV1">
              <baseEap:Eap>
                <baseEap:Type>13</baseEap:Type>
                <eapTls:EapType>
                  <eapTls:CredentialsSource>
                    <eapTls:CertificateStore />
                  </eapTls:CredentialsSource>
                  <eapTls:ServerValidation>
                    <eapTls:DisableUserPromptForServerValidation>false</eapTls:DisableUserPromptForServerValidation>
                    <eapTls:ServerNames></eapTls:ServerNames>
                    <eapTls:TrustedRootCA></eapTls:TrustedRootCA>
                  </eapTls:ServerValidation>
                  <eapTls:DifferentUsername>false</eapTls:DifferentUsername>
                </eapTls:EapType>
              </baseEap:Eap>
            </Config>
          </EapHostConfig>
        </EAPConfig>
      </OneX>
    </security>
  </MSM>
</WLANProfile>
"@

function New-WiFiProfileXml {
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $ProfileName,

        [Parameter()]
        [ValidateSet('manual', 'auto')]
        [System.String]
        $ConnectionMode = 'auto',

        [Parameter()]
        [System.String]
        $Authentication = 'WPA2PSK',

        [Parameter()]
        [System.String]
        $Encryption = 'AES',

        [Parameter()]
        [System.String]
        $Password,

        [Parameter()]
        [System.Boolean]
        $ConnectHiddenSSID = $false,

        [Parameter()]
        [System.String]
        $EAPType,

        [Parameter()]
        [AllowEmptyString()]
        [System.String]
        $ServerNames = '',

        [Parameter()]
        [System.String]
        $TrustedRootCA
    )

    try {
        if ($EAPType -eq 'PEAP') {
            $profileXml = [xml] ($Script:WiFiProfileXmlEapPeap -f $ProfileName, ([string] $ConnectHiddenSSID).ToLower(), $ConnectionMode, $Authentication, $Encryption)

            if ($ServerNames) {
                $profileXml.WLANProfile.MSM.security.OneX.EAPConfig.EapHostConfig.Config.Eap.EapType.ServerValidation.ServerNames = $ServerNames
            }

            if ($TrustedRootCA) {
                [string]$formattedCaHash = $TrustedRootCA -replace '..', '$& '
                $profileXml.WLANProfile.MSM.security.OneX.EAPConfig.EapHostConfig.Config.Eap.EapType.ServerValidation.TrustedRootCA = $formattedCaHash
            }
        }
        elseif ($EAPType -eq 'TLS') {
            $profileXml = [xml] ($Script:WiFiProfileXmlEapTls -f $ProfileName, ([string] $ConnectHiddenSSID).ToLower(), $ConnectionMode, $Authentication, $Encryption)

            if ($ServerNames) {
                $node = $profileXml.WLANProfile.MSM.security.OneX.EAPConfig.EapHostConfig.Config.SelectNodes("//*[local-name()='ServerNames']")
                $node[0].InnerText = $ServerNames
            }

            if ($TrustedRootCA) {
                [string]$formattedCaHash = $TrustedRootCA -replace '..', '$& '
                $node = $profileXml.WLANProfile.MSM.security.OneX.EAPConfig.EapHostConfig.Config.SelectNodes("//*[local-name()='TrustedRootCA']")
                $node[0].InnerText = $formattedCaHash
            }
        }
        else {
            $profileXml = [xml] ($Script:WiFiProfileXmlPersonal -f $ProfileName, ([string] $ConnectHiddenSSID).ToLower(), $ConnectionMode, $Authentication, $Encryption, $Password)
            if (-not $Password) {
                $null = $profileXml.WLANProfile.MSM.security.RemoveChild($profileXml.WLANProfile.MSM.security.sharedKey)
            }

            if ($Authentication -eq 'WPA3SAE') {
                $nsmg = [System.Xml.XmlNamespaceManager]::new($profileXml.NameTable)
                $nsmg.AddNamespace('WLANProfile', $profileXml.DocumentElement.GetAttribute('xmlns'))
                $refNode = $profileXml.SelectSingleNode('//WLANProfile:authEncryption', $nsmg)
                $xmlnode = $profileXml.CreateElement('transitionMode', 'http://www.microsoft.com/networking/WLAN/profile/v4')
                $xmlnode.InnerText = 'true'
                $null = $refNode.AppendChild($xmlnode)
            }
        }

        $profileXml.OuterXml
    }
    catch {
        throw $PSItem
    }
}

function Remove-WiFiHandle {
    [OutputType([void])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.IntPtr]
        $ClientHandle
    )

    $result = [WiFi.ProfileManagement]::WlanCloseHandle($ClientHandle, [IntPtr]::zero)

    if ($result -ne 0) {
        throw $($Script:Error_Strings.ErrorClosingHandle -f $result)
    }
}

$WlanGetProfileListSig = @'
 
[DllImport("wlanapi.dll")]
public static extern uint WlanOpenHandle(
    [In] UInt32 clientVersion,
    [In, Out] IntPtr pReserved,
    [Out] out UInt32 negotiatedVersion,
    [Out] out IntPtr clientHandle
);
 
[DllImport("Wlanapi.dll")]
public static extern uint WlanCloseHandle(
    [In] IntPtr ClientHandle,
    IntPtr pReserved
);
 
[DllImport("wlanapi.dll", SetLastError = true, CallingConvention=CallingConvention.Winapi)]
public static extern uint WlanGetProfileList(
    [In] IntPtr clientHandle,
    [In, MarshalAs(UnmanagedType.LPStruct)] Guid interfaceGuid,
    [In] IntPtr pReserved,
    [Out] out IntPtr profileList
);

[DllImport("wlanapi.dll", EntryPoint = "WlanFreeMemory")]
public static extern void WlanFreeMemory(
    [In] IntPtr pMemory
);
 
[DllImport("Wlanapi.dll", SetLastError = true, CharSet = CharSet.Unicode)]
public static extern uint WlanSetProfile(
    [In] IntPtr clientHanle,
    [In] ref Guid interfaceGuid,
    [In] uint flags,
    [In] IntPtr ProfileXml,
    [In, Optional] IntPtr AllUserProfileSecurity,
    [In] bool Overwrite,
    [In, Out] IntPtr pReserved,
    [In, Out]ref IntPtr pdwReasonCode
);
 
[DllImport("Wlanapi.dll", SetLastError = true)]
public static extern uint WlanGetAvailableNetworkList(
    [In] IntPtr hClientHandle,
    [In, MarshalAs(UnmanagedType.LPStruct)] Guid interfaceGuid,
    [In] uint dwFlags,
    [In] IntPtr pReserved,
    [Out] out IntPtr ppAvailableNetworkList
);
 
[DllImport("Wlanapi.dll", SetLastError = true)]
public static extern uint WlanConnect(
    [In] IntPtr hClientHandle,
    [In] ref Guid interfaceGuid,
    [In] ref WLAN_CONNECTION_PARAMETERS pConnectionParameters,
    [In, Out] IntPtr pReserved
);
 
[StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)]
public struct WLAN_CONNECTION_PARAMETERS
{
    public WLAN_CONNECTION_MODE wlanConnectionMode;
    public string strProfile;
    public DOT11_SSID[] pDot11Ssid;
    public DOT11_BSSID_LIST[] pDesiredBssidList;
    public DOT11_BSS_TYPE dot11BssType;
    public uint dwFlags;
}
 
public struct DOT11_BSSID_LIST
{
    public NDIS_OBJECT_HEADER Header;
    public ulong uNumOfEntries;
    public ulong uTotalNumOfEntries;
    public IntPtr BSSIDs;
}
 
public struct NDIS_OBJECT_HEADER
{
    public byte Type;
    public byte Revision;
    public ushort Size;
}

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct WLAN_AVAILABLE_NETWORK_LIST
{
    public uint dwNumberOfItems;
    public uint dwIndex;
    public WLAN_AVAILABLE_NETWORK[] wlanAvailableNetwork;
    public WLAN_AVAILABLE_NETWORK_LIST(IntPtr ppAvailableNetworkList)
    {
        dwNumberOfItems = (uint)Marshal.ReadInt64 (ppAvailableNetworkList);
        dwIndex = (uint)Marshal.ReadInt64 (ppAvailableNetworkList, 4);
        wlanAvailableNetwork = new WLAN_AVAILABLE_NETWORK[dwNumberOfItems];
        for (int i = 0; i < dwNumberOfItems; i++)
        {
            IntPtr pWlanAvailableNetwork = new IntPtr (ppAvailableNetworkList.ToInt64() + i * Marshal.SizeOf (typeof(WLAN_AVAILABLE_NETWORK)) + 8);
            wlanAvailableNetwork[i] = (WLAN_AVAILABLE_NETWORK)Marshal.PtrToStructure (pWlanAvailableNetwork, typeof(WLAN_AVAILABLE_NETWORK));
        }
    }
}
 
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct WLAN_AVAILABLE_NETWORK
{
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)]
    public string ProfileName;
    public DOT11_SSID Dot11Ssid;
    public DOT11_BSS_TYPE dot11BssType;
    public uint uNumberOfBssids;
    public bool bNetworkConnectable;
    public uint wlanNotConnectableReason;
    public uint uNumberOfPhyTypes;
 
    [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
    public DOT11_PHY_TYPE[] dot11PhyTypes;
    public bool bMorePhyTypes;
    public uint SignalQuality;
    public bool SecurityEnabled;
    public DOT11_AUTH_ALGORITHM dot11DefaultAuthAlgorithm;
    public DOT11_CIPHER_ALGORITHM dot11DefaultCipherAlgorithm;
    public uint dwFlags;
    public uint dwReserved;
}
 
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
public struct DOT11_SSID
{
    public uint uSSIDLength;
 
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
    public string ucSSID;
}
 
public enum DOT11_BSS_TYPE
{
    Infrastructure = 1,
    Independent = 2,
    Any = 3,
}
 
public enum DOT11_PHY_TYPE
{
    dot11_phy_type_unknown = 0,
    dot11_phy_type_any = 0,
    dot11_phy_type_fhss = 1,
    dot11_phy_type_dsss = 2,
    dot11_phy_type_irbaseband = 3,
    dot11_phy_type_ofdm = 4,
    dot11_phy_type_hrdsss = 5,
    dot11_phy_type_erp = 6,
    dot11_phy_type_ht = 7,
    dot11_phy_type_vht = 8,
    dot11_phy_type_IHV_start = -2147483648,
    dot11_phy_type_IHV_end = -1,
}
 
public enum DOT11_AUTH_ALGORITHM
{
    DOT11_AUTH_ALGO_80211_OPEN = 1,
    DOT11_AUTH_ALGO_80211_SHARED_KEY = 2,
    DOT11_AUTH_ALGO_WPA = 3,
    DOT11_AUTH_ALGO_WPA_PSK = 4,
    DOT11_AUTH_ALGO_WPA_NONE = 5,
    DOT11_AUTH_ALGO_RSNA = 6,
    DOT11_AUTH_ALGO_RSNA_PSK = 7,
    DOT11_AUTH_ALGO_WPA3 = 8,
    DOT11_AUTH_ALGO_WPA3_SAE = 9,
    DOT11_AUTH_ALGO_OWE = 10,
    DOT11_AUTH_ALGO_WPA3_ENT = 11,
    DOT11_AUTH_ALGO_IHV_START = -2147483648,
    DOT11_AUTH_ALGO_IHV_END = -1,
}
 
public enum DOT11_CIPHER_ALGORITHM
{
    DOT11_CIPHER_ALGO_NONE = 0,
    DOT11_CIPHER_ALGO_WEP40 = 1,
    DOT11_CIPHER_ALGO_TKIP = 2,
    DOT11_CIPHER_ALGO_CCMP = 4,
    DOT11_CIPHER_ALGO_WEP104 = 5,
    DOT11_CIPHER_ALGO_BIP = 6,
    DOT11_CIPHER_ALGO_GCMP = 8,
    DOT11_CIPHER_ALGO_GCMP_256 = 9,
    DOT11_CIPHER_ALGO_CCMP_256 = 10,
    DOT11_CIPHER_ALGO_BIP_GMAC_128 = 11,
    DOT11_CIPHER_ALGO_BIP_GMAC_256 = 12,
    DOT11_CIPHER_ALGO_BIP_CMAC_256 = 13,
    DOT11_CIPHER_ALGO_WPA_USE_GROUP = 256,
    DOT11_CIPHER_ALGO_RSN_USE_GROUP = 256,
    DOT11_CIPHER_ALGO_WEP = 257,
    DOT11_CIPHER_ALGO_IHV_START = -2147483648,
    DOT11_CIPHER_ALGO_IHV_END = -1,
}
 
public enum WLAN_CONNECTION_MODE
{
    wlan_connection_mode_profile,
    wlan_connection_mode_temporary_profile,
    wlan_connection_mode_discovery_secure,
    wlan_connection_mode_discovery_unsecure,
    wlan_connection_mode_auto,
    wlan_connection_mode_invalid,
}
 
[Flags]
public enum WlanConnectionFlag
{
    Default = 0,
    HiddenNetwork = 1,
    AdhocJoinOnly = 2,
    IgnorePrivayBit = 4,
    EapolPassThrough = 8,
    PersistDiscoveryProfile = 10,
    PersistDiscoveryProfileConnectionModeAuto = 20,
    PersistDiscoveryProfileOverwriteExisting = 40
}

[DllImport("Wlanapi.dll", SetLastError = true)]
public static extern uint WlanEnumInterfaces(
    [In] IntPtr hClientHandle,
    [In] IntPtr pReserved,
    [Out] out IntPtr ppInterfaceList
);
 
public struct WLAN_INTERFACE_INFO_LIST
{
    public uint dwNumberOfItems;
    public uint dwIndex;
    public WLAN_INTERFACE_INFO[] wlanInterfaceInfo;
    public WLAN_INTERFACE_INFO_LIST(IntPtr ppInterfaceInfoList)
    {
        dwNumberOfItems = (uint)Marshal.ReadInt32(ppInterfaceInfoList);
        dwIndex = (uint)Marshal.ReadInt32(ppInterfaceInfoList, 4);
        wlanInterfaceInfo = new WLAN_INTERFACE_INFO[dwNumberOfItems];
        IntPtr ppInterfaceInfoListTemp = new IntPtr(ppInterfaceInfoList.ToInt64() + 8);
        for (int i = 0; i < dwNumberOfItems; i++)
        {
            ppInterfaceInfoList = new IntPtr(ppInterfaceInfoListTemp.ToInt64() + i * Marshal.SizeOf(typeof(WLAN_INTERFACE_INFO)));
            wlanInterfaceInfo[i] = (WLAN_INTERFACE_INFO)Marshal.PtrToStructure(ppInterfaceInfoList, typeof(WLAN_INTERFACE_INFO));
        }
    }
}
 
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct WLAN_INTERFACE_INFO
{
    public Guid Guid;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)]
    public string Description;
    public WLAN_INTERFACE_STATE State;
}
 
public enum WLAN_INTERFACE_STATE {
    not_ready = 0,
    connected = 1,
    ad_hoc_network_formed = 2,
    disconnecting = 3,
    disconnected = 4,
    associating = 5,
    discovering = 6,
    authenticating = 7
}
 
[DllImport("Wlanapi.dll",SetLastError=true)]
public static extern uint WlanScan(
    IntPtr hClientHandle,
    ref Guid pInterfaceGuid,
    IntPtr pDot11Ssid,
    IntPtr pIeData,
    IntPtr pReserved
);

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct WLAN_CONNECTION_ATTRIBUTES
{
    public WLAN_INTERFACE_STATE isState;
 
    public WLAN_CONNECTION_MODE wlanConnectionMode;
 
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)]
    public string strProfileName;
 
    public WLAN_ASSOCIATION_ATTRIBUTES wlanAssociationAttributes;
 
    public WLAN_SECURITY_ATTRIBUTES wlanSecurityAttributes;
}
 
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct WLAN_ASSOCIATION_ATTRIBUTES
{
    public DOT11_SSID dot11Ssid;
 
    public DOT11_BSS_TYPE dot11BssType;

    [MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]
    public byte[] _dot11Bssid;
 
    public DOT11_PHY_TYPE dot11PhyType;
 
    public uint uDot11PhyIndex;
 
    public uint wlanSignalQuality;
 
    public uint ulRxRate;
 
    public uint ulTxRate;
}
 
[StructLayout(LayoutKind.Sequential)]
public struct WLAN_SECURITY_ATTRIBUTES
{
    [MarshalAs(UnmanagedType.Bool)]
    public bool bSecurityEnabled;
 
    [MarshalAs(UnmanagedType.Bool)]
    public bool bOneXEnabled;
    public DOT11_AUTH_ALGORITHM dot11AuthAlgorithm;
    public DOT11_CIPHER_ALGORITHM dot11CipherAlgorithm;
}
'@

Add-Type -MemberDefinition $WlanGetProfileListSig -Name ProfileManagement -Namespace WiFi -Using System.Text