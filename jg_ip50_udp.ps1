# Define the target IP address and port
$targetIP = "192.168.1.77"
$targetPort = 19740

# Define the message to send
$line_end = "`r`n"
$deactivate = "DEACTIVATE" + $line_end
$pod1on = "POD1ON" + $line_end
$pod1off = "POD1OFF" + $line_end

# Create a new UDP client
$udpClient = New-Object System.Net.Sockets.UdpClient

# Send line feed and carriage return to get to known starting point
$byteData = [Text.Encoding]::UTF8.GetBytes($line_end)
$udpClient.Send($byteData, $byteData.Length, $targetIP, $targetPort)

$out_str = "line end: " + $line_end
Write-Host $out_str

Start-Sleep -Seconds 1

# Deactivate switch 
# $byteData = [Text.Encoding]::UTF8.GetBytes($deactivate)
# $udpClient.Send($byteData, $byteData.Length, $targetIP, $targetPort)

# Start-Sleep -Seconds 2

# Turn on pod 1
$byteData = [Text.Encoding]::UTF8.GetBytes($pod1on)
$udpClient.Send($byteData, $byteData.Length, $targetIP, $targetPort)

$out_str = "pod1 on cmd: $pod1on"
Write-Host $out_str

Start-Sleep -Seconds 1

# Turn off pod 1
$byteData = [Text.Encoding]::UTF8.GetBytes($pod1off)
$udpClient.Send($byteData, $byteData.Length, $targetIP, $targetPort)

$out_str = "pod 1 off cmd: $pod1off"
Write-Host $out_str

# Close the UDP client
$udpClient.Close()
