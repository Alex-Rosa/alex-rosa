# Yes, organizing your .zshrc by "Execution Order" and "Logical Grouping" prevents weird errors (like the system not finding a command because the PATH hasn't been set yet).
# Here is the recommended logic for the order:
# Environment Variables: (Editors, Language settings, GPG) — Set the ground rules first.
# System Paths (Homebrew): Initialize the core system tools so subsequent commands can find them.
# User Paths: Add your custom script folders.
# Tool Initialization (Conda): Initialize heavy environment managers.
# Aliases & Functions: Load your shortcuts and external scripts.
# Visuals/Prompt: Configure how the terminal looks (this goes last because it might rely on Git or tools loaded in previous steps).

# ==============================================
# 1. ENVIRONMENT VARIABLES & SETTINGS
# ==============================================
# Set default editors
export EDITOR='nano'
export VISUAL='code'

# GPG Signing requirement
export GPG_TTY=$(tty)

# Debugging (Keep commented unless needed)
# set -x # Start debugging
# set +x # Stop debugging

# ==============================================
# 2. PATH & SYSTEM INITIALIZATION (Homebrew)
# ==============================================
# Ensure Homebrew is loaded FIRST so system tools are available
# (Standard for Mac Silicon /opt/homebrew)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add Java (OpenJDK) to PATH
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Add your specific Git Repo scripts folder to the PATH
# This allows you to run executable scripts located in this folder
export PATH="$HOME/MyFiles/MyGitRepository/alex-rosa/my-scripts:$PATH"

# ==============================================
# 3. PACKAGE MANAGERS (Conda)
# ==============================================
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ==============================================
# 4. ALIASES & CUSTOM FUNCTIONS
# ==============================================
alias reload='source ~/.zshrc'

# Load custom Git functions from MyFiles
# Note: Using $HOME instead of ~ is safer inside scripts/variables
CUSTOM_GIT_FUNCTIONS="$HOME/MyFiles/MyGitRepository/alex-rosa/my-scripts/my-git-functions.sh"

if [ -f "$CUSTOM_GIT_FUNCTIONS" ]; then
    source "$CUSTOM_GIT_FUNCTIONS"
else
    echo "Warning: Could not find custom Git functions at $CUSTOM_GIT_FUNCTIONS"
fi

# ==============================================
# 5. PROMPT & VISUALS
# ==============================================
# Load colors
autoload -U colors && colors
setopt PROMPT_SUBST

# Function to get current Git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Prompt Definition
# Structure: < Date | Time | Path | Branch | History >
PROMPT='
%F{yellow}< Date: %F{green}%D{%a %b %d} %F{yellow}| Time: %F{green}%T %F{yellow}| Path: %F{cyan}%~ %F{yellow}| Branch: %F{cyan}$(parse_git_branch) %F{yellow}| History: %F{green}%! %F{yellow}>%f
$ '