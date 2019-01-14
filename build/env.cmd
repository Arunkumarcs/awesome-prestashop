@echo off
title %~n0.%~x0
cls

set virtualenvname=.venv
set sshpublickey=E:\ProgramFiles\Dropbox\_backup\credentials\rsa\alexpc_win\id_rsa.ppk
set sshprivatekey=E:\ProgramFiles\Dropbox\_backup\credentials\rsa\alexpc_linux\id_rsa.ppk

set errlvl=%ERRORLEVEL%
if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 echo ERROR: routine %~1 not found. Usage: call scriptfile.cmd help
  )
) else >&2 echo ERROR: missing routine. Usage: call scriptfile.cmd help
exit /b

:help
echo == HELP ==
echo Usage:   call SCRIPTNAME COMMAND
echo Example: call script.cmd help
echo.
echo == REPO ==
echo dd   - Deploy Script (WIP)
echo db   - Backup Script (WIP)
echo.
echo == DEPLOYS ==
echo mi   - Documentation MkDocs: Install pip packages (Required*)
echo mb   - Documentation MkDocs: Build
echo ms   - Documentation MkDocs: Serve
echo md   - Documentation MkDocs: Deploy (gh-deploy)
exit /b

:mi
echo executing :mi
echo arg1 = %1
virtualenv %virtualenvname%
call .venv\Scripts\activate.bat
pip install -r requirements.txt
deactivate
exit /b

:mb
echo executing :mb
echo arg1 = %1
echo arg2 = %2
cp README.md docs\README.md
call .venv\Scripts\activate.bat
mkdocs build
rm docs\README.md
deactivate
exit /b

:ms
echo executing :ms
echo arg1 = %1
echo arg2 = %2
echo arg3 = %3
call .venv\Scripts\activate.bat
mkdocs serve
deactivate
exit /b %errlvl%

:md
echo executing :md
echo arg1 = %1
echo arg2 = %2
echo arg3 = %3
call .venv\Scripts\activate.bat
start /w "GitBash" "%PROGRAMFILES%\Git\git-cmd.exe" --no-cd --command=usr/bin/bash.exe -l -i -c "git add .; git commit -m ""s""; git push;"
start /b "GitBash" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -c "mkdocs gh-deploy; echo; echo PRESS ENTER !!!;"
deactivate
::git commit -m "Script Deploy - `echo ${DATE}`"
exit /b %errlvl%