param(
    [string]$Title_String
)

$Info_String = "was copied to clipboard"
if ($Title_String -eq "") { 
    $Title_String = "No QR-Code detected!"
    $Info_String = "Please select a complete QR-Code"
    $Title = New-BTText -Text $Title_String
    $Info = New-BTText -Text $Info_String
    $Button_New = New-BTButton -Content "New Scan" -Arguments "C:\Users\ottoz\Sonstiges\QR-Code Reader\read.bat"
    $Button_Close = New-BTButton -Dismiss
    $Action = New-BTAction -Buttons $Button_New, $Button_Close
    $Binding = New-BTBinding -Children $Title, $Info
    $Visual = New-BTVisual -BindingGeneric $Binding
    $Content = New-BTContent -Visual $Visual -Action $Action
} else {
    $Title = New-BTText -Text $Title_String
    $Info = New-BTText -Text $Info_String
    $Binding = New-BTBinding -Children $Title, $Info
    $Visual = New-BTVisual -BindingGeneric $Binding
    $Content = New-BTContent -Visual $Visual
}
Write-Host $Title_String $Info_String
Submit-BTNotification -Content $Content -AppId "Otto Zumkeller!QR-Code Reader"