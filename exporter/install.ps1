# Define variables
$script_path = Split-Path $MyInvocation.MyCommand.Path -Parent
$LISTEN_PORT = 9182
$BASIC_PROFILE = "[defaults],cpu_info,logon,memory,tcp,textfile,service"

Write-Output 'Installing Windows Exporter...'

# Check if Windows Exporter service is already installed
$exporterService = Get-Service -Name windows_exporter -ErrorAction SilentlyContinue

if ($exporterService) {
    Write-Output 'Windows Exporter service is already installed.'
    Exit 0
}

try {
    $MSI_FILE = (Get-ChildItem $script_path -Filter "windows_exporter*.msi")[0].FullName
} catch {
    Write-Output "No windows_exporter MSI file found. Downloading from GitHub..."
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($windows_exporter_msi_url, "$script_path\windows_exporter.msi")
    try {
        $MSI_FILE = (Get-ChildItem $script_path -Filter "windows_exporter*.msi")[0].FullName
    } catch {
        Write-Output "No windows_exporter MSI file found. Exiting."
        exit 1
    }
}

# Uninstall any previous versions
$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "windows_exporter" }
if ($null -ne $app) {
    Write-Output "Uninstalling previous windows_exporter..."
    $app.Uninstall() | Out-Null
    # Wait for the uninstallation to complete
    Start-Sleep -Seconds 5
}

Write-Output "Installing $InstallerName with collectors: $BASIC_PROFILE"

# Uninstall any previous versions
$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "windows_exporter" }
if ($null -ne $app) {
    Write-Output "Uninstalling previous windows_exporter"
	$app.Uninstall() | Out-Null
}


# Install Windows Exporter
Write-Output "Installing $MSI_FILE with collectors: $BASIC_PROFILE"
msiexec.exe /i $MSI_FILE ENABLED_COLLECTORS="$BASIC_PROFILE" LISTEN_PORT=$LISTEN_PORT /quiet

Write-Output "Windows Exporter installed. Please check by running:"
Write-Output "curl http://localhost:$LISTEN_PORT/metrics"
