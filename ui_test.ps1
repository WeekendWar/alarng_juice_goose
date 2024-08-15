# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Juice Goose Power"
$form.Size = New-Object System.Drawing.Size(400, 450)

# Create a button
$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "Pod1 On"
$button1.Location = New-Object System.Drawing.Point(50, 40)
$button1.Size = New-Object System.Drawing.Size(100, 30)

# Create a button
$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "Pod1 Off"
$button2.Location = New-Object System.Drawing.Point(220, 40)
$button2.Size = New-Object System.Drawing.Size(100, 30)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(25, 100)
$outputBox.Size = New-Object System.Drawing.Size(350, 300)
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$form.Controls.Add($outputBox)

$outputBox.Text = "Command Logging:`r`n"

# Add an event handler for the button click event
$button1.Add_Click({
    $scriptPath = ".\ip50_pwr.ps1"
    # $param = $textbox.Text
    $pod = 1
    $cmd = "on"
    & $scriptPath -pod $pod -cmd $cmd    
    # [System.Windows.Forms.MessageBox]::Show("POD1 On clicked!")
    $outputBox.AppendText("POD 1 Power On`r`n")
})

$button2.Add_Click({
    $scriptPath = ".\ip50_pwr.ps1"
    # $param = $textbox.Text
    $pod = 1
    $cmd = "off"
    & $scriptPath -pod $pod -cmd $cmd    
    # [System.Windows.Forms.MessageBox]::Show("POD1 Off clicked!")
    $outputBox.AppendText("POD 1 Power Off`r`n")
})

# Add the button to the form
$form.Controls.Add($button1)
$form.Controls.Add($button2)

# Show the form
$form.ShowDialog()
