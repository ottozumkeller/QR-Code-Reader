Start-Process "ms-screenclip:"

Start-Sleep -Seconds 1.0
Wait-Process "ScreenClippingHost"

$Name = "temp.png"
$Image = Get-Clipboard -Format Image
if ($Image) {
    $Image.Save($Name)

    $Title_String = & .\ZBar\zbarimg.exe -q --raw $Name
    $Info_String = "was copied to clipboard"
    if ($Title_String) {
        Set-Clipboard -Value $Title_String
    } else {
        $Script:Title_String = "No QR-Code detected!"
        $Script:Info_String = "Please select a complete QR-Code"
    }
    Remove-Item -Path $Name

    Import-Module $PSScriptRoot\BurntToast
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
Start-Process -FilePath ".\AutoHotkey\key.exe"