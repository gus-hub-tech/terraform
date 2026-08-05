# GitMe.md - Setting Up a GitHub Repository from the Command Line

## Prerequisites

- **Git** installed ([git-scm.com](https://git-scm.com/downloads))
- **GitHub account** ([github.com](https://github.com))
- **GitHub CLI** (`gh`) installed ([cli.github.com](https://cli.github.com))

---

## Step 1: Install and Authenticate GitHub CLI

```bash
# Install gh CLI (macOS)
brew install gh

# Install gh CLI (Linux - Ubuntu/Debian)
sudo apt install gh

# Authenticate with GitHub
gh auth login
```

Follow the interactive prompts to select GitHub.com, HTTPS, and authenticate via browser or token.

---

## Step 2: Create a Local Project Directory

```bash
# Create a new project folder
mkdir my-project

# Navigate into it
cd my-project

# Initialize a Git repository
git init
```

---

## Step 3: Create a `.gitignore` File

```bash
# Create a .gitignore file
touch .gitignore
```

Add common ignore patterns (example for Python):

```gitignore
# Python
__pycache__/
*.py[cod]
venv/
.env

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
```

---

## Step 4: Create Files and Make Initial Commit

```bash
# Create your project files
touch README.md

# Stage all files
git add .

# Commit with a message
git commit -m "Initial commit"
```

---

## Step 5: Create the Remote GitHub Repository

```bash
# Create a public repo (default)
gh repo create my-project --public --source=. --remote=origin --push

# OR create a private repo
gh repo create my-project --private --source=. --remote=origin --push
```

### Command Breakdown

| Flag | Description |
|------|-------------|
| `my-project` | Name of the repository |
| `--public` or `--private` | Visibility setting |
| `--source=.` | Uses the current directory as source |
| `--remote=origin` | Names the remote `origin` |
| `--push` | Pushes existing commits after creation |

### Alternative: Create Without Pushing

```bash
# Create repo on GitHub without pushing
gh repo create my-project --public

# Add remote manually
git remote add origin https://github.com/<username>/my-project.git

# Push to remote
git push -u origin main
```

---

## Step 6: Verify the Remote Connection

```bash
# List configured remotes
git remote -v

# Expected output:
# origin  https://github.com/<username>/my-project.git (fetch)
# origin  https://github.com/<username>/my-project.git (push)
```

---

## Step 7: Push to GitHub

```bash
# Set the default branch name (if not already set)
git branch -M main

# Push and set upstream tracking
git push -u origin main
```

---

## Step 8: Clone an Existing Repository (Alternative)

```bash
# Clone a repo you just created
gh repo clone <username>/my-project

# OR using git directly
git clone https://github.com/<username>/my-project.git

# Navigate into it
cd my-project
```

---

## Common Workflow After Setup

```bash
# Create a new branch for a feature
git checkout -b feature/new-feature

# Make changes, then stage and commit
git add .
git commit -m "Add new feature"

# Push the new branch
git push -u origin feature/new-feature

# Create a pull request
gh pr create --title "Add new feature" --body "Description of changes"

# List open PRs
gh pr list

# Merge a PR
gh pr merge <pr-number>
```

---

## Useful Git Commands Reference

| Command | Description |
|---------|-------------|
| `git status` | Check working tree status |
| `git log --oneline` | View commit history |
| `git diff` | View unstaged changes |
| `git pull` | Fetch and merge remote changes |
| `git fetch` | Download remote changes without merging |
| `git stash` | Temporarily store uncommitted changes |
| `git stash pop` | Reapply stashed changes |
| `git branch -a` | List all branches |
| `git tag v1.0` | Create a tag |
| `git push --tags` | Push all tags to remote |

---

## Troubleshooting

### Authentication Errors
```bash
# Re-authenticate
gh auth logout
gh auth login
```

### Push Rejected (Remote Has Changes)
```bash
# Pull remote changes first, then push
git pull origin main --rebase
git push origin main
```

### Wrong Default Branch Name
```bash
# Rename current branch to main
git branch -M main
git push -u origin main
```

### Reset Remote to Match Local
```bash
# WARNING: This overwrites the remote repository
git push --force origin main
```
