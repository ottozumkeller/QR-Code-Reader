' USAGE:
' 1. Save the script on your desktop
' 2. Drag-and-drop an MSI file onto the script
' 3. This should display the product code inside that MSI file in a message box

On Error Resume Next
Const msiOpenDatabaseModeReadOnly = 0

Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer")
Dim productcode

' Verify incoming drag and drop arguments
If WScript.Arguments.Count = 0 Then MsgBox "Drag and drop an MSI file onto the VBScript" End If
filename = Wscript.Arguments(0)
If (Right (LCase(filename),3) <> "msi") Then 
   WScript.Quit
End If

Dim database : Set database = installer.OpenDatabase(filename, msiOpenDatabaseModeReadOnly)
Dim view, record

Set view = database.OpenView("SELECT * FROM Property Where Property='ProductCode'")
view.Execute
Do
    Set record = view.Fetch
    If record Is Nothing Then Exit Do
    productcode = record.StringData(2)
Loop

MsgBox "Product Code: " + CStr(productcode) + vbNewLine + vbNewLine + "Filename: " & filename, vbOKOnly, "Product Code:" 

Set view = Nothing
