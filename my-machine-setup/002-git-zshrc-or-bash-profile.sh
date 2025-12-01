#Custom Git Bash Profile
#--- begin
alias reload='source ~/.bash_profile'

# 	set -x # Start debugging and output commands
# 	set +x # Stop debugging

# Function to Parse the Current Git Branch with Error Handling
parse_git_branch() {
    # Check if the current directory is a Git repository
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        # If it is, return the current branch
        git rev-parse --abbrev-ref HEAD
    else
        # If it isn't, return an message
        echo "Not a Git Repository"
    fi
}

# Function to issue Git Status
gs() {
    git status --verbose --verbose --untracked-files=all
}

# Function to issue Git Add
ga() {
    git add . --verbose --ignore-removal
}

# Function to issue signed Git Commit Dry Run (verbose - difference review)
gcdr() {
    git commit --dry-run --long --all --branch --gpg-sign --verbose --verbose --message "$1"
}

# Function to issue signed Git Commit
gc() {
    git commit --all --branch --gpg-sign --verbose --verbose --message "$1"
}

# Function to issue Git Push Dry Run
gpdr() {
    git push --dry-run --set-upstream --verbose
    }

# Function to issue Git Push
gp() {
    git push --set-upstream --verbose
}

# Function to show branch 
gb() {
    git branch --all --list --verbose --verbose
}


PS1='
\[\e[0;33m\] < Date: \[\e[0;32m\]\d \[\e[0;33m\] | Time: \[\e[0;32m\]\t Central Time \[\e[0;33m\] | Working Repo: \[\e[0;36m\]\w \[\e[0;33m\] | Working Branch: \[\e[0;36m\] $(parse_git_branch) \[\e[0;33m\] | Command Number: \[\e[0;32m\] All Sessions \! , This Session \# \[\e[0;33m\] >
\[\e[0m\]\$ '

cd /c/Temp/MyGitRepositories

#Custom Git Bash Profile
#--- end

