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

# Go config
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

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

# --- Terminal Logging Functions ---

# 1. Archive logs older than 30 days (Compresses to .gz)
# Usage: Runs automatically inside start_log, or type 'archive_logs' manually
function archive_logs() {
    local log_dir="$HOME/MyFiles/MyTerminalHistory"
    
    # Check if directory exists first
    if [ -d "$log_dir" ]; then
        # Find files ending in .log or .txt that are older (+30) than 30 days
        # -exec gzip {} runs compression on each file found
        # gzip replaces the original file with a .gz file automatically
        find "$log_dir" -type f \( -name "*.log" -o -name "*.txt" \) -mtime +30 -exec gzip "{}" \;
    fi
}

# 2. Start a new log session (With auto-archiving)
# Usage: Type 'start_log'
function start_log() {
    # Define the directory
    local log_dir="$HOME/MyFiles/MyTerminalHistory"
    
    # Create directory if it doesn't exist
    if [ ! -d "$log_dir" ]; then
        mkdir -p "$log_dir"
    fi

    # --- Maintenance Step ---
    # Run the archive function silently in the background
    archive_logs &

    # Create filename with current timestamp
    local timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    local log_file="${log_dir}/session_${timestamp}.log"

    echo "🔴 Recording started. Saving to: $log_file"
    echo "Type 'exit' or press Ctrl+D to stop recording."
    
    # Start the script command
    script "$log_file"
}

# 3. Clean up log files (Auto-detects most recent if no file provided)
# Usage: Type 'clean_log' (for newest) OR 'clean_log <filename>'
function clean_log() {
    local log_dir="$HOME/MyFiles/MyTerminalHistory"
    local input_file="$1"

    # --- Scenario A: No filename provided ---
    if [ -z "$input_file" ]; then
        input_file=$(ls -t "${log_dir}"/*.log 2>/dev/null | head -n 1)

        if [ -z "$input_file" ]; then
            echo "❌ Error: No log files found in $log_dir to clean."
            return 1
        fi
        echo "ℹ️  No filename provided. Selecting most recent: $(basename "$input_file")"
    fi

    # --- Scenario B: Validation ---
    if [ ! -f "$input_file" ]; then
        echo "❌ Error: File '$input_file' not found."
        return 1
    fi

    # --- Scenario C: Processing ---
    local output_file="${input_file%.*}_clean.txt"
    cat "$input_file" | col -b | perl -pe 's/\e\[?.*?[\@-~]//g' > "$output_file"

    echo "✅ Cleaned log saved as: $output_file"
}

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