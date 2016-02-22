# git-sync-batch
A batch script to sync and clean multiple repo directories quickly.

# Setup
- Place "gitsync.bat" into the directory containing your repos.
- Edit the file and update the "default" variable to use your directories.

# Usage
`gitsync [command] [directories] [option]`

## Commands
- `master` - checkout to the master branch.
- `pull`   - run git pull on the repo.
- `prune`  - remove local references to delete branches on remote.
- `all`    - run "master" -> "pull" -> "prune", in this order.
- `delete` - **WARNING! MAY DELETE UNSAVED CHANGES!** prompt for deletion of local branches.

## Options
- `-f`     - force deletion without prompt

