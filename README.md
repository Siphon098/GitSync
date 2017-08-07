# git-sync-batch
A batch script to sync and clean multiple repo directories quickly.

# Setup
- Place "gitsync.bat" into the directory containing your repos.
- Edit the file and update the "default" variable to use your directories.

# Usage
- `gitsync [command] [directory|branch] [option]`
- Arguments cannot contain spaces.
- Just `gitsync` will prompt you for the arguments one at a time.

## Commands
- `checkout` - Checkout the specified branch.
- `pull`     - Run git pull on the repo.
- `prune`    - Remove local references to deleted branches on remote.
- `all`      - Run "checkout [branch]" -> "pull" -> "prune", in this order.
- `delete`   - **WARNING! MAY DELETE UNSAVED CHANGES!** Prompt for deletion of local branches. (Always excludes master and the active branch)

## Options
- `-b [branch]` - Use this branch.
- `-f`          - Force deletion without prompt.

# Examples
- `gitsync checkout master` - Checkout master for all default directories.
- `gitsync checkout git_dir -b some_branch` - Checkout some_branch for "git_dir" directory.
- `gitsync pull` - Pull all default directories.
- `gitsync prune git_dir` - Prune only "git_dir" directory.
- `gitsync delete` - Prompt for deletion for all possible branches within all default directories.
- `gitsync delete -f` - Delete all branches for all default directories, without prompt.
- `gitsync delete git_dir -f` - Delete all branches for "git_dir" directory, without prompt.
- `gitsync all` - Checkout master, pull, then prune all default directories.
- `gitsync all -b some_branch` - Checkout some_branch, pull, then prune for all default directories.
- `gitsync all git_dir -b some_branch` - Checkout some_branch, pull, then prune the "git_dir" directory.
