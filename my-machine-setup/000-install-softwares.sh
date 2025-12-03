#-----------------------------------------------
#### Script and Automation Tools
# Install Homebrew for macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# https://brew.sh/
# https://docs.brew.sh/Manpage
# https://docs.brew.sh/

brew list # List installed packages
brew leaves # List installed packages that are not dependencies of other installed packages

# Install PowerShell via Homebrew
# 1. Remove the deprecated version if it partially installed
brew uninstall --cask powershell
# 2. Tap Microsoft's repository
brew tap powershell/tap
# 3. Install PowerShell from there
brew install powershell/tap/powershell
pwsh --version # Check PowerShell version

# Update homebrew as needed and Install Azure CLI via Homebrew
brew update && brew install azure-cli

# Install Azure Developer CLI via Homebrew
brew tap azure/azd && brew install azd

# Add the tap for bicep and install bicep via Homebrew
brew tap azure/bicep && brew install bicep

#### Script and Automation Tools
#-----------------------------------------------

#-----------------------------------------------
#### Source and Version Control Tools
brew install git # Install Git using Homebrew
which git # Check which Git version is being used
# If it says /usr/bin/git, you are using Apple's version.
# If it says /opt/homebrew/bin/git (M1/M2/M3 Mac) or /usr/local/bin/git (Intel Mac), you are already using the correct Homebrew version

# Install GitHub CLI via Homebrew
brew install gh
#### Source and Version Control Tools

# After adding GPG to your system, you can configure Git to use it for signing commits:
brew install pinentry-mac # Install pinentry-mac via Homebrew
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf # Configure GPG to use pinentry-mac
gpgconf --kill gpg-agent # Restart the GPG agent to apply the changes
# Important Note for Terminal Users
# If you are using the default macOS Terminal app, you need to set the GPG_TTY environment variable. Add the following line to your ~/.zshrc or ~/.bash_profile file, depending on your shell
echo 'export GPG_TTY=$(tty)' >> ~/.zshrc # Add GPG_TTY to your shell configuration
source ~/.zshrc # Reload your shell configuration
#-----------------------------------------------

#-----------------------------------------------
#### Low Level Programming Language

# Java installed via Homebrew

#### Low Level Programming Language
#-----------------------------------------------

#-----------------------------------------------
#### High Level Programming Language
# Install Visual Studio Code via Homebrew
brew install --cask visual-studio-code

# Install Python via Homebrew
# brew install python
# Install Anaconda via Anaconda Installer
# download anaconda3  # Data Science (already include Python Standard Library and Conda Package Manager for Python)
conda create --name alrosa_env python=3.11 # Create a new conda environment with Python 3.11
conda activate alrosa_env # Activate the new conda environment
conda install pandas numpy # Install common data science packages  
conda config --set auto_activate_base false # Disable auto activation of base environment
conda deactivate # Deactivate the conda environment when done
# Command -> Goal
conda env list #List all environments
conda env remove --name my_env_name # Delete an environment
conda create --name new_env --clone old_env # Clone an environment
conda env export > environment.yml # Export list of packages

brew install go # Install Go via Homebrew
go version # Check Go version

#### High Level Programming Language
#-----------------------------------------------

#-----------------------------------------------
#### Web Programming Language

#Javascript

#### Web Programming Language
#-----------------------------------------------


# Ruby
# Even if you don't care about Ruby at all, bear in mind that it's preinstalled on OS X (and easy to install on Unix), 
# so many dev tools might be trying to leverage it. For example, GitHub pages are compiled using Jekyll - if you want to get in on that, install Ruby.
#choco install ruby
#choco install ruby.devkit

# .NET Core SDK
#winget search Microsoft.DotNet.SDK
#winget install Microsoft.DotNet.SDK.9
#choco install dotnetcore-sdk 9
