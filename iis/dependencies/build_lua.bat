@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%LUA%" goto file_not_found_bin

@7z.exe x -y -so "%SOURCE_DIR%\%LUA%" | 7z.exe x -y -aoa -si -ttar
@if errorlevel 1 goto build_failed

@set "LUA_DIR=%LUA:~0,-7%"
@if /i "%LUA:~-4%"==".zip" @set "LUA_DIR=%LUA:~0,-4%"

@if exist "%LUA_DIR%" move /y "%LUA_DIR%" "lua"
@if errorlevel 1 goto build_failed
@if not exist "%WORK_DIR%\lua\src" goto build_failed

@cd /d "%WORK_DIR%\lua\src"

CL /Ox /arch:SSE2 /GF /GL /Gy /FD /EHsc /MD  /Zi /TC /wd4005 /D "_MBCS" /D "LUA_CORE" /D "LUA_BUILD_AS_DLL" /D "_CRT_SECURE_NO_WARNINGS" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_WIN32" /D "_WINDLL" /c *.c
@if errorlevel 1 goto build_failed
DEL lua.obj luac.obj
LINK /DLL /LTCG /DEBUG /OUT:lua5.1.dll *.obj
@if errorlevel 1 goto build_failed
IF EXIST lua5.1.dll.manifest MT -manifest lua5.1.dll.manifest -outputresource:lua5.1.dll;2
@if errorlevel 1 goto build_failed

@cd /d "%WORK_DIR%"

copy /y "%WORK_DIR%\lua\src\lua5.1.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\lua\src\lua5.1.lib" "%OUTPUT_DIR%" || goto build_failed
@if exist "%WORK_DIR%\lua\src\lua5.1.pdb" copy /y "%WORK_DIR%\lua\src\lua5.1.pdb" "%OUTPUT_DIR%" || goto build_failed

@exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%LUA%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1

