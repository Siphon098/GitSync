# git-sync-batch
A batch script to sync and clean multiple repo directories quickly.

# Setup
- Place "gitsync.bat" into the directory containing your repos.
- Edit the file and update the "default" variable to use your directories.

# Usage
`gitsync [command] [directories] [option]`

## Commands
- `master` - Checkout to the master branch.
- `pull`   - Run git pull on the repo.
- `prune`  - Remove local references to delete branches on remote.
- `all`    - Run "master" -> "pull" -> "prune", in this order.
- `delete` - **WARNING! MAY DELETE UNSAVED CHANGES!** Prompt for deletion of local branches.

## Options
- `-f`     - Force deletion without prompt

