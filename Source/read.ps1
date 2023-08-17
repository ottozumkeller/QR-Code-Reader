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

    $AppId = "Otto Zumkeller.QR-Code Reader"
    $Open = ""
    $Array = ""
    $Visual_Title_String = $Title_String
    if ([Uri]::IsWellFormedUriString([Uri]::EscapeDataString($Title_String), 0)) {
        $Prompt = "Follow Link"
        if ($Title_String -Like "wifi:*") {
            $Script:Array = $Title_String.Split(":").Split(";")
            $Script:Visual_Title_String = "WiFi QR-Code detected!"
            $Script:Info_String = "Network Name: $($Array[[Array]::IndexOf($Array, "S") + 1])"
            $Script:Prompt = "Connect"
        }
        $Script:Open =
@"
    <action content="$($Prompt)" activationType="protocol" arguments="$($Title_String)"/>
"@
    }

    $Template =
@"
    <toast>
        <visual>
            <binding template="ToastGeneric">
                <text id="1">$($Visual_Title_String)</text>
                <text id="2">$($Info_String)</text>
            </binding>
        </visual>
        <actions>
            $($Open)
            <action activationType="system" arguments="dismiss" content=""/>
        </actions>
    </toast>
"@

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $Content = New-Object Windows.Data.Xml.Dom.XmlDocument
    $Content.LoadXml($Template)
    $Toast = New-Object Windows.UI.Notifications.ToastNotification $Content
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
}
Start-Process -FilePath ".\key.exe"