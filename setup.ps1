$scriptPath = $PSScriptRoot
Write-Host "脚本路径: $scriptPath"
cd $scriptPath

# PowerShell
# Check if we are running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # We are not running "as Administrator" - so relaunch as administrator
    Write-Host "非管理员，按回车尝试以管理员身份重试"
    pause
    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";
    $newProcess.WorkingDirectory = $currentPath.Path

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
}

Write-Host "Installing mitmproxy..."
Start-Process pip -ArgumentList "install mitmproxy" -NoNewWindow -Wait

$certPath = "$env:USERPROFILE\.mitmproxy\mitmproxy-ca-cert.cer"
Write-Host "证书路径：$certPath"
Write-Host "检查证书是否存在"

if (Test-Path $certPath) {
    Copy-Item $certPath -Destination '.\mitmproxy-ca-cert.cer'
} 
else {
    Write-Host "证书不存在，请手动查找证书并将其复制到当前目录（$scriptPath）下"
    pause
}

Write-Host "安装证书"
Get-ChildItem
Start-Process certutil -ArgumentList "-addstore root .\mitmproxy-ca-cert.cer" -NoNewWindow -Wait
pause
