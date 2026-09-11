# Organized into the "Software Development Lifecycle" (SDLC)

# ==============================================================================
# PHASE 0: SETUP & UTILITIES
# Use these to initialize projects or authenticate.
# ==============================================================================

# Login to GitHub CLI
# Usage: Run once when setting up a new computer or if your token expires.
gh_login() {
    gh auth login
}

# ------------------------------------------------------------------------------
# SCENARIO A: "Cloud First" (Starting from scratch)
# ------------------------------------------------------------------------------

# FUNCTION: Create a new public GitHub repo and clone it locally
# Usage: newrepo [repo_name]
# Use this when you have NOTHING and want to start a brand new project.
gh_newrepo() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a repository name."
        echo "Usage: newrepo <repo-name>"
        return 1
    fi
    
    # Creates a public repo, clones it to current directory, and enters the folder
    gh repo create "$1" --public --clone && cd "$1"
}

# ------------------------------------------------------------------------------
# SCENARIO B: "Local First" (Uploading existing code)
# ------------------------------------------------------------------------------

# Git Initialize
# Usage: Turns the current folder into a Git repository.
# Use this if you have a folder of code that isn't in Git yet.
git_i() {
    git init
    git branch -m main # Renames default 'master' to 'main'
    echo "Repo initialized. 'master' renamed to 'main'."
}

# FUNCTION: Connect existing local repo to GitHub
# Usage: Run this inside a folder where you just ran 'git_i'.
# It creates the repo on GitHub and pushes your code up.
gh_connect() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a repository name."
        echo "Usage: gh_connect <repo-name>"
        return 1
    fi
    
    # 1. Create the repo on GitHub (public by default)
    # --source=. tells GitHub to use the current folder
    # --remote=origin connects the local git to the new cloud repo
    gh repo create "$1" --public --source=. --remote=origin
    
    # 2. Push your files
    git push --set-upstream origin main
}

# ------------------------------------------------------------------------------
# UTILITIES
# ------------------------------------------------------------------------------

# Parse Current Git Branch
# Usage: Helper function for prompt customization.
git_branch_parse() {
    git rev-parse --is-inside-work-tree &> /dev/null
    if [ $? -eq 0 ]; then
        git rev-parse --abbrev-ref HEAD
    else
        echo "Not a Git Repository"
    fi
}

# ==============================================================================
# PHASE 1: INSPECTION (Where am I?)
# Use these constantly to understand your context before making changes.
# ==============================================================================

# Show Branch List
# Usage: Run this to see all local/remote branches and confirm which one you are on.
git_b() {
    git branch --all --list --verbose --verbose
}

# Show Git Status
# Usage: Run this FREQUENTLY. Run it before you add, before you commit, 
# and before you switch branches. It shows what has changed.
git_s() {
    git status --verbose --verbose --untracked-files=all
}

# Git Log Graph
# Usage: Visualize your commit history and branches in a colorful tree structure.
git_l() {
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
}

# ==============================================================================
# PHASE 2: BRANCHING (Navigation)
# Use these to create, switch, and manage your workspace.
# ==============================================================================

# Git Checkout (Switch)
# Usage: Switch to an existing branch.
git_co() {
    git checkout "$1"
}

# Git Checkout New Branch (Create)
# Usage: Creates a new branch off your current location and switches to it.
# Use this when starting a new task.
git_cob() {
    git checkout -b "$1"
}

# Git Branch Delete (Specific)
# Usage: Deletes a specific local branch.
# SAFE MODE: This will fail if the branch has unmerged changes (protecting your work).
git_bd() {
    git branch -d "$1"
}

# Git Branch Delete (FORCE)
# Usage: FORCIBLY deletes a branch even if Git thinks it is not merged.
# Use this only when you are sure the code is safe on GitHub (e.g., after a Squash Merge).
git_bD() {
    git branch -D "$1"
}


# Git Branch Rename
# Usage: Renames the CURRENT branch you are standing on.
# Use this if you made a typo in the branch name.
git_bm() {
    git branch -m "$1"
}

# Git Merge (Local)
# Usage: Merges the specified branch INTO your current branch.
# Example: If you are on 'main', run: gm "feature/login"
git_m() {
    git merge "$1" --verbose
}

