# Install WinGet on Windows Sandbox
# https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager
Write-Host "Done."

# To search for a tool, type winget search <appname>.
# After you have confirmed that the tool you want is available, you can install the tool by typing winget install <appname>. 
# The WinGet tool will launch the installer and install the application on your PC.
# winget --help

# START http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/felixrieseberg/windows-development-environment/master/boxstarter

# To edit your PowerShell profile run 
# notepad.exe $PROFILE

# Chocolatey - Fire up CMD.exe as Administrator and run:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Enable PowerShell to execute scripts
Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Version Control: Git
# Obviously. If you want Git to be able to save credentials (so you don't have to enter SSH keys / passwords every single time you do anything), 
# use the git.install package, which also installs the Git Credential Manager for Windows.
choco install git.install 

# GitHub CLI
choco install gh

# Code Editors: VS Code
choco install visualstudiocode

# Visual Studio
choco install visualstudio2022community

# Azure CLI
choco install azure-cli

# Azure Developer CLI
choco install azure-azdev

# Powershell
choco install powershell 7

# Azure DevOps CLI
choco install azure-devops

# Python
choco install python
choco install pip

# Java
winget search Microsoft.OpenJDK
winget install Microsoft.OpenJDK.21

# Windows Terminal
#choco install microsoft-windows-terminal
#choco install oh-my-posh

# Node and npm
# A bunch of tools are powered by Node and installed via npm. This applies to you even if you don't care about Node development. 
# If you want to install tools for React, Azure, TypeScript, or Cordova, you'll need this.
#choco install nodejs.install

# Ruby
# Even if you don't care about Ruby at all, bear in mind that it's preinstalled on OS X (and easy to install on Unix), 
# so many dev tools might be trying to leverage it. For example, GitHub pages are compiled using Jekyll - if you want to get in on that, install Ruby.
#choco install ruby
#choco install ruby.devkit

# .NET Core SDK
#winget search Microsoft.DotNet.SDK
#winget install Microsoft.DotNet.SDK.9
#choco install dotnetcore-sdk 9
