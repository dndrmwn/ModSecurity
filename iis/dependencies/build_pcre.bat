@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%PCRE%" goto file_not_found_bin

@7z.exe x -y "%SOURCE_DIR%\%PCRE%"
@if errorlevel 1 goto build_failed
@set "PCRE_DIR=%PCRE:~0,-4%"

@if exist "%PCRE_DIR%" move /y "%PCRE_DIR%" "pcre"
@if errorlevel 1 goto build_failed
@if not exist "%WORK_DIR%\pcre\CMakeLists.txt" goto build_failed

@cd /d "%WORK_DIR%\pcre"
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=True
@if errorlevel 1 goto build_failed
nmake
@if errorlevel 1 goto build_failed
@cd /d "%WORK_DIR%"

copy /y "%WORK_DIR%\pcre\pcre.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\pcre\pcre.lib" "%OUTPUT_DIR%" || goto build_failed
@if exist "%WORK_DIR%\pcre\pcre.pdb" copy /y "%WORK_DIR%\pcre\pcre.pdb" "%OUTPUT_DIR%" || goto build_failed
if exist "%WORK_DIR%\pcre\pcre.h.generic" copy /y "%WORK_DIR%\pcre\pcre.h.generic" "%WORK_DIR%\pcre\pcre.h" || goto build_failed
@exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%PCRE%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1