# Git Checkout PR
# Usage: Downloads a PR from GitHub and switches to it locally.
# Useful if you want to test someone else's code (or your own from another machine).
gh_copr() {
    gh pr checkout "$1"
}

# ==============================================================================
# PHASE 3: STAGING & COMMITTING (Saving Local Work)
# Use these to "Save" your game locally.
# ==============================================================================

# Git Add (The "Shopping Cart")
# Usage: Run when you are happy with your changes and ready to prepare them for a commit.
git_a() {
    git add . --verbose
}

# Undo Last Commit
# Usage: Run if you committed too early. It undoes the commit but KEEPS your work staged.
git_undo() {
    git reset --soft HEAD~1
    echo "Last commit undone. Changes are still staged."
}

# Git Unstage
# Usage: Removes files from the staging area (the "shopping cart") but KEEPS the file changes.
# Use this if you accidentally ran 'git_a' but aren't ready to commit yet.
git_unstage() {
    git reset HEAD
}

# Git Commit Dry Run (The "Preview")
# Usage: Run this if you are paranoid/careful. It shows you exactly what *would* happen 
# if you committed right now, without actually doing it.
git_cdr() {
    git commit --dry-run --long --all --branch --gpg-sign --verbose --verbose --message "$1"
}

# Git Commit (The "Purchase")
# Usage: Run this to permanently save your staged changes to your local history.
# It automatically GPG signs your work.
git_c() {
    git commit --all --branch --gpg-sign --verbose --verbose --message "$1"
}

# ==============================================================================
# PHASE 4: SYNCING (Uploading to Cloud and Downloading from Cloud)
# Use these to move your local saves to GitHub.
# ==============================================================================

# Git Push Dry Run (The "Upload Preview")
# Usage: Run before pushing if you want to ensure you aren't overwriting something 
# unexpected on the server.
git_pdr() {
    git push --dry-run --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)" --verbose
}

# Git Push (The "Upload")
# Usage: Sends your committed changes to GitHub.
# It automatically links your local branch to the remote one (upstream).
git_p() {
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)" --verbose
}

# Git Pull
# Usage: Downloads new changes from GitHub and merges them into your current branch.
# Run this if your teammate pushed code that you need.
git_pl() {
    git pull --verbose
}

# ==============================================================================
# PHASE 5: DELIVERY (Pull Request & Merging)
# Use these to manage the review and merge process via GitHub.
# ==============================================================================

# Create Pull Request (Smart)
# Usage: Opens a PR. Automatically creates the "ready for review" label if missing.
gh_pr() {
    local label="ready for review"
    
    # 1. Try to create the label. 
    # '2>/dev/null' hides the error if it exists. '|| true' keeps the script running.
    gh label create "$label" --color "0e8a16" --description "Good to go" 2>/dev/null || true
    
    # 2. Create the PR using that label
    gh pr create --title "$1" --body "$2" --base main --assignee "@me" --label "$label"
}

# List Pull Requests
# Usage: See all open PRs in this repo. Useful to find the number (e.g., #26).
gh_list() {
    gh pr list
}

# View Pull Request
# Usage: See the status, checks, and comments of the current branch's PR.
gh_view() {
    gh pr view --web
}

# Merge Pull Request (The "Green Button")
# Usage: Merges the current PR via GitHub API.
# It is interactive: it will ask "Create a merge commit? Squash and merge?" just like the UI.
# Note: If you have strict rules, you might need to select "Admin" options if prompted.
gh_merge() {
    gh pr merge --admin
}

# ==============================================================================
# PHASE 6: MAINTENANCE (Housekeeping)
# Use these to keep your repository clean and synced after merging PRs.
# ==============================================================================

# Git Main Sync
# Usage: Updates your local 'main' branch from the server without switching to it.
git_ms() {
    git fetch origin main:main
    echo "Local 'main' updated from origin."
}

# Git Branch Cleanup
# Usage: Deletes local branches that have already been merged into main.
git_bclean() {
    git checkout main
    git pull
    git fetch --prune #-- remove ghost remote branches
    git branch --merged | grep -v "\*" | grep -v "main" | xargs -n 1 git branch -d
    echo "Cleaned up merged branches."
}