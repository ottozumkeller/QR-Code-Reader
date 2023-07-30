$ErrorActionPreference = "SilentlyContinue"
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
Function Await($WinRtTask, $ResultType) {
 $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
 $netTask = $asTask.Invoke($null, @($WinRtTask))
 $netTask.Wait(-1) | Out-Null
 $netTask.Result
}

Start-Process "ms-screenclip:"

Start-Sleep -Seconds 1.0
Wait-Process "ScreenClippingHost"

$Name = $ENV:Temp + "\temp.png"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
if ([Windows.Forms.Clipboard]::ContainsImage()) {

    $Null = [Windows.ApplicationModel.DataTransfer.DataPackage,Windows.ApplicationModel.DataTransfer,ContentType=WindowsRuntime]
    $Null = [Windows.ApplicationModel.DataTransfer.ClipboardContentOptions,Windows.ApplicationModel.DataTransfer,ContentType=WindowsRuntime]
    $Null = [Windows.ApplicationModel.DataTransfer.Clipboard,Windows.ApplicationModel.DataTransfer,ContentType=WindowsRuntime]
    
    $Target = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()
    $History = Await ($Target) ([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])
    if ($History::Items[0].Timestamp -gt [System.DateTimeOffset]::Now.AddSeconds(-2)) {
        $Image = [Windows.Forms.Clipboard]::GetImage()
        $Image.Save($Name, [Drawing.Imaging.ImageFormat]::Png)
        if ([Windows.ApplicationModel.DataTransfer.Clipboard]::IsHistoryEnabled()) {
            $Script:Target = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()
            $Script:History = Await ($Target) ([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])
            if ($History::Items.Count -gt 0) {
                [Windows.ApplicationModel.DataTransfer.Clipboard]::DeleteItemFromHistory($History::Items[0]) | Out-Null
                $Target = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()
                $Script:History = Await ($Target) ([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])
                if ($History::Items.Count -gt 0) {
                    [Windows.ApplicationModel.DataTransfer.Clipboard]::SetHistoryItemAsContent($History::Items[0]) | Out-Null
                }
            }
        }

        $Title_String = & .\zbarimg.exe -q --raw $Name
        $Info_String = "was copied to clipboard"
        if ($Title_String) {
            Set-Clipboard -Value $Title_String
        } else {
            $Script:Title_String = "No QR-Code detected!"
            $Script:Info_String = "Please select a complete QR-Code"
        }
        Remove-Item -Path $Name

        Import-Module $PSScriptRoot\burnttoast.psm1
        New-BTAppId -AppId "Otto Zumkeller.QR-Code Reader"
        $Title = New-BTText -Text $Title_String
        $Info = New-BTText -Text $Info_String
        $Open = New-BTButton -Content "Follow Link" -Arguments $Title_String
        $Close = New-BTButton -Dismiss
        $Action = New-BTAction -Buttons $Close
        if ([Uri]::IsWellFormedUriString($Title_String, 0)) {
            $Script:Action = New-BTAction -Buttons $Open, $Close
        }
        $Binding = New-BTBinding -Children $Title, $Info
        $Visual = New-BTVisual -BindingGeneric $Binding
        $Content = New-BTContent -Visual $Visual -Actions $Action
        Submit-BTNotification -Content $Content -AppId "Otto Zumkeller.QR-Code Reader"
    }
}
Start-Process -FilePath ".\key_listener.exe"
