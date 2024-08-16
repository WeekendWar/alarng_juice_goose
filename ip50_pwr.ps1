param (
  [ValidateSet('R1A', 'R1B', 'R2A', 'R3A', 'R3B', 'ALL', 'All', 'all')]
  [string]$dev,
  
  [ValidateSet('1', '2', 'ALL', 'All', 'all')]
  [string]$pod,
  
  [ValidateSet("on", "On", "ON", "off", "Off", "OFF")]
  [string]$cmd
)

###############################################################################
# Constants

# Device IP address and port constants
$DEV_PORT = 30333

# IP 50 message constants
$LINE_END = "`r`n"
$POD_STR = "POD"
$ALL_STR = "ALL"
# $ON_STR = "ON"
# $OFF_STR = "OFF"

###############################################################################
# Helper Functions

function GetDevIpAddr {
  [CmdletBinding()]
  param (
      [ValidateSet('R1A', 'R1B', 'R2A', 'R3A', 'R3B')]
      [string]$dev
  )

  $dev_ip_addresses = @{
    'R1A' = '172.22.0.201'
    'R1B' = '172.22.0.202' 
    'R2A' = '172.22.0.203' 
    'R3A' = '172.22.0.204' 
    'R3B' = '172.22.0.205' 
    # 'R1B' = '172.22.0.201' 
    # 'R2A' = '172.22.0.201' 
    # 'R3A' = '172.22.0.201' 
    # 'R3B' = '172.22.0.201' 
  }

  if ($dev_ip_addresses.ContainsKey($dev)) {
    $ip = $dev_ip_addresses[$dev]
    # Write-Output "IP of $dev is $ip`r`n"
    return $ip
  }
  else {
      Write-Error -Message "Invalid device. IP address not available" -Category InvalidArgument
  }
}

function SendCommand {
  param (
      [string]$ip_addr,
      [string]$port,
      # [int32]$pod,
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

  # $out_str = "Sent Command, $cmd, to $ip_addr"
  # Write-Host $out_str

  # Close the UDP client
  $udpClient.Close()
}

###############################################################################

# Show input arguments
Write-Output "dev = $dev"
Write-Output "pod = $pod"
Write-Output "cmd = $cmd"

# $log_str = ""
# if ($dev.ToUpper() -eq 'ALL') {
#   $log_str = "He selected all of them"

#   foreach () {
# Gean start here ...
#   }
# } else {
  $dev_ip = GetDevIpAddr -dev $dev
  Write-Output "lookup: $dev = $dev_ip"

  # Build command
  $cmd_prefix = ""
  if ($pod.ToUpper() -eq "ALL") {
    $cmd_prefix = $ALL_STR
  } else {
    $cmd_prefix = $POD_STR + $pod
  }
  $command = $cmd_prefix + $cmd + $LINE_END
  $command = $command.ToUpper()
  # Write-Output "command = $command"
  
  SendCommand -ip_addr $dev_ip -port $DEV_PORT -cmd $command
  $log_str = "Message sent to $dev ($dev_ip). Cmd: $command"
# }
Write-Host $log_str


