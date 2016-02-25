# git-sync-batch
A batch script to sync and clean multiple repo directories quickly.

# Setup
- Place "gitsync.bat" into the directory containing your repos.
- Edit the file and update the "default" variable to use your directories.

# Usage
- `gitsync [command] [directory] [option]`
- Arguments cannot contain spaces.
- Just `gitsync` will prompt you for the arguments one at a time.

## Commands
- `master` - Checkout to the master branch.
- `pull`   - Run git pull on the repo.
- `prune`  - Remove local references to deleted branches on remote.
- `all`    - Run "master" -> "pull" -> "prune", in this order.
- `delete` - **WARNING! MAY DELETE UNSAVED CHANGES!** Prompt for deletion of local branches. (Always excludes master and the active branch)

## Options
- `-f`     - Force deletion without prompt.

# Examples
- `gitsync all` - Checkout master, pull, then prune all default repos.
- `gitsync prune my-repo` - Prune only 'my-repo'.
- `gitsync delete` - Prompt for deletion for all possible branches within all default repos.
- `gitsync delete my-repo -f` - Delete all branches for 'my-repo' without prompt.

