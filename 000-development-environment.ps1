# START http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/felixrieseberg/windows-development-environment/master/boxstarter

# To edit your PowerShell profile run 
# notepad.exe $PROFILE

# Fire up CMD.exe as Administrator and run:
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

# Azure CLI
choco install azure-cli

# Azure Developer CLI
choco install azure-azdev

# Powershell
choco install powershell-core

# Azure DevOps CLI
choco install azure-devops

# Python
choco install python
choco install pip

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

