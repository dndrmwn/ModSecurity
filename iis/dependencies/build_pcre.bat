@cd /d "%WORK_DIR%"

@if NOT EXIST "%SOURCE_DIR%\%PCRE%" goto file_not_found_bin

@7z.exe x -y "%SOURCE_DIR%\%PCRE%"
@if errorlevel 1 goto build_failed
@set "PCRE_DIR=%PCRE:~0,-4%"

@if exist "%PCRE_DIR%" move /y "%PCRE_DIR%" "pcre"
@if errorlevel 1 goto build_failed
@if not exist "%WORK_DIR%\pcre\CMakeLists.txt" goto build_failed

@cd /d "%WORK_DIR%\pcre"
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=ON -DPCRE2_BUILD_PCRE2_8=ON -DPCRE2_BUILD_PCRE2_16=OFF -DPCRE2_BUILD_PCRE2_32=OFF -DPCRE2_BUILD_PCRE2GREP=OFF -DPCRE2_BUILD_TESTS=OFF
@if errorlevel 1 goto build_failed
nmake
@if errorlevel 1 goto build_failed
@cd /d "%WORK_DIR%"

copy /y "%WORK_DIR%\pcre\pcre2-8.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%WORK_DIR%\pcre\pcre2-8.lib" "%OUTPUT_DIR%" || goto build_failed
@if exist "%WORK_DIR%\pcre\pcre2-8.pdb" copy /y "%WORK_DIR%\pcre\pcre2-8.pdb" "%OUTPUT_DIR%" || goto build_failed
@exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%PCRE%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1
