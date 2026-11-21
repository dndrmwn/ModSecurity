@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%ZLIB%" goto file_not_found_bin

@7z.exe x -y -so "%SOURCE_DIR%\%ZLIB%" | 7z.exe x -y -aoa -si -ttar
@if errorlevel 1 goto build_failed

@set "ZLIB_DIR=%ZLIB:~0,-7%"
@if /i "%ZLIB:~-4%"==".zip" @set "ZLIB_DIR=%ZLIB:~0,-4%"

@if exist "%ZLIB_DIR%" move /y "%ZLIB_DIR%" "zlib"
@if errorlevel 1 goto build_failed
@if not exist "%WORK_DIR%\zlib\win32\Makefile.msc" goto build_failed

@cd /d "%WORK_DIR%\zlib"
nmake -f win32\Makefile.msc
@if errorlevel 1 goto build_failed

@set "INCLUDE=%INCLUDE%;%WORK_DIR%\zlib"
@set "LIB=%LIB%;%WORK_DIR%\zlib"
@cd /d "%WORK_DIR%"

copy /y "%WORK_DIR%\zlib\zlib1.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\zlib\zdll.lib" "%OUTPUT_DIR%" || goto build_failed
@if exist "%WORK_DIR%\zlib\zlib1.pdb" copy /y "%WORK_DIR%\zlib\zlib1.pdb" "%OUTPUT_DIR%" || goto build_failed

@exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%ZLIB%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1
