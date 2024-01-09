#SingleInstance Force
#Requires AutoHotkey v2.0

;@Ahk2Exe-SetName QR-Code Reader
;@Ahk2Exe-SetDescription QR-Code Reader
;@Ahk2Exe-SetVersion 1.1.0
;@Ahk2Exe-AddResource qr_reader_dark.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource qr_reader_light.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource qr_reader_dark.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource qr_reader_light.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetMainIcon qr_reader_dark.ico
;@Ahk2Exe-SetCopyright Otto Zumkeller 2024
;@Ahk2Exe-SetOrigFilename reader.exe

SetWorkingDir(A_ScriptDir)

;Create tray icon and menu
A_IconTip := "QR-Code Reader"
Tray := A_TrayMenu
Tray.delete()
Tray.add("Scan", Scan)
Tray.add("Help", Help)
Tray.Default := "Scan"
Tray.addStandard()
Tray.delete("&Suspend Hotkeys")
Tray.delete("&Pause Script")

PrevTheme := 0

;Set dark/light theme
Theme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
SetPreferredAppMode := DllCall("GetProcAddress", "ptr", Theme, "ptr", 135, "ptr")
FlushMenuThemes := DllCall("GetProcAddress", "ptr", Theme, "ptr", 136, "ptr")
DllCall(SetPreferredAppMode, "int", 1)
DllCall(FlushMenuThemes)

;Check every 2 seconds if theme has changed
SetTimer(CheckTheme, 2000)

;Check if tray icon was left-clicked
OnMessage(0x404, Callback, -1)
Return

Callback(wParam, lParam, uMsg, hWnd)
{
    if (lParam = 0x201) {
        Scan()
    }
}

;Set tray icon to dark/light mode
CheckTheme()
{
    Global PrevTheme
    NewTheme := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme")
    if (NewTheme != PrevTheme) {
        if (NewTheme = 1) {
            TraySetIcon(A_ScriptName, -206)
            PrevTheme := 1
        } else {
            TraySetIcon(A_ScriptName, -207)
            PrevTheme := 0
        }
    }
}

Help(*)
{
    Run("https://github.com/ottozumkeller/QR-Code-Reader/blob/main/README.md")
}

#!Q::
{
    Scan()
}

