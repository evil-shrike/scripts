#Requires -RunAsAdministrator
function Test-Administrator
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}
if(-not (Test-Administrator))
{
    Write-Error "This script must be executed as Administrator.";
    exit 1;
}
$ErrorActionPreference = "Stop";

Install-PackageProvider ChocolateyGet
Import-PackageProvider ChocolateyGet -Force

# Installing dependencies
$deps = @{
	python3 = 3.7
	nodejs = 12.0
	git = 2.1
}
foreach ($h in $deps.GetEnumerator()) {
    $packageName = $h.Name
    $version = $h.Value
    Write-Host -ForegroundColor DarkGray "Checking $packageName (>=$version)"
    $package = Get-Package $packageName -MinimumVersion $version -Provider ChocolateyGet -ErrorAction SilentlyContinue
	if (-not $package) {
		Write-Host -ForegroundColor DarkGray "$package not found, installing..."
		Install-Package -Name $packageName -Verbose -Provider ChocolateyGet -AcceptLicense
	} else {
		Write-Host -ForegroundColor Green "    Found" $package.Name ":" $package.Version
	}
}
