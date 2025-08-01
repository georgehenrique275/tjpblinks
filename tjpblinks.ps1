# Caminho padrão do desktop
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "TJPB Links.lnk"
$iconUrl = "https://raw.githubusercontent.com/georgehenrique275/tjpblinksico/refs/heads/main/icons8-link-94.ico"
$iconPath = "$env:TEMP\tjpblinks.ico"

# Baixar o ícone se ainda não estiver salvo
if (-not (Test-Path $iconPath)) {
    try {
        Invoke-WebRequest -Uri $iconUrl -OutFile $iconPath -UseBasicParsing
    } catch {
        Write-Host "Erro ao baixar o ícone do GitHub." -ForegroundColor Red
    }
}

# Criar atalho diretamente para o PowerShell com comando remoto
if (-not (Test-Path $shortcutPath)) {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
    $shortcut.Arguments = '-WindowStyle Hidden -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/georgehenrique275/tjpblinks/refs/heads/main/tjpblinks.ps1 | iex"'
    $shortcut.Description = "TJPB Links - Aplicação WinForms"
    
    if (Test-Path $iconPath) {
        $shortcut.IconLocation = $iconPath
    }
    
    $shortcut.Save()
    Write-Host "Atalho criado na área de trabalho: TJPB Links.lnk"
} else {
    Write-Host "O atalho já existe. Nenhuma ação necessária."
}

# Load required assemblies for WinForms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "TJPB Links"
$form.Size = New-Object System.Drawing.Size(400, 600)
$form.StartPosition = "CenterScreen"

# Create a panel for buttons
$panel = New-Object System.Windows.Forms.FlowLayoutPanel
$panel.Dock = "Fill"
$panel.AutoScroll = $true
$panel.FlowDirection = "TopDown"
$panel.WrapContents = $false
$panel.Padding = New-Object System.Windows.Forms.Padding(10)

# Define the links and their display names
$links = @(
    @{ Name = "Remoto TJPB"; Url = "https://tiny.cc/remototjpb" },
    @{ Name = "Digitaliza PJE"; Url = "https://tiny.cc/DigitalizaPJE" },
    @{ Name = "Digitaliza Criminal TJPB"; Url = "https://tiny.cc/DigitalizaCriminalTJPB" },
    @{ Name = "Digitalizador IS TJ"; Url = "https://tiny.cc/DigitalizadorISTJ" },
    @{ Name = "DirectX 9"; Url = "https://tiny.cc/directx9" },
    @{ Name = "Firefox TJPB"; Url = "https://tiny.cc/FirefoxTJPB" },
    @{ Name = "Java Fix TJPB"; Url = "https://tiny.cc/JavaFixTJPB" },
    @{ Name = "Java Portable TJPB"; Url = "https://tiny.cc/JavaPortableTJPB" },
    @{ Name = "Kodak 1xx TJPB"; Url = "https://tiny.cc/kodak1xxtjpb" },
    @{ Name = "Movie Maker TJPB"; Url = "https://tiny.cc/MovieMakerTJPB" },
    @{ Name = "My MP4 Box TJPB"; Url = "https://tiny.cc/MyMp4BoxTJPB" },
    @{ Name = "PJE Mídias TJPB"; Url = "https://tiny.cc/PJEMidiasTJPB" },
    @{ Name = "Google Drive File"; Url = "https://drive.google.com/file/d/1e2I64Ob0gGlIWs9KHbeQhUtRXmPkHK_c/view?usp=drive_link" },
    @{ Name = "PJE Office TRF3"; Url = "https://pjeoffice.trf3.jus.br/" },
    @{ Name = "STI TJPB"; Url = "https://tiny.cc/STITJPB" },
    @{ Name = "Sistemas JUD"; Url = "https://tiny.cc/SistemasJUD" },
    @{ Name = "Fortinet Product Downloads"; Url = "https://www.fortinet.com/support/product-downloads" },
    @{ Name = "Netfx3 TJPB"; Url = "https://tiny.cc/Netfx3TJPB" },
    @{ Name = "Google Drive Folder"; Url = "https://drive.google.com/drive/folders/1VOmCcMIcuYOFi4Z-WTG-YDSyPjhofGrL" },
    @{ Name = "CNJ Corporativo"; Url = "https://www.cnj.jus.br/corporativo/" },
    @{ Name = "Google Contacts Directory"; Url = "https://contacts.google.com/directory" },
    @{ Name = "Lexmark MX620"; Url = "https://tiny.cc/LexmarkMX620" },
    @{ Name = "Canon Support"; Url = "https://sg.canon/en/support/0101103903" },
    @{ Name = "Canon Maxify GX7010"; Url = "https://www.cla.canon.com/cla/en/consumer/products/printers_multifunction/refill_built_in_ink_tank/maxify_gx7010#driversAndSoftwareTab" },
    @{ Name = "Token EPASS2003 TJPB"; Url = "https://tiny.cc/TokenEPASS2003TJPB" },
    @{ Name = "Epass Admin TJPB"; Url = "https://tiny.cc/EpassAdminTJPB" },
    @{ Name = "Token GD Old"; Url = "http://tiny.cc/TokenGDold" },
    @{ Name = "Certisign Desktop ID"; Url = "https://www.certisign.com.br/duvidas-suporte/downloads/desktopid" },
    @{ Name = "Token Safenet x32 TJPB"; Url = "https://tiny.cc/TokenSafenetx32TJPB" },
    @{ Name = "Token Safenet x64 TJPB"; Url = "https://tiny.cc/TokenSafenetx64TJPB" },
    @{ Name = "Soluti Suporte A3"; Url = "https://soluti.com.br/duvidas-e-suporte/suporte-certificado-a3/" },
    @{ Name = "Safesign GDA Download"; Url = "https://safesign.gdamericadosul.com.br/download" },
    @{ Name = "Facilitador DITEC"; Url = "https://tiny.cc/FacilitadorDITEC" },
    @{ Name = "TJPB WIFI"; Url = "https://tiny.cc/TJPBWIFI" },
    @{ Name = "Remote ID Certisign"; Url = "https://remoteidcertisign.com.br/manager/#/login" },
    @{ Name = "JD TRF5"; Url = "http://jd.trf5.jus.br/jd/login.wsp" },
    @{ Name = "SAO PJE Reports"; Url = "https://reports.tjpb.jus.br/saopje/index.jsp" },
    @{ Name = "Status Sistemas TJPB"; Url = "https://statusdesistemas.tjpb.jus.br/status/sistemastjpb" },
    @{ Name = "VPN TJPB"; Url = "https://tiny.cc/VPNTJPB" },
    @{ Name = "ASI Index"; Url = "http://10.0.1.68:8080/asi/apresentacao/IndexASI.html" }
)

# Create buttons for each link
foreach ($link in $links) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $link.Name
    $button.Size = New-Object System.Drawing.Size(360, 30)
    $button.Margin = New-Object System.Windows.Forms.Padding(5)
    $button.Tag = $link.Url
    $button.Add_Click({ Start-Process $this.Tag })
    $panel.Controls.Add($button)
}

# Add panel to form
$form.Controls.Add($panel)

# Show the form
$form.ShowDialog()