Scan(*)
{
    Entry := A_Clipboard
    Run("ms-screenclip:")

    GroupAdd("SnippingTools", "ahk_exe SnippingTool.exe")
    GroupAdd("SnippingTools", "ahk_exe ScreenClippingHost.exe")

    WinWait("ahk_group SnippingTools")
    WinwaitClose("ahk_group SnippingTools")

    Sleep(500)

    ;Powershell:
    ;Strings need to be enclosed with '. For ", write \"
    Script := "$Entry = '" Entry . "'" . "
    (
        
        $Name = $ENV:Temp + '\temp.png'

        Add-Type -AssemblyName System.Windows.Forms

        if ([Windows.Forms.Clipboard]::ContainsImage()) {
            [Windows.ApplicationModel.DataTransfer.DataPackage, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime] | Out-Null
            [Windows.ApplicationModel.DataTransfer.ClipboardContentOptions, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime] | Out-Null
            [Windows.ApplicationModel.DataTransfer.Clipboard, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime] | Out-Null

            Add-Type -AssemblyName System.Drawing
            Add-Type -Path "zxing.dll"
            
            $Reader = New-Object -TypeName ZXing.BarcodeReader
            $Reader.Options.TryHarder = 1
            $Bitmap = Get-Clipboard -Format Image
            $Result = $Reader.Decode($Bitmap)
            $Title_String = $Result.Text
            $Info_String = 'was copied to clipboard'

            if ([Windows.ApplicationModel.DataTransfer.Clipboard]::IsHistoryEnabled()) {

                Add-Type -AssemblyName System.Runtime.WindowsRuntime

                $Target = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()
                $AsyncTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 })[1]
                $AsyncTask = $AsyncTaskGeneric.MakeGenericMethod([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])
                $NetTask = $AsyncTask.Invoke($Null, @($Target))
                $NetTask.Wait(-1) | Out-Null
                $History = $NetTask.Result

                [Windows.ApplicationModel.DataTransfer.Clipboard]::DeleteItemFromHistory($History::Items[0]) | Out-Null
            } else {
                if ([String]::IsNullOrEmpty($Entry)) {
                    [Windows.Forms.Clipboard]::Clear()
                } else {
                    Set-Clipboard -Value $Entry
                }
            }

            if ([String]::IsNullOrEmpty($Title_String)) {
                $Title_String = 'No QR-Code detected!'
                $Info_String = 'Please select a complete QR-Code'
            } else {
                Set-Clipboard -Value $Title_String
            }

            $Path = [System.Environment]::GetFolderPath(\"MyPictures\")
            Get-ChildItem  ($Path + '\Screenshots') -Recurse | Where-Object CreationTime -gt (Get-Date).AddSeconds(-5) | Remove-Item
        
            $AppId = 'OttoZumkeller.QR-CodeReader'
            $Open = ''
            $Array = ''
            $Visual_Title_String = $Title_String
        
            $Schemes = 'aaa', 'aaas', 'about', 'acap', 'acct', 'acd', 'acr', 'adiumxtra', 'adt', 'afp', 'afs', 'aim', 'amss', 'android', 'appdata', 'apt', 'ar', 'ark', 'at', 'attachment', 'aw', 'barion', 'bb', 'beshare', 'bitcoin', 'bitcoincash', 'blob', 'bolo', 'browserext', 'cabal', 'calculator', 'callto', 'cap', 'cast', 'casts', 'chrome', 'chrome-extension', 'cid', 'coap', 'coap+tcp', 'coap+ws', 'coaps', 'coaps+tcp', 'coaps+ws', 'com-eventbrite-attendee', 'content', 'content-type', 'crid', 'cstr', 'cvs', 'dab', 'dat', 'data', 'dav', 'dhttp', 'diaspora', 'dict', 'did', 'dis', 'dlna-playcontainer', 'dlna-playsingle', 'dns', 'dntp', 'doi', 'dpp', 'drm', 'drop', 'dtmi', 'dtn', 'dvb', 'dvx', 'dweb', 'ed2k', 'eid', 'elsi', 'embedded', 'ens', 'ethereum', 'example', 'facetime', 'fax', 'feed', 'feedready', 'fido', 'file', 'filesystem', 'finger', 'first-run-pen-experience', 'fish', 'fm', 'ftp', 'fuchsia-pkg', 'geo', 'gg', 'git', 'gitoid', 'gizmoproject', 'go', 'gopher', 'graph', 'grd', 'gtalk', 'h323', 'ham', 'hcap', 'hcp', 'http', 'https', 'hxxp', 'hxxps', 'hydrazone', 'hyper', 'iax', 'icap', 'icon', 'im', 'imap', 'info', 'iotdisco', 'ipfs', 'ipn', 'ipns', 'ipp', 'ipps', 'irc', 'irc6', 'ircs', 'iris', 'iris.beep', 'iris.lwz', 'iris.xpc', 'iris.xpcs', 'isostore', 'itms', 'jabber', 'jar', 'jms', 'keyparc', 'lastfm', 'lbry', 'ldap', 'ldaps', 'leaptofrogans', 'lid', 'lorawan', 'lpa', 'lvlt', 'magnet', 'mailserver', 'mailto', 'maps', 'market', 'matrix', 'message', 'microsoft.windows.camera', 'microsoft.windows.camera.multipicker prov/microsoft.windows.camera.multipicker microsoft.windows.camera.multipicker Provisional -', 'microsoft.windows.camera.picker', 'mid', 'mms', 'modem', 'mongodb', 'moz', 'ms-access', 'ms-appinstaller', 'ms-browser-extension', 'ms-calculator', 'ms-drive-to', 'ms-enrollment', 'ms-excel', 'ms-eyecontrolspeech', 'ms-gamebarservices', 'ms-gamingoverlay', 'ms-getoffice', 'ms-help', 'ms-infopath', 'ms-inputapp', 'ms-launchremotedesktop', 'ms-lockscreencomponent-config', 'ms-media-stream-id', 'ms-meetnow', 'ms-mixedrealitycapture', 'ms-mobileplans', 'ms-newsandinterests', 'ms-officeapp', 'ms-people', 'ms-project', 'ms-powerpoint', 'ms-publisher', 'ms-remotedesktop', 'ms-remotedesktop-launch', 'ms-restoretabcompanion', 'ms-screenclip', 'ms-screensketch', 'ms-search', 'ms-search-repair', 'ms-secondary-screen-controller', 'ms-secondary-screen-setup', 'ms-settings', 'ms-settings-airplanemode', 'ms-settings-bluetooth', 'ms-settings-camera', 'ms-settings-cellular', 'ms-settings-cloudstorage', 'ms-settings-connectabledevices', 'ms-settings-displays-topology', 'ms-settings-emailandaccounts', 'ms-settings-language', 'ms-settings-location', 'ms-settings-lock', 'ms-settings-nfctransactions', 'ms-settings-notifications', 'ms-settings-power', 'ms-settings-privacy', 'ms-settings-proximity', 'ms-settings-screenrotation', 'ms-settings-wifi', 'ms-settings-workplace', 'ms-spd', 'ms-stickers', 'ms-sttoverlay', 'ms-transit-to', 'ms-useractivityset', 'ms-virtualtouchpad', 'ms-visio', 'ms-walk-to', 'ms-whiteboard', 'ms-whiteboard-cmd', 'ms-word', 'msnim', 'msrp', 'msrps', 'mss', 'mt', 'mtqp', 'mumble', 'mupdate', 'mvn', 'news', 'nfs', 'ni', 'nih', 'nntp', 'notes', 'num', 'ocf', 'oid', 'onenote', 'onenote-cmd', 'opaquelocktoken', 'openid', 'openpgp4fpr', 'otpauth', 'p1', 'pack', 'palm', 'paparazzi', 'payment', 'payto', 'pkcs11', 'platform', 'pop', 'pres', 'prospero', 'proxy', 'pwid', 'psyc', 'pttp', 'qb', 'query', 'quic-transport', 'redis', 'rediss', 'reload', 'res', 'resource', 'rmi', 'rsync', 'rtmfp', 'rtmp', 'rtsp', 'rtsps', 'rtspu', 'sarif', 'secondlife', 'secret-token', 'service', 'session', 'sftp', 'sgn', 'shc', 'sieve', 'simpleledger', 'simplex', 'sip', 'sips', 'skype', 'smb', 'smp', 'sms', 'smtp', 'snews', 'snmp', 'soap.beep', 'soap.beeps', 'soldat', 'spiffe', 'spotify', 'ssb', 'ssh', 'starknet', 'steam', 'stun', 'stuns', 'submit', 'svn', 'swh', 'swid', 'swidpath', 'tag', 'taler', 'teamspeak', 'tel', 'teliaeid', 'telnet', 'tftp', 'things', 'thismessage', 'tip', 'tn3270', 'tool', 'turn', 'turns', 'tv', 'udp', 'unreal', 'upt', 'urn', 'ut2004', 'uuid-in-package', 'v-event', 'vemmi', 'ventrilo', 'ves', 'videotex', 'vnc', 'view-source', 'vscode', 'vscode-insiders', 'vsls', 'w3', 'wais', 'web3', 'wcr', 'webcal', 'web+ap', 'wifi', 'wpid', 'ws', 'wss', 'wtai', 'wyciwyg', 'xcon', 'xcon-userid', 'xfire', 'xmlrpc.beep', 'xmlrpc.beeps', 'xmpp', 'xri', 'ymsgr', 'z39.50', 'z39.50r', 'z39.50s'
        
            If (([Uri] $Title_String).Scheme -in $Schemes) {
                $Open = '<action content=\"Follow Link\" activationType=\"protocol\" arguments=\"' + $Title_String + '\" />'
                If (([Uri] $Title_String).Scheme -eq 'wifi') {
                    $Array = $Title_String.Split('[;:]')
                    $Visual_Title_String = 'WiFi QR-Code detected!'
                    $Info_String = 'Network name: ' + $Array[[Array]::IndexOf($Array, 'S') + 1]
                    $Open = '<action content=\"Connect\" activationType=\"protocol\" arguments=\"' + $Title_String + '\" />'
                }
            }
        
            $Template = '<toast><visual><binding template=\"ToastGeneric\"><text id=\"1\">' + $Visual_Title_String + '</text><text id=\"2\">' + $Info_String + '</text></binding></visual><actions>' + $Open + '<action activationType=\"system\" arguments=\"dismiss\" content=\"\" /></actions></toast>'
        
            [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
            [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
            [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        
            $Content = New-Object Windows.Data.Xml.Dom.XmlDocument
            $Content.LoadXml($Template)
            $Toast = New-Object Windows.UI.Notifications.ToastNotification $Content
            [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
        }
    )"
    
    ;RunWait("PowerShell.exe -NoExit -Command &{" . Script . "}", , "Min")
    RunWait("PowerShell.exe -WindowStyle Hidden -Command &{" . Script . "}", , "Hide")
}