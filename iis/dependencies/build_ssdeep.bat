@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%SSDEEP%" goto build_failed
@if NOT EXIST "%SOURCE_DIR%\%SSDEEP_BIN%" goto build_failed

@7z.exe x -y "%SOURCE_DIR%\%SSDEEP_BIN%" -o"%WORK_DIR%"
@if errorlevel 1 goto build_failed
@7z.exe x -y -so "%SOURCE_DIR%\%SSDEEP%" | 7z.exe x -y -aoa -si -ttar
@if errorlevel 1 goto build_failed

@set "SSDEEP_DIR=%SSDEEP_BIN:~0,-4%"
@if exist "%SSDEEP_DIR%" move /y "%SSDEEP_DIR%" "ssdeep"
@if errorlevel 1 goto build_failed
@cd /d "%WORK_DIR%\ssdeep"
@if errorlevel 1 goto build_failed

@set "SSDEEP_ARCH=x86"
@call cl 2>&1 | findstr /C:"x64" >nul
@if not errorlevel 1 set "SSDEEP_ARCH=x64"

lib /machine:%SSDEEP_ARCH% /def:fuzzy.def
@if errorlevel 1 goto build_failed

copy /y "%WORK_DIR%\ssdeep\fuzzy.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\ssdeep\fuzzy.def" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\ssdeep\fuzzy.lib" "%OUTPUT_DIR%" || goto build_failed


@exit /B 0

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1
