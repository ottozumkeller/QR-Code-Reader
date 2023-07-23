Set-Location "C:\Program Files (x86)\QR-Code Reader"
Start-Process "ms-screenclip:"

Start-Sleep -Seconds 2.0
Start-Process -FilePath ".\key.exe"
Wait-Process "ScreenClippingHost"

# Set directory for screenshots
$Screenshots = "$([Environment]::GetFolderPath("MyPictures"))\Screenshots"
# Get all files in screenshots directory, sort them by creation time and return the path of the first one (e.g. the newest)
$Latest = Get-ChildItem -Path $Screenshots | Sort-Object CreationTime -Descending | Select-Object -First 1 -ExpandProperty FullName
    
# True if File is not older than 3 Seconds
Try {
    $Check = !(Test-Path $Latest -OlderThan (Get-Date).AddSeconds(-3))
} Catch {
    $Check = $False
}
if ($Check) {
    $Title_String = & .\zbarimg.exe -q --raw $Latest
    $Info_String = "wurde in die Zwischenablage kopiert"
    if ($Title_String) {
        Set-Clipboard -Value $Title_String
    } else {
        $Script:Title_String = "Kein QR-Code erkannt!"
        $Script:Info_String = "Bitte w$([char]0x00E4)hlen sie einen vollst$([char]0x00E4)ndigen QR-Code"
    }
    Import-Module BurntToast
    Remove-Item -Path $Latest
    New-BTAppId -AppId "Otto Zumkeller.QR-Code Reader"
    $Title = New-BTText -Text $Title_String
    $Info = New-BTText -Text $Info_String
    $Open = New-BTButton -Content "Link folgen" -Arguments $Title_String
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