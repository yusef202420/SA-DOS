@echo off
:: SA-DOS BETA v1.1 - Full Screen Mode Enabled
mode con: cols=120 lines=30

:: Hide cursor (using ANSI escape code)
<nul set /p =[?25l

title SA-DOS BETA v1.1 - Full Screen Mode
setlocal EnableDelayedExpansion

:: Base folders
set "basepath=V\Users"

:: Ensure base folder exists
if not exist "%basepath%" mkdir "%basepath%"

:: Multiuser user list file
set "userfile=users.dat"

:: First time setup check
if not exist "%userfile%" goto setup

:login
cls
echo ================================
echo          SA-DOS LOGIN
echo ================================
echo.
set /p username=Username: 
set /p password=Password: 

set "founduser="
for /f "tokens=1,2 delims=," %%a in (%userfile%) do (
    if /i "%%a"=="%username%" if "%%b"=="%password%" set founduser=%%a
)

if defined founduser (
    set "userfolder=%basepath%\%founduser%"
    if not exist "!userfolder!\notepad" (
        mkdir "!userfolder!"
        mkdir "!userfolder!\notepad"
    )
    goto main
) else (
    echo Invalid username or password.
    pause
    goto login
)

:setup
cls
echo ================================
echo      SA-DOS FIRST USER SETUP
echo ================================
echo.
set /p newuser=Create username: 
set /p newpass=Create password: 

echo %newuser%,%newpass%>"%userfile%"
mkdir "%basepath%\%newuser%\notepad"
echo Setup complete! Please login.
pause
goto login

:main
cls
echo ================================
echo      SA-DOS BETA v1.1
echo      Logged in as: %username%
echo ================================
echo.
echo Commands: notepad, viewfile, editfile, listfiles, delfile, python, logout, exit
echo.

set "notepadpath=%userfolder%\notepad"
set /p command=Enter command: 

if /i "%command%"=="notepad" goto notepad
if /i "%command%"=="viewfile" goto viewfile
if /i "%command%"=="editfile" goto editfile
if /i "%command%"=="listfiles" goto listfiles
if /i "%command%"=="delfile" goto delfile
if /i "%command%"=="python" goto pythonrun
if /i "%command%"=="logout" goto logout
if /i "%command%"=="exit" goto exit

echo Unknown command: %command%
pause
goto main

:: NOTEPAD (user specific)
:notepad
cls
echo SA-DOS NOTEPAD
echo Logged in: %username%
echo.
set /p filename=Enter file name (without .txt): 

echo Enter your text. Type END on a new line to save and finish.
(
  :readlines
  set /p line=
  if /i "!line!"=="END" goto savenotepad
  echo !line!
  goto readlines
) > "%notepadpath%\%filename%.txt"

:savenotepad
cls
echo File saved as: %notepadpath%\%filename%.txt
pause
goto main

:: VIEWFILE (user specific)
:viewfile
cls
echo VIEW FILE
set /p fileview=Enter file name (without .txt): 

if exist "%notepadpath%\%fileview%.txt" (
    echo.
    type "%notepadpath%\%fileview%.txt"
) else (
    echo File not found.
)
pause
goto main

:: EDITFILE (user specific)
:editfile
cls
set /p editname=Enter file name to edit (without .txt): 
set "editpath=%notepadpath%\%editname%.txt"
if exist "%editpath%" (
    echo Current contents:
    type "%editpath%"
    echo.
    echo Enter new content. Type END on a new line to finish.
    del "%editpath%"
    (
      :editloop
      set /p eline=
      if /i "!eline!"=="END" goto endedit
      echo !eline!
      goto editloop
    ) >> "%editpath%"
    :endedit
    echo File updated successfully.
) else (
    echo File not found.
)
pause
goto main

:: LISTFILES (user specific)
:listfiles
cls
echo LIST FILES
dir /b "%notepadpath%\*.txt"
pause
goto main

:: DELFILE (user specific)
:delfile
cls
set /p delname=Enter file name to delete (without .txt): 
set "filepath=%notepadpath%\%delname%.txt"
if exist "%filepath%" (
    del "%filepath%"
    echo File deleted.
) else (
    echo File not found.
)
pause
goto main

:: PYTHON RUNNER
:pythonrun
cls
echo Run Python Script
echo.
set /p pyfile=Enter Python script filename (without .py): 

set "fullpath=%userfolder%\%pyfile%.py"
if exist "%fullpath%" (
    echo Running %pyfile%.py ...
    echo -------------------------
    python "%fullpath%"
    echo -------------------------
) else (
    echo Python script not found.
)
pause
goto main

:: LOGOUT
:logout
cls
echo Logging out...
timeout /t 2 >nul
goto login

:: EXIT
:exit
cls
echo Exiting...
:: Show cursor again
<nul set /p =[?25h
timeout /t 2 >nul
exit
