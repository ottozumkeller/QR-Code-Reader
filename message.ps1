param(
    [string]$Title_String
)

$Info_String = "wurde in die Zwischenablage kopiert"
if ($Title_String -eq "") { 
    $Title_String = "Kein QR-Code erkannt!"
    $Info_String = "Bitte w$([char]0x00E4)hlen sie einen vollst$([char]0x00E4)ndigen QR-Code"
}

New-BTAppId -AppId "Otto Zumkeller.QR-Code Reader"
$Title = New-BTText -Text $Title_String
$Info = New-BTText -Text $Info_String
$Close = New-BTButton -Dismiss
$Binding = New-BTBinding -Children $Title, $Info
$Visual = New-BTVisual -BindingGeneric $Binding

$Response = Invoke-WebRequest -Uri $Title_String -UseBasicParsing -Method Head
if ($Response.StatusCode -eq 200) {
    $Open = New-BTButton -Content "Link folgen" -Arguments $Title_String
    $Action = New-BTAction -Buttons $Open, $Close
    $Content = New-BTContent -Visual $Visual -Actions $Action
    Submit-BTNotification -Content $Content -AppId "Otto Zumkeller.QR-Code Reader"
} else {
    $Action = New-BTAction -Buttons $Close
    $Content = New-BTContent -Visual $Visual -Actions $Action
    Submit-BTNotification -Content $Content -AppId "Otto Zumkeller.QR-Code Reader"
}