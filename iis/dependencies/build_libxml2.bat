@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%LIBXML2%" goto file_not_found_bin

@7z.exe x -y -so "%SOURCE_DIR%\%LIBXML2%" | 7z.exe x -y -aoa -si -ttar
@if errorlevel 1 goto build_failed

@set "LIBXML2_DIR=%LIBXML2:~0,-7%"
@if /i "%LIBXML2:~-4%"==".zip" @set "LIBXML2_DIR=%LIBXML2:~0,-4%"

@if exist "%LIBXML2_DIR%" move /y "%LIBXML2_DIR%" "libxml2"
@if errorlevel 1 goto build_failed

:: fart.exe -r -i -C "%WORK_DIR%\%LIBXML2_DIR%\win32\*.*" \x2Fopt:nowin98 " "
@cd /d "%WORK_DIR%\libxml2\win32"
@if errorlevel 1 goto build_failed
cscript //B //Nologo configure.js iconv=no vcmanifest=yes zlib=yes
@if errorlevel 1 goto build_failed
nmake -f Makefile.msvc
@if errorlevel 1 goto build_failed

@cd /d "%WORK_DIR%"

copy /y "%WORK_DIR%\libxml2\win32\bin.msvc\libxml2.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\libxml2\win32\bin.msvc\libxml2.lib" "%OUTPUT_DIR%" || goto build_failed

@exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%LIBXML2%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1

