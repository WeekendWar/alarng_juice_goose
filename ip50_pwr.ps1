###############################################################################
# Input arguments
param (
    [ValidateScript({ $_ -ge 1 -and $_ -le 2 })]
    [int]$pod,

    [ValidateSet("on", "On", "ON", "off", "Off", "OFF")]
    [string]$cmd
)
###############################################################################
# Constants

$MIN_POD_NUM = 1
$MAX_POD_NUM = 2

# Rarget IP address and port constants
$TARGET_IP = "192.168.1.77"
$TARGET_PORT = 19740

# IP 50 message constants
$LINE_END = "`r`n"
# $deactivate = "DEACTIVATE" + $LINE_END
$POD_STR = "POD"
$ON_STR = "ON"
$OFF_STR = "OFF"

###############################################################################
# Show input arguments
# Write-Output "pod = $pod"
# Write-Output "cmd = $cmd"

# Build command
$command = $POD_STR + $pod + $cmd + $LINE_END
$command = $command.ToUpper()
# Write-Output "command = $command"

# Create a new UDP client
$udpClient = New-Object System.Net.Sockets.UdpClient

# Send line feed and carriage return to get to known starting point
$byteData = [Text.Encoding]::UTF8.GetBytes($LINE_END)
$null = $udpClient.Send($byteData, $byteData.Length, $TARGET_IP, $TARGET_PORT)

# Start-Sleep -Seconds 1

# Send command
$byteData = [Text.Encoding]::UTF8.GetBytes($command)
$null = $udpClient.Send($byteData, $byteData.Length, $TARGET_IP, $TARGET_PORT)

$out_str = "Sent Command: $command"
Write-Host $out_str

# Close the UDP client
$udpClient.Close()
