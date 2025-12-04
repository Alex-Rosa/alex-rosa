# Organized into the "Software Development Lifecycle" (SDLC)

# ==============================================================================
# PHASE 0: SETUP & UTILITIES
# Use these once or for script helpers.
# ==============================================================================

# Login to GitHub CLI
# Usage: Run once when setting up a new computer or if your token expires.
gh_login() {
    gh auth login
}

# Parse Current Git Branch
# Usage: Mostly a helper function for other scripts or your terminal prompt 
# to show which branch you are currently on.
parse_git_branch() {
    # Run the check silently (redirecting both stdout and stderr)
    git rev-parse --is-inside-work-tree &> /dev/null
    
    # Check the exit code of the previous command (0 = Success, Non-zero = Fail)
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
gb() {
    git branch --all --list --verbose --verbose
}

# Show Git Status
# Usage: Run this FREQUENTLY. Run it before you add, before you commit, 
# and before you switch branches. It shows what has changed.
gs() {
    git status --verbose --verbose --untracked-files=all
}

# Git Log Graph
# Usage: Visualize your commit history and branches in a colorful tree structure.
gl() {
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
}

# ==============================================================================
# PHASE 2: BRANCHING (Navigation)
# Use these to create, switch, and manage your workspace.
# ==============================================================================

# Git Checkout (Switch)
# Usage: Switch to an existing branch.
# Example: gco main
gco() {
    git checkout "$1"
}

# Git Checkout New Branch (Create)
# Usage: Creates a new branch off your current location and switches to it.
# Use this when starting a new task.
# Example: gcb "feature/user-login"
gcb() {
    git checkout -b "$1"
}

# Git Branch Delete (Specific)
# Usage: Deletes a specific local branch.
# SAFE MODE: This will fail if the branch has unmerged changes (protecting your work).
# Example: gbd "feature/old-test"
gbd() {
    git branch -d "$1"
}

# Git Branch Rename
# Usage: Renames the CURRENT branch you are standing on.
# Use this if you made a typo in the branch name.
# Example: gbm "feature/login-fixed"
gbm() {
    git branch -m "$1"
}

# ==============================================================================
# PHASE 3: STAGING & COMMITTING (Saving Local Work)
# Use these to "Save" your game locally.
# ==============================================================================

# Git Add (The "Shopping Cart")
# Usage: Run when you are happy with your changes and ready to prepare them for a commit.
ga() {
    git add . --verbose
}

# Undo Last Commit
# Usage: Run if you committed too early. It undoes the commit but KEEPS your work staged.
gundo() {
    git reset --soft HEAD~1
    echo "Last commit undone. Changes are still staged."
}

# Git Commit Dry Run (The "Preview")
# Usage: Run this if you are paranoid/careful. It shows you exactly what *would* happen 
# if you committed right now, without actually doing it.
gcdr() {
    git commit --dry-run --long --all --branch --gpg-sign --verbose --verbose --message "$1"
}

# Git Commit (The "Purchase")
# Usage: Run this to permanently save your staged changes to your local history.
# It automatically GPG signs your work.
# Example: gc "Fixed the login button"
gc() {
    git commit --all --branch --gpg-sign --verbose --verbose --message "$1"
}

# ==============================================================================
# PHASE 4: SYNCING (Uploading to Cloud)
# Use these to move your local saves to GitHub.
# ==============================================================================

# Git Push Dry Run (The "Upload Preview")
# Usage: Run before pushing if you want to ensure you aren't overwriting something 
# unexpected on the server.
gpdr() {
    git push --dry-run --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)" --verbose
}

# Git Push (The "Upload")
# Usage: Sends your committed changes to GitHub.
# It automatically links your local branch to the remote one (upstream).
gp() {
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)" --verbose
}

# ==============================================================================
# PHASE 5: DELIVERY (Pull Request)
# Use this when your feature is done and ready to merge.
# ==============================================================================

# Create Pull Request
# Usage: Run this after pushing (gp). It opens a PR to merge your current branch into 'main'.
# It auto-assigns YOU and adds a label.
# Example: gh_pr "Fix Login" "This updates the submit button logic"
gh_pr() {
    gh pr create --title "$1" --body "$2" --base main --assignee "@me" --label "ready for review"
}

# ==============================================================================
# PHASE 6: MAINTENANCE (Housekeeping)
# Use these to keep your repository clean and synced after merging PRs.
# ==============================================================================

# Git Main Sync
# Usage: Updates your local 'main' branch from the server without switching to it.
gms() {
    git fetch origin main:main
    echo "Local 'main' updated from origin."
}

# Git Branch Cleanup
# Usage: Deletes local branches that have already been merged into main.
gb_clean() {
    git checkout main
    git pull
    git branch --merged | grep -v "\*" | grep -v "main" | xargs -n 1 git branch -d
    echo "Cleaned up merged branches."
}