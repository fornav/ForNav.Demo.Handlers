# Notepad handler
$inputfile = $args[0]
$package = Get-Content -Raw $inputfile

# Save message to temp file
$tmpFile = New-TemporaryFile
Set-Content -Path $tmpFile -Value $package

# Start Notepad
Start-Process 'C:\windows\system32\notepad.exe' -ArgumentList $tmpFile 