@echo off
title %~n0.%~x0
cls

set VIRTUALENVNAME=.venv

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
echo == DEPLOYS ==
echo mi   - MkDocs Documentation: Install PIP Packages (Required*)
echo mb   - MkDocs Documentation: Build
echo ms   - MkDocs Documentation: Serve
echo md   - MkDocs Documentation: Deploy (gh-deploy)
exit /b

:mi
echo executing :mi
echo arg1 = %1
virtualenv %VIRTUALENVNAME%
call .venv\Scripts\activate.bat
pip install -r requirements.txt
deactivate
exit /b

:mb
echo executing :mb
echo arg1 = %1
echo arg2 = %2
cp README.md docs\index.md
call %VIRTUALENVNAME%\Scripts\activate.bat
mkdocs build
rm docs\index.md
deactivate
::ln -sf README.md docs/index.md
::mklink docs\index.md README.md
exit /b

:ms
echo executing :ms
echo arg1 = %1
echo arg2 = %2
echo arg3 = %3
call %VIRTUALENVNAME%\Scripts\activate.bat
mkdocs serve
deactivate
exit /b %errlvl%

:md
echo executing :md
echo arg1 = %1
echo arg2 = %2
echo arg3 = %3
cp README.md docs\index.md
call %VIRTUALENVNAME%\Scripts\activate.bat
start /b "GitBash" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -c "mkdocs gh-deploy; echo; echo MkDocs Deployed !! PRESS ENTER TO EXIT; rm docs//index.md;"
deactivate
::start /w "GitBash" "%PROGRAMFILES%\Git\git-cmd.exe" --no-cd --command=usr/bin/bash.exe -l -i -c "git add .; git commit -m ""s""; git push;"
::git commit -m "Script Deploy - `echo ${DATE}`"
exit /b %errlvl%

:check
echo executing :md
echo arg1 = %1
echo arg2 = %2
echo arg3 = %3
call %VIRTUALENVNAME%\Scripts\activate.bat
mkdocs --version
deactivate
exit /b %errlvl%