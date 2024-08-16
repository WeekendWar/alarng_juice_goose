# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Juice Goose Power"
$form.Size = New-Object System.Drawing.Size(400, 460)

# Create a button
$allOnBtn = New-Object System.Windows.Forms.Button
$allOnBtn.Text = "All On"
$allOnBtn.Location = New-Object System.Drawing.Point(25, 40)
$allOnBtn.Size = New-Object System.Drawing.Size(100, 30)

# Create a button
$allOffBtn = New-Object System.Windows.Forms.Button
$allOffBtn.Text = "All Off"
$allOffBtn.Location = New-Object System.Drawing.Point(155, 40)
$allOffBtn.Size = New-Object System.Drawing.Size(100, 30)

# Create a checkbox
$delaysEnCheck = New-Object System.Windows.Forms.CheckBox
$delaysEnCheck.Text = "Enable Delays"
$delaysEnCheck.Location = New-Object System.Drawing.Point(275, 40)

# Create an output text box
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(25, 100)
$outputBox.Size = New-Object System.Drawing.Size(350, 300)
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Text = "Command Logging:`r`n"

# Add an event handler for the button click event
$allOnBtn.Add_Click({
  $scriptPath = ".\ip50_pwr.ps1"
  # $param = $textbox.Text
  $dev = "ALL"
  $pod = "ALL"
  $cmd = "on"

  & $scriptPath -dev $dev -pod $pod -cmd $cmd -delay $delaysEnCheck.Checked
  $outputBox.AppendText("All Power On`r`n")
})

$allOffBtn.Add_Click({
  $scriptPath = ".\ip50_pwr.ps1"
  # $param = $textbox.Text
  $dev = "ALL"
  $pod = "ALL"
  $cmd = "off"
  & $scriptPath -dev $dev -pod $pod -cmd $cmd -delay $delaysEnCheck.Checked
  $outputBox.AppendText("All Power Off`r`n")
})

# Add the button to the form
$form.Controls.Add($allOnBtn)
$form.Controls.Add($allOffBtn)
$form.Controls.Add($delaysEnCheck)
$form.Controls.Add($outputBox)

# Show the form
$form.ShowDialog()
