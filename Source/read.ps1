Start-Process "ms-screenclip:"

$Entry = Get-Clipboard -Raw
Start-Sleep -Seconds 1.0
Wait-Process "ScreenClippingHost"

$Name = $ENV:Temp + "\temp.png"

Add-Type -AssemblyName System.Windows.Forms

if ([Windows.Forms.Clipboard]::ContainsImage()) {
    [Windows.ApplicationModel.DataTransfer.DataPackage, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime] | Out-Null
    [Windows.ApplicationModel.DataTransfer.ClipboardContentOptions, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime] | Out-Null
    [Windows.ApplicationModel.DataTransfer.Clipboard, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime] | Out-Null
    Add-Type -AssemblyName System.Drawing

    if ([Windows.ApplicationModel.DataTransfer.Clipboard]::IsHistoryEnabled()) {
        $Target = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()

        Add-Type -AssemblyName System.Runtime.WindowsRuntime
        $AsyncTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
        $AsyncTask = $AsyncTaskGeneric.MakeGenericMethod([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])
        $NetTask = $AsyncTask.Invoke($Null, @($Target))
        $NetTask.Wait(-1) | Out-Null
        $History = $NetTask.Result

        if ($History::Items[0].Timestamp -gt [System.DateTimeOffset]::Now.AddSeconds(-5)) { # True, if image is newer than 2 seconds
            $Image = [Windows.Forms.Clipboard]::GetImage()
            $Image.Save($Name, [Drawing.Imaging.ImageFormat]::Png)
            [Windows.ApplicationModel.DataTransfer.Clipboard]::DeleteItemFromHistory($History::Items[0]) | Out-Null
            Set-Clipboard -Value $Entry
        } else {
            Start-Process -FilePath ".\key.exe"
            Exit
        }
    } else {
        $Image = [Windows.Forms.Clipboard]::GetImage()
        $Image.Save($Name, [Drawing.Imaging.ImageFormat]::Png)
    }

    $Title_String = & .\zbarimg.exe -q --raw $Name
    $Info_String = "was copied to clipboard"
    if ($Title_String) {
        Set-Clipboard -Value $Title_String
    } else {
        $Script:Title_String = "No QR-Code detected!"
        $Script:Info_String = "Please select a complete QR-Code"
        Set-Clipboard -Value $Entry
    }
    Remove-Item -Path $Name -ErrorAction SilentlyContinue
    Get-ChildItem "$([System.Environment]::GetFolderPath("MyPictures"))\Screenshots" -Recurse | Where-Object CreationTime -gt (Get-Date).AddSeconds(-5) | Remove-Item

    $AppId = "OttoZumkeller.QR-CodeReader"
    $Open = ""
    $Array = ""
    $Visual_Title_String = $Title_String
    $Status = ""

    $Schemes = "aaa", "aaas", "about", "acap", "acct", "acd", "acr", "adiumxtra", "adt", "afp", "afs", "aim", "amss", "android", "appdata", "apt", "ar", "ark", "at", "attachment", "aw", "barion", "bb", "beshare", "bitcoin", "bitcoincash", "blob", "bolo", "browserext", "cabal", "calculator", "callto", "cap", "cast", "casts", "chrome", "chrome-extension", "cid", "coap", "coap+tcp", "coap+ws", "coaps", "coaps+tcp", "coaps+ws", "com-eventbrite-attendee", "content", "content-type", "crid", "cstr", "cvs", "dab", "dat", "data", "dav", "dhttp", "diaspora", "dict", "did", "dis", "dlna-playcontainer", "dlna-playsingle", "dns", "dntp", "doi", "dpp", "drm", "drop", "dtmi", "dtn", "dvb", "dvx", "dweb", "ed2k", "eid", "elsi", "embedded", "ens", "ethereum", "example", "facetime", "fax", "feed", "feedready", "fido", "file", "filesystem", "finger", "first-run-pen-experience", "fish", "fm", "ftp", "fuchsia-pkg", "geo", "gg", "git", "gitoid", "gizmoproject", "go", "gopher", "graph", "grd", "gtalk", "h323", "ham", "hcap", "hcp", "http", "https", "hxxp", "hxxps", "hydrazone", "hyper", "iax", "icap", "icon", "im", "imap", "info", "iotdisco", "ipfs", "ipn", "ipns", "ipp", "ipps", "irc", "irc6", "ircs", "iris", "iris.beep", "iris.lwz", "iris.xpc", "iris.xpcs", "isostore", "itms", "jabber", "jar", "jms", "keyparc", "lastfm", "lbry", "ldap", "ldaps", "leaptofrogans", "lid", "lorawan", "lpa", "lvlt", "magnet", "mailserver", "mailto", "maps", "market", "matrix", "message", "microsoft.windows.camera", "microsoft.windows.camera.multipicker prov/microsoft.windows.camera.multipicker microsoft.windows.camera.multipicker Provisional -", "microsoft.windows.camera.picker", "mid", "mms", "modem", "mongodb", "moz", "ms-access", "ms-appinstaller", "ms-browser-extension", "ms-calculator", "ms-drive-to", "ms-enrollment", "ms-excel", "ms-eyecontrolspeech", "ms-gamebarservices", "ms-gamingoverlay", "ms-getoffice", "ms-help", "ms-infopath", "ms-inputapp", "ms-launchremotedesktop", "ms-lockscreencomponent-config", "ms-media-stream-id", "ms-meetnow", "ms-mixedrealitycapture", "ms-mobileplans", "ms-newsandinterests", "ms-officeapp", "ms-people", "ms-project", "ms-powerpoint", "ms-publisher", "ms-remotedesktop", "ms-remotedesktop-launch", "ms-restoretabcompanion", "ms-screenclip", "ms-screensketch", "ms-search", "ms-search-repair", "ms-secondary-screen-controller", "ms-secondary-screen-setup", "ms-settings", "ms-settings-airplanemode", "ms-settings-bluetooth", "ms-settings-camera", "ms-settings-cellular", "ms-settings-cloudstorage", "ms-settings-connectabledevices", "ms-settings-displays-topology", "ms-settings-emailandaccounts", "ms-settings-language", "ms-settings-location", "ms-settings-lock", "ms-settings-nfctransactions", "ms-settings-notifications", "ms-settings-power", "ms-settings-privacy", "ms-settings-proximity", "ms-settings-screenrotation", "ms-settings-wifi", "ms-settings-workplace", "ms-spd", "ms-stickers", "ms-sttoverlay", "ms-transit-to", "ms-useractivityset", "ms-virtualtouchpad", "ms-visio", "ms-walk-to", "ms-whiteboard", "ms-whiteboard-cmd", "ms-word", "msnim", "msrp", "msrps", "mss", "mt", "mtqp", "mumble", "mupdate", "mvn", "news", "nfs", "ni", "nih", "nntp", "notes", "num", "ocf", "oid", "onenote", "onenote-cmd", "opaquelocktoken", "openid", "openpgp4fpr", "otpauth", "p1", "pack", "palm", "paparazzi", "payment", "payto", "pkcs11", "platform", "pop", "pres", "prospero", "proxy", "pwid", "psyc", "pttp", "qb", "query", "quic-transport", "redis", "rediss", "reload", "res", "resource", "rmi", "rsync", "rtmfp", "rtmp", "rtsp", "rtsps", "rtspu", "sarif", "secondlife", "secret-token", "service", "session", "sftp", "sgn", "shc", "sieve", "simpleledger", "simplex", "sip", "sips", "skype", "smb", "smp", "sms", "smtp", "snews", "snmp", "soap.beep", "soap.beeps", "soldat", "spiffe", "spotify", "ssb", "ssh", "starknet", "steam", "stun", "stuns", "submit", "svn", "swh", "swid", "swidpath", "tag", "taler", "teamspeak", "tel", "teliaeid", "telnet", "tftp", "things", "thismessage", "tip", "tn3270", "tool", "turn", "turns", "tv", "udp", "unreal", "upt", "urn", "ut2004", "uuid-in-package", "v-event", "vemmi", "ventrilo", "ves", "videotex", "vnc", "view-source", "vscode", "vscode-insiders", "vsls", "w3", "wais", "web3", "wcr", "webcal", "web+ap", "wifi", "wpid", "ws", "wss", "wtai", "wyciwyg", "xcon", "xcon-userid", "xfire", "xmlrpc.beep", "xmlrpc.beeps", "xmpp", "xri", "ymsgr", "z39.50", "z39.50r", "z39.50s"

    Write-Host 
    If ([Uri]::EscapeUriString($Title_String).Scheme -in $Schemes) {
    # If ($Title_String -Match ($Schemes -Join ":*|^")) {
        $Script:Open ="<action content='Follow Link' activationType='protocol' arguments='$($Title_String)' />"
        If ($Title_String -Match "^wifi:*:*") {
            $Script:Array = $Title_String.Split(":").Split(";")
            $Script:Visual_Title_String = "WiFi QR-Code detected!"
            $Script:Info_String = "Network Name: $($Array[[Array]::IndexOf($Array, "S") + 1])"
            $Script:Open ="<action content='Connect' activationType='protocol' arguments='$($Title_String)' />"
        }
    }

    $Template = "<toast>
                    <visual>
                        <binding template='ToastGeneric'>
                            <text id='1'>$($Visual_Title_String)</text>
                            <text id='2'>$($Info_String)</text>
                        </binding>
                    </visual>
                    <actions>
                        $($Open)
                        <action activationType='system' arguments='dismiss' content='' />
                    </actions>
                </toast>"

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $Content = New-Object Windows.Data.Xml.Dom.XmlDocument
    $Content.LoadXml($Template)
    $Toast = New-Object Windows.UI.Notifications.ToastNotification $Content
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
}
Start-Process -FilePath ".\key.exe"