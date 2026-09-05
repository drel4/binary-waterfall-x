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
set "VERSIONARG="

where pyinstaller >nul 2>&1
if errorlevel 1 (
    echo ERROR: PyInstaller was not found on PATH.
    echo Install it with: python -m pip install pyinstaller
    goto ERROR
)

echo Cleaning previous executable build...
if exist "%TARGETEXE%" del /f /q "%TARGETEXE%"
if exist "%DISTDIR%" rmdir /s /q "%DISTDIR%"
if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%"
if exist "%SPECFILE%" del /f /q "%SPECFILE%"
if exist "%VERSIONINFO%" del /f /q "%VERSIONINFO%"

rem pyinstaller-versionfile is optional. A missing helper should not prevent
rem users who only installed PyInstaller from producing an executable.
where create-version-file >nul 2>&1
if errorlevel 1 goto SKIP_VERSION_INFO

echo Generating Windows version information...
create-version-file "%VERSIONYAML%" --outfile "%VERSIONINFO%"
if errorlevel 1 goto ERROR
set "VERSIONARG=--version-file=%VERSIONINFO%"

:SKIP_VERSION_INFO
if not defined VERSIONARG echo Version metadata helper not found; continuing without it.

echo Building portable executable...
pyinstaller ^
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
    %VERSIONARG% ^
    "%ENTRYPOINT%"
if errorlevel 1 goto ERROR

if not exist "%BUILTEXE%" (
    echo ERROR: PyInstaller completed without creating "%BUILTEXE%".
    goto ERROR
)

move /y "%BUILTEXE%" "%TARGETEXE%" >nul
if errorlevel 1 goto ERROR

echo Cleaning temporary executable build files...
if exist "%DISTDIR%" rmdir /s /q "%DISTDIR%"
if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%"
if exist "%SPECFILE%" del /f /q "%SPECFILE%"
if exist "%VERSIONINFO%" del /f /q "%VERSIONINFO%"

if /i not "%~1"=="pypi" goto DONE

echo Building Python package...
python -m build
if errorlevel 1 (
    echo ERROR: Python package build failed. Install it with: python -m pip install build
    goto ERROR
)

:DONE
echo Build complete: "%TARGETEXE%"
popd
endlocal
exit /b 0

:ERROR
echo Build failed.
popd
endlocal
exit /b 1
