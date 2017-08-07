@echo off
set "default=dir1 dir2 dir3"
set "command="
set "dirs="
set "option="
set "branch="

if [%1]==[] (
	echo Usage: gitsync [command] [directory] [option]
	echo Website: https://github.com/Siphon098/git-sync-batch
	exit /b 1
)

REM set variables using the arguments
set command=%1
set option=%2

REM handle optional dirs argument
if not "%option%" == "" (
	if "%option%" == "-b" (
		set branch=%3
	) else if not "%option:~0,1%" == "-" (
		REM shift the arguments by 1 to include dirs
		set dirs=%2
		set option=%3
		if "%option%" == "-b" (
			set branch=%4
		)
	)
)

REM set default branch as master
if "%branch%" == "" (
	set branch=master
)

REM no dirs given, use default
if "%dirs%" == "" (
	set dirs=%default%
)

REM run the script
if not "%command%" == "" (
	goto :process
)

echo No command given... exiting
exit /b 1

REM the main script starting point
:process
	REM make sure we have a valid command
	set valid=false
	if "%command%" == "checkout" set valid=true
	if "%command%" == "pull" set valid=true
	if "%command%" == "prune" set valid=true
	if "%command%" == "delete" set valid=true
	
	REM run the valid command
	if "%valid%" == "true" (
		for %%a in (%dirs%) do (
			call :%command% %%a
		)
		exit /b 0
	)

	REM run the "all" command
	if "%command%" == "all" (
		for %%a in (%dirs%) do (
			call :checkout %%a
			call :pull %%a
			call :prune %%a
		)
		exit /b 0
	)

	echo Invalid command... exiting
	exit /b 1

REM checkout to specified branch
:checkout
	set dir="%~1"
	if "branch" == "" (
		echo Missing branch option: -b [branch] ... exiting
		exit /b 1
	) else (
		echo git.exe -C %dir% checkout %branch% --
		git.exe -C %dir% checkout %branch% --
	)
	goto :EOF

REM  pull the repo
:pull
	set dir="%~1"
	echo git.exe -C %dir% pull origin --
	git.exe -C %dir% pull origin --
	goto :EOF

REM prune branches that no longer exists in the remote repo
:prune
	set dir="%~1"
	echo git.exe -C %dir% remote prune origin
	git.exe -C %dir% remote prune origin
	goto :EOF

REM cycle though local branches for deletion
:delete
	set dir="%~1"
	for /F %%b in ('git.exe -C %dir% branch') do (
		SETLOCAL EnableDelayedExpansion
		if not "%%b" == "*" (
			if not "%%b" == "master" (
				if "%option%" == "-f" (
					echo git.exe -C %dir% branch -D %%b
					git.exe -C %dir% branch -D %%b
				) else (
					set /p answer="Delete %dir%->%%b? (y/n/exit) "
					if "!answer!" == "exit" (
						goto :EOF
					)
					if "!answer!" == "y" (
						echo git.exe -C %dir% branch -D %%b
						git.exe -C %dir% branch -D %%b
					)
				)
			)
		)
	)
	goto :EOF

REM End Of File
:EOF