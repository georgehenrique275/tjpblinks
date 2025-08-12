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

# Carregar bibliotecas do WinForms e Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Criar a janela
$form = New-Object System.Windows.Forms.Form
$form.Text = "TJPB Links"
$form.Size = New-Object System.Drawing.Size(400, 600)
$form.StartPosition = "CenterScreen"

# Ícone de notificação para balão
$notifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Icon = [System.Drawing.SystemIcons]::Information
$notifyIcon.Visible = $true

# Lista de links (adicione os que quiser)
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
    @{ Name = "Java JRE 8 Full"; Url = "https://download.bell-sw.com/java/8u462+11/bellsoft-jre8u462+11-windows-amd64-full.msi" },
    @{ Name = "Revo Uninstall"; Url = "https://portableapps.com/redir2/?a=RevoUninstallerPortable&s=s&d=pa&f=RevoUninstallerPortable_2.5.8.paf.exe" },
    @{ Name = "Safenet 10.3";   Url = "https://s3-sa-east-1.amazonaws.com/shared-www.validcertificadora.com.br/Downloads/Safenet/Safenet+-x64-10.3.msi" },
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
    @{ Name = "Precatorios"; Url = "https://precatorios.tjpb.jus.br/guacamole/#/" },
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
    @{ Name = "VPN 7.2"; Url = "https://drive.google.com/file/d/1yYQAmKMkiLJ5_nBZv-hCTJUsfmhdVAsE/view?usp=sharing " },
    @{ Name = "VPN 7.4"; Url = "https://links.fortinet.com/forticlient/win/vpnagent" },
    @{ Name = "ASI Index"; Url = "http://10.0.1.68:8080/asi/apresentacao/IndexASI.html" }
    @{ Name = "VAgent"; Url = "https://valid-websocket.s3.amazonaws.com/installer/VAgent-Certificadora-Cliente-Installer_x64_2.0.5.exe" },
    @{ Name = "Reset de Senha Guacamole"; Url = "https://trocasenha.tjpb.jus.br/guacamole" },
    @{ Name = "Reset de Senha Formulario"; Url = "https://script.google.com/a/macros/tjpb.jus.br/s/AKfycbx-ghGNC2HWZ6rCPO7eWSl-nFDwKNZyKqwuL7QPeYNZzQPgzJndBLjrxMyJH0EEoX8jjQ/exec" },
    @{ Name = "LibreOffice 25.2.5"; Url = "https://pt-br.libreoffice.org/donate/dl/win-x86_64/25.2.5/pt-BR/LibreOffice_25.2.5_Win_x86-64.msi" },
    @{ Name = "Impressora Virtual"; Url = "\\srv02-print.tjpb.jus.br\Publico\" },
    @{ Name = "Menu Admin"; Url = 'powershell.exe "irm ''http://tiny.cc/MenuAdminTJPBGui'' | iex"' },
    @{ Name = "Instalador Pje Midias"; Url = 'powershell.exe -ExecutionPolicy Bypass -Command "irm ''https://raw.githubusercontent.com/georgehenrique275/script-pjeMidias/refs/heads/main/Sistema%20PJE-MIDIAS.ps1'' | iex"' },
    @{ Name = "Instalador BRBJUS";     Url = 'powershell.exe -ExecutionPolicy Bypass -Command "irm ''https://raw.githubusercontent.com/georgehenrique275/BRB/refs/heads/main/BRB.PS1'' | iex"' }
)

# Caixa de texto para pesquisa
$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Dock = "Top"
$searchBox.Margin = '10,10,10,5'
$searchBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$searchBox.Text = "Pesquisar..."
$searchBox.ForeColor = [System.Drawing.Color]::Gray

# Simular placeholder
$searchBox.Add_GotFocus({
    if ($searchBox.Text -eq "Pesquisar...") {
        $searchBox.Text = ""
        $searchBox.ForeColor = [System.Drawing.Color]::Black
    }
})

$searchBox.Add_LostFocus({
    if ([string]::IsNullOrWhiteSpace($searchBox.Text)) {
        $searchBox.Text = "Pesquisar..."
        $searchBox.ForeColor = [System.Drawing.Color]::Gray
    }
})

# Painel de botões
$panel = New-Object System.Windows.Forms.FlowLayoutPanel
$panel.Dock = "Fill"
$panel.AutoScroll = $true
$panel.FlowDirection = "TopDown"
$panel.WrapContents = $false
$panel.Padding = New-Object System.Windows.Forms.Padding(10)

# Lista de botões
$allButtons = New-Object System.Collections.Generic.List[System.Windows.Forms.Button]

function Load-Buttons($filter = "") {
    $panel.Controls.Clear()
    $allButtons.Clear()

    foreach ($link in $links) {
        if ($link.Name -like "*$filter*") {
            $button = New-Object System.Windows.Forms.Button
            $button.Text = $link.Name
            $button.Size = New-Object System.Drawing.Size(360, 30)
            $button.Margin = New-Object System.Windows.Forms.Padding(5)
            $button.Tag = $link.Url

            # Handle both left and right clicks
            $button.Add_MouseDown({
                param($sender, $e)
                if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
                    # Left-click: Copy to clipboard
                    [System.Windows.Forms.Clipboard]::SetText($this.Tag)
                    $notifyIcon.BalloonTipTitle = "Link copiado"
                    $notifyIcon.BalloonTipText = "O link foi copiado para a área de transferência."
                    $notifyIcon.ShowBalloonTip(1500)
                }
                elseif ($e.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
                    # Right-click: Open in default browser
                    Start-Process $this.Tag
                    $notifyIcon.BalloonTipTitle = "Link aberto"
                    $notifyIcon.BalloonTipText = "O link foi aberto no navegador padrão."
                    $notifyIcon.ShowBalloonTip(1500)
                }
            })

            $panel.Controls.Add($button)
            $allButtons.Add($button)
        }
    }
}

# Atualizar ao digitar
$searchBox.Add_TextChanged({
    $filter = $searchBox.Text.Trim()
    if ($filter -eq "Pesquisar...") { $filter = "" }
    Load-Buttons -filter $filter
})

# Montar janela
Load-Buttons
$form.Controls.Add($panel)
$form.Controls.Add($searchBox)

# Mostrar
$form.ShowDialog()
$notifyIcon.Dispose()

















