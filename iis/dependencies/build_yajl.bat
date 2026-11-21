@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%YAJL%" goto file_not_found_bin

@7z.exe x -y "%SOURCE_DIR%\%YAJL%" -o"%WORK_DIR%"
@if errorlevel 1 goto build_failed
@set "YAJL_DIR=%YAJL:~0,-4%"
@if exist "%YAJL_DIR%" move /y "%YAJL_DIR%" "%WORK_DIR%\yajl"
@if errorlevel 1 goto build_failed
@if not exist "%WORK_DIR%\yajl" goto build_failed
@cd /d "%WORK_DIR%\yajl"
@if not exist build mkdir build
@if errorlevel 1 goto build_failed
@cd /d "%WORK_DIR%\yajl\build"
@if errorlevel 1 goto build_failed
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ..
@if errorlevel 1 goto build_failed
nmake
@if errorlevel 1 goto build_failed

@cd /d "%WORK_DIR%"

@set "YAJL_LIB_DIR="
@if exist "%WORK_DIR%\yajl\build\lib" set "YAJL_LIB_DIR=%WORK_DIR%\yajl\build\lib"
@if exist "%WORK_DIR%\yajl\build\%YAJL_DIR%\lib" set "YAJL_LIB_DIR=%WORK_DIR%\yajl\build\%YAJL_DIR%\lib"
@if ""=="%YAJL_LIB_DIR%" goto build_failed
@if not exist "%WORK_DIR%\yajl\build\include" mkdir "%WORK_DIR%\yajl\build\include"
@if errorlevel 1 goto build_failed

copy /y "%YAJL_LIB_DIR%\yajl.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%YAJL_LIB_DIR%\yajl.lib" "%OUTPUT_DIR%" || goto build_failed
copy /y "%YAJL_LIB_DIR%\yajl_s.lib" "%OUTPUT_DIR%" || goto build_failed

copy /y "%YAJL_LIB_DIR%\yajl.dll" "%WORK_DIR%\yajl\build\include\yajl.dll" || goto build_failed
copy /y "%YAJL_LIB_DIR%\yajl.lib" "%WORK_DIR%\yajl\build\include\yajl.lib" || goto build_failed
copy /y "%YAJL_LIB_DIR%\yajl_s.lib" "%WORK_DIR%\yajl\build\include\yajl_s.lib" || goto build_failed


@exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%YAJL%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1
