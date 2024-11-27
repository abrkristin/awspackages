$App_Name = "windows_exporter"
$app = Get-WmiObject -Class Win32_Product -Filter "Name LIKE '$App_Name'"
if ($app -ne $null) {
    $result = $app.Uninstall()
    if ($result.ReturnValue -eq 0) {
        Write-Host "$($app.Name) successfully uninstalled."
    } else {
        Write-Host "Failed to uninstall $($app.Name). Error code: $($result.ReturnValue)"
    }
} else {
    Write-Host "Application not found."
}
