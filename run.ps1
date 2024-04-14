$scriptPath = $PSScriptRoot
Write-Host "脚本路径: $scriptPath"
cd $scriptPath

# PowerShell
# Check if we are running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # We are not running "as Administrator" - so relaunch as administrator
    Write-Host "非管理员，重试"

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
Start-Process mitmweb -ArgumentList "-s netease.py --mode transparent --allow-hosts service.mkey.163.com" -NoNewWindow -Wait
Read-Host -Prompt "Press Enter to continue"