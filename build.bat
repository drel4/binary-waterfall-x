@echo off
setlocal

rem Always build relative to this script, not the caller's working directory.
pushd "%~dp0" || goto ERROR

set "MAINFILENAME=binary-waterfall"
set "MODULENAME=binary_waterfall"
set "ROOTDIR=%CD%"
set "SOURCEDIR=%ROOTDIR%\src\%MODULENAME%"
set "DISTDIR=%ROOTDIR%\dist"
set "BUILDDIR=%ROOTDIR%\build"
set "ENTRYPOINT=%ROOTDIR%\%MAINFILENAME%.py"
set "SPECFILE=%ROOTDIR%\%MAINFILENAME%.spec"
set "BUILTEXE=%DISTDIR%\%MAINFILENAME%.exe"
set "TARGETEXE=%ROOTDIR%\%MAINFILENAME%.exe"
set "VERSIONYAML=%SOURCEDIR%\version.yml"
set "VERSIONINFO=%ROOTDIR%\file_version_info.txt"
set "RESOURCEDIR=%SOURCEDIR%\resources"
set "ICONFILE=%RESOURCEDIR%\icon.ico"
set "SPLASHFILE=%RESOURCEDIR%\splash.jpg"
set "VENVDIR=%ROOTDIR%\.venv"
set "VENVPYTHON=%ROOTDIR%\.venv\Scripts\python.exe"
set "VERSIONTOOL=%ROOTDIR%\.venv\Scripts\create-version-file.exe"
set "BUILDTOOLS=pyinstaller pyinstaller-versionfile"
if /i "%~1"=="pypi" set "BUILDTOOLS=%BUILDTOOLS% build"

where python >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python was not found on PATH.
    goto ERROR
)

if not exist "%VENVPYTHON%" (
    echo Creating build environment at "%VENVDIR%"...
    python -m venv "%VENVDIR%"
    if errorlevel 1 goto ERROR
)

echo Installing build dependencies into the virtual environment...
"%VENVPYTHON%" -m pip install --disable-pip-version-check -e "%ROOTDIR%" %BUILDTOOLS%
if errorlevel 1 goto ERROR

echo Cleaning previous executable build...
if exist "%TARGETEXE%" del /f /q "%TARGETEXE%"
call :CLEAN_BUILD_FILES

echo Generating Windows version information...
"%VERSIONTOOL%" "%VERSIONYAML%" --outfile "%VERSIONINFO%"
if errorlevel 1 goto ERROR

echo Building portable executable...
"%VENVPYTHON%" -m PyInstaller ^
    --clean ^
    --noconfirm ^
    --noconsole ^
    --onefile ^
    --icon "%ICONFILE%" ^
    --splash "%SPLASHFILE%" ^
    --add-data "%SOURCEDIR%\*.py;.\src\%MODULENAME%" ^
    --add-data "%SOURCEDIR%\version.yml;.\src\%MODULENAME%" ^
    --add-data "%SOURCEDIR%\constants\*.py;.\src\%MODULENAME%\constants" ^
    --add-data "%SOURCEDIR%\helpers\*.py;.\src\%MODULENAME%\helpers" ^
    --add-data "%RESOURCEDIR%\*;.\src\%MODULENAME%\resources" ^
    --version-file "%VERSIONINFO%" ^
    "%ENTRYPOINT%"
if errorlevel 1 goto ERROR

if not exist "%BUILTEXE%" (
    echo ERROR: PyInstaller completed without creating "%BUILTEXE%".
    goto ERROR
)

move /y "%BUILTEXE%" "%TARGETEXE%" >nul
if errorlevel 1 goto ERROR

echo Cleaning temporary executable build files...
call :CLEAN_BUILD_FILES

if /i not "%~1"=="pypi" goto DONE

echo Building Python package...
"%VENVPYTHON%" -m build
if errorlevel 1 (
    echo ERROR: Python package build failed.
    goto ERROR
)

:DONE
echo Build complete: "%TARGETEXE%"
popd
endlocal
exit /b 0

:ERROR
echo Build failed.
call :CLEAN_BUILD_FILES
popd
endlocal
exit /b 1

:CLEAN_BUILD_FILES
if exist "%DISTDIR%" rmdir /s /q "%DISTDIR%"
if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%"
if exist "%SPECFILE%" del /f /q "%SPECFILE%"
if exist "%VERSIONINFO%" del /f /q "%VERSIONINFO%"
exit /b 0
