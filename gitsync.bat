@echo off
set "dirs=dir1 dir2 dir3"
set "command="
set "dirs="
set "option="

if [%1]==[] (
	REM no arguments given, prompt for input
	set /p "command=Enter command: "
	set /p "dirs=Enter directories: "
	set /p "option=Enter option: "
) else (
	REM set variables using the arguments
	set command=%1
	set option=%2

	REM handle optional dirs argument
	if not "%option%" == "" (
		if not "%option:~0,1%" == "-" (
			set dirs=%option%
			set option=%3
		)
	)
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
    if "%command%" == "master" set valid=true
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
			call :master %%a
			call :pull %%a
			call :prune %%a
		)
		exit /b 0
	)

	echo Invalid command... exiting
	exit /b 1

REM checkout to master branch
:master
	set dir="%~1"
	echo git.exe -C %dir% checkout master --
	git.exe -C %dir% checkout master --
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