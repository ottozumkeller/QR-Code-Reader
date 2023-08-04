Add-Type -AssemblyName System.Runtime.WindowsRuntime
$Entry = Get-Clipboard -Raw

$AsyncTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
Function Await($WinRtTask, $ResultType) {
 $AsyncTask = $AsyncTaskGeneric.MakeGenericMethod($ResultType)
 $NetTask = $AsyncTask.Invoke($null, @($WinRtTask))
 $NetTask.Wait(-1) | Out-Null
 $NetTask.Result
}

Start-Process "ms-screenclip:"

Start-Sleep -Seconds 1.0
Wait-Process "ScreenClippingHost"

$Name = $ENV:Temp + "\temp.png"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if ([Windows.Forms.Clipboard]::ContainsImage()) {
    if ([Windows.ApplicationModel.DataTransfer.Clipboard]::IsHistoryEnabled()) {
        [Windows.ApplicationModel.DataTransfer.DataPackage,Windows.ApplicationModel.DataTransfer,ContentType=WindowsRuntime] | Out-Null
        [Windows.ApplicationModel.DataTransfer.ClipboardContentOptions,Windows.ApplicationModel.DataTransfer,ContentType=WindowsRuntime] | Out-Null
        [Windows.ApplicationModel.DataTransfer.Clipboard,Windows.ApplicationModel.DataTransfer,ContentType=WindowsRuntime] | Out-Null
    
        $Target = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()
        $History = Await ($Target) ([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])

        if ($History::Items[0].Timestamp -gt [System.DateTimeOffset]::Now.AddSeconds(-2)) { # True, if image is newer than 2 seconds
            $Image = [Windows.Forms.Clipboard]::GetImage()
            $Image.Save($Name, [Drawing.Imaging.ImageFormat]::Png)
            [Windows.ApplicationModel.DataTransfer.Clipboard]::DeleteItemFromHistory($History::Items[0]) | Out-Null
            Set-Clipboard -Value $Entry
        } else {
            Start-Process -FilePath ".\key_listener.exe"
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

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $AppId = "Otto Zumkeller.QR-Code Reader"
    $Open = ""

    if ([Uri]::IsWellFormedUriString($Title_String, 0)) {
        $Script:Open = "<action content='Follow Link' activationType='protocol' arguments='$($Title_String)'/>"
    }

    $Template = 
@"
        <toast launch="$($Title_String)">
            <visual>
                <binding template="ToastGeneric">
                    <text id="1">$($Title_String)</text>
                    <text id="2">$($Info_String)</text>
                </binding>
            </visual>
            <actions>
                $($Open)
                <action activationType="system" arguments="dismiss" content=""/>
            </actions>
        </toast>
"@

    $Xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $Xml.LoadXml($Template)
    $Toast = New-Object Windows.UI.Notifications.ToastNotification $Xml
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
}
Start-Process -FilePath ".\key_listener.exe"