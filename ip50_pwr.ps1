param (
  [ValidateSet('R1A', 'R1B', 'R2A', 'R3A', 'R3B', 'ALL', 'All', 'all')]
  [string]$dev,
  
  [ValidateSet('1', '2', 'ALL', 'All', 'all')]
  [string]$pod,
  
  [ValidateSet("on", "On", "ON", "off", "Off", "OFF")]
  [string]$cmd,

  [bool]$delay = $false
)

###############################################################################
# Constants

# Device IP address and port constants
$DEV_PORT = 30333

# IP 50 message constants
$LINE_END = "`r`n"
$POD_STR = "POD"
$ALL_STR = "ALL"

$jg_devices = @('R1A', 'R1B', 'R2A', 'R3A', 'R3B')

$dev_ip_addresses = @{
  'R1A' = '172.22.0.201'
  'R1B' = '172.22.0.202'
  'R2A' = '172.22.0.203'
  'R3A' = '172.22.0.204'
  'R3B' = '172.22.0.205'
}

$jg_delays = @{
  'R1A' = 0
  'R1B' = 2
  'R2A' = 4
  'R3A' = 6
  'R3B' = 8 
  # 'R1B' = 2
  # 'R2A' = 4
  # 'R3A' = 6
  # 'R3B' = 8 
}

###############################################################################
# Helper Functions

function GetDelaySeconds {
  [CmdletBinding()]
  param (
      [ValidateSet('R1A', 'R1B', 'R2A', 'R3A', 'R3B')]
      [string]$dev
  )

  if ($jg_delays.ContainsKey($dev)) {
    $time_delay = $jg_delays[$dev]
    Write-Host "delay for $dev is $time_delay"
    return $jg_delays[$dev]
  }
  else {
      Write-Error -Message "Invalid device. IP address not available" -Category InvalidArgument
  }
}

function GetDevIpAddr {
  [CmdletBinding()]
  param (
      [ValidateSet('R1A', 'R1B', 'R2A', 'R3A', 'R3B')]
      [string]$dev
  )

  if ($dev_ip_addresses.ContainsKey($dev)) {
    return $dev_ip_addresses[$dev]
  }
  else {
      Write-Error -Message "Invalid device. IP address not available" -Category InvalidArgument
  }
}

function SendCommand {
  param (
      [string]$ip_addr,
      [string]$port,
      [string]$cmd
  )

  # Create a new UDP client
  $udpClient = New-Object System.Net.Sockets.UdpClient

  # Send line feed and carriage return to get to known starting point
  $byteData = [Text.Encoding]::UTF8.GetBytes($LINE_END)
  $null = $udpClient.Send($byteData, $byteData.Length, $ip_addr, $port)

  # Send command
  $byteData = [Text.Encoding]::UTF8.GetBytes($cmd)
  $null = $udpClient.Send($byteData, $byteData.Length, $ip_addr, $port)

  # Close the UDP client
  $udpClient.Close()
}

# Function to build command string
function BuildCommand {
  param (
    [string]$pod,
    [string]$cmd
  )

  $cmd_prefix = ""
  if ($pod.ToUpper() -eq "ALL") { 
    $cmd_prefix = $ALL_STR 
  } else {
    $cmd_prefix = $POD_STR + $pod 
  }
  return ($cmd_prefix + $cmd + $LINE_END).ToUpper()
}

###############################################################################

# Show input arguments
Write-Output "Args - dev = $dev, pod = $pod, cmd = $cmd `r`n"

# Determine if all devices are selected
if ($dev.ToUpper() -eq 'ALL') {
  # Iterate over each device in $jg_devices
  foreach ($jg in $jg_devices) {
    # Get device IP address
    $jg_ip = GetDevIpAddr -dev $jg
    
    # Build command
    $command = BuildCommand -pod $pod -cmd $cmd
    SendCommand -ip_addr $jg_ip -port $DEV_PORT -cmd $command
    Write-Output "Message sent to $jg ($jg_ip). Cmd: $command"

    if ($delay) {
      $delay_secs = GetDelaySeconds -dev $jg
      Start-Sleep -Seconds $delay_secs
    }
  }
} else {
  # Get device IP address
  $dev_ip = GetDevIpAddr -dev $dev
  
  # Build command
  $command = BuildCommand -pod $pod -cmd $cmd
  SendCommand -ip_addr $dev_ip -port $DEV_PORT -cmd $command
  Write-Output "Message sent to $dev ($dev_ip). Cmd: $command"
}

# Write-Output "command = $command"
# Write-Host $log_str
