# Git Commands Reference

## Configuration

| Command | Description |
|---------|-------------|
| `git config --global user.name "name"` | Set global username |
| `git config --global user.email "email"` | Set global email |
| `git config --list` | List all config settings |
| `git config --global core.editor "vim"` | Set default editor |

## Repository Setup

| Command | Description |
|---------|-------------|
| `git init` | Initialize a new repository |
| `git clone <url>` | Clone a remote repository |
| `git clone <url> <dir>` | Clone into specific directory |

## Basic Workflow

| Command | Description |
|---------|-------------|
| `git status` | Check working tree status |
| `git add <file>` | Stage a file |
| `git add .` | Stage all changes |
| `git add -A` | Stage all changes (including deletions) |
| `git commit -m "message"` | Commit staged changes |
| `git commit -am "message"` | Stage and commit tracked files |
| `git commit --amend` | Amend last commit |

## Branching

| Command | Description |
|---------|-------------|
| `git branch` | List local branches |
| `git branch -a` | List all branches (local + remote) |
| `git branch <name>` | Create a new branch |
| `git branch -d <name>` | Delete a branch |
| `git branch -D <name>` | Force delete a branch |
| `git checkout <branch>` | Switch to a branch |
| `git checkout -b <branch>` | Create and switch to a new branch |
| `git switch <branch>` | Switch to a branch (modern) |
| `git switch -c <branch>` | Create and switch (modern) |

## Merging & Rebasing

| Command | Description |
|---------|-------------|
| `git merge <branch>` | Merge a branch into current |
| `git merge --abort` | Abort a merge in progress |
| `git rebase <branch>` | Rebase current branch onto another |
| `git rebase --abort` | Abort a rebase |
| `git rebase --continue` | Continue after resolving conflicts |

## Remote Repositories

| Command | Description |
|---------|-------------|
| `git remote -v` | List remote repositories |
| `git remote add <name> <url>` | Add a new remote |
| `git remote remove <name>` | Remove a remote |
| `git remote rename <old> <new>` | Rename a remote |
| `git fetch` | Fetch from all remotes |
| `git fetch <remote>` | Fetch from specific remote |
| `git pull` | Fetch and merge from remote |
| `git pull --rebase` | Fetch and rebase from remote |
| `git push` | Push to remote |
| `git push -u origin <branch>` | Push and set upstream |
| `git push --force` | Force push (use with caution) |
| `git push --force-with-lease` | Safe force push |

## Stashing

| Command | Description |
|---------|-------------|
| `git stash` | Stash working changes |
| `git stash save "message"` | Stash with a message |
| `git stash list` | List all stashes |
| `git stash pop` | Apply and remove latest stash |
| `git stash apply` | Apply latest stash (keep it) |
| `git stash drop` | Delete latest stash |
| `git stash clear` | Delete all stashes |

## History & Log

| Command | Description |
|---------|-------------|
| `git log` | View commit history |
| `git log --oneline` | Compact one-line log |
| `git log --graph` | Log with branch graph |
| `git log --stat` | Log with file change stats |
| `git log -n 5` | Show last 5 commits |
| `git log --author="name"` | Filter by author |
| `git log --since="2024-01-01"` | Filter by date |
| `git shortlog -sn` | Commit count per author |
| `git blame <file>` | Show who changed each line |
| `git show <commit>` | Show commit details |

## Undoing Changes

| Command | Description |
|---------|-------------|
| `git checkout -- <file>` | Discard changes in a file |
| `git restore <file>` | Discard changes (modern) |
| `git restore --staged <file>` | Unstage a file |
| `git reset HEAD <file>` | Unstage a file (legacy) |
| `git reset --soft HEAD~1` | Undo last commit, keep changes staged |
| `git reset --mixed HEAD~1` | Undo last commit, keep changes unstaged |
| `git reset --hard HEAD~1` | Undo last commit, discard all changes |
| `git revert <commit>` | Create a commit that undoes a previous commit |

## Diff

| Command | Description |
|---------|-------------|
| `git diff` | Diff of unstaged changes |
| `git diff --staged` | Diff of staged changes |
| `git diff <branch1> <branch2>` | Diff between two branches |
| `git diff <commit1> <commit2>` | Diff between two commits |
| `git diff --stat` | Summary of changed files |

## Tags

| Command | Description |
|---------|-------------|
| `git tag` | List all tags |
| `git tag <name>` | Create a lightweight tag |
| `git tag -a <name> -m "msg"` | Create an annotated tag |
| `git tag -d <name>` | Delete a tag locally |
| `git push origin <tag>` | Push a tag to remote |
| `git push origin --tags` | Push all tags to remote |

## Cleaning

| Command | Description |
|---------|-------------|
| `git clean -n` | Dry run - show untracked files to remove |
| `git clean -f` | Remove untracked files |
| `git clean -fd` | Remove untracked files and directories |
| `git clean -fX` | Remove only ignored untracked files |

## Cherry-Pick

| Command | Description |
|---------|-------------|
| `git cherry-pick <commit>` | Apply a specific commit |
| `git cherry-pick <c1> <c2>` | Apply multiple commits |
| `git cherry-pick --abort` | Abort cherry-pick in progress |

## Submodules

| Command | Description |
|---------|-------------|
| `git submodule add <url>` | Add a submodule |
| `git submodule init` | Initialize submodules |
| `git submodule update` | Update submodules |
| `git submodule update --init --recursive` | Init and update recursively |

## Bisect

| Command | Description |
|---------|-------------|
| `git bisect start` | Start bisect session |
| `git bisect bad` | Mark current commit as bad |
| `git bisect good <commit>` | Mark a known good commit |
| `git bisect reset` | End bisect session |

## Aliases (Optional Setup)

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.lg "log --oneline --graph --all"
git config --global alias.last "log -1 HEAD"
git config --global alias.unstage "reset HEAD --"
```

## .gitignore Patterns

| Pattern | Description |
|---------|-------------|
| `*.log` | Ignore all .log files |
| `build/` | Ignore entire build directory |
| `!important.log` | Negate - do not ignore this file |
| `*.tmp` | Ignore all .tmp files |
| `doc/**/*.pdf` | Ignore all .pdf files in doc/ |
