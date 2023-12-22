$Content = $Args[0]
$Array = $Content.Split(":").Split(";")
$Name = $Array[[Array]::IndexOf($Array, "S") + 1]
$Key = $Array[[Array]::IndexOf($Array, "P") + 1]
$Info = netsh wlan show networks
$Networks = $Info.Split(":")
$Auth = $Networks[[Array]::IndexOf($Networks, " $Name") + 4].Substring(1)
Write-Host $Auth
$Xml = "
    <?xml version='1.0'?>
    <WLANProfile xmlns='http://www.microsoft.com/networking/WLAN/profile/v1'>
        <name>$Name</name>
        <SSIDConfig>
            <SSID>
                <name>$Name</name>
            </SSID>
        </SSIDConfig>
        <connectionType>ESS</connectionType>
        <connectionMode>auto</connectionMode>
        <MSM>
            <security>
                <authEncryption>
                    <authentication>WPA2PSK</authentication>
                    <encryption>AES</encryption>
                    <useOneX>false</useOneX>
                </authEncryption>
                <sharedKey>
                    <keyType>passPhrase</keyType>
                    <protected>false</protected>
                    <keyMaterial>$Key</keyMaterial>
                </sharedKey>
            </security>
        </MSM>
        <MacRandomization xmlns='http://www.microsoft.com/networking/WLAN/profile/v3'>
            <enableRandomization>false</enableRandomization>
        </MacRandomization>
    </WLANProfile>"

Set-Content -Path "$ENV:Temp\profile.xml" -Value $Xml
netsh wlan add profile filename="$ENV:Temp\profile.xml" user=all
Remove-Item -Path "$ENV:Temp\profile.xml"