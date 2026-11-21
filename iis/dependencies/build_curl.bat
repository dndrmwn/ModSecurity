@cd /d "%WORK_DIR%"
@if NOT EXIST "%SOURCE_DIR%\%CURL%" goto file_not_found_bin

@7z.exe x -y "%SOURCE_DIR%\%CURL%"
@if errorlevel 1 goto build_failed
@set "CURL_DIR=%CURL:~0,-4%"
@if exist "%CURL_DIR%" move /y "%CURL_DIR%" "curl"
@if errorlevel 1 goto build_failed
@if not exist "%WORK_DIR%\curl\winbuild" goto build_failed
@cd /d "%WORK_DIR%\curl\winbuild"

@set "ARCH=x86"
@call cl 2>&1 | findstr /C:"x64" >nul
@if not errorlevel 1 set "ARCH=x64"

nmake /f Makefile.vc mode=dll ENABLE_WINSSL=yes MACHINE=%ARCH% WITH_ZLIB=dll
@if errorlevel 1 goto build_failed

@cd /d "%WORK_DIR%"
@set "CURL_BUILD=%WORK_DIR%\curl\builds\libcurl-vc-%ARCH%-release-dll-zlib-dll-ipv6-sspi-schannel-obj-lib"
copy /y "%CURL_BUILD%\libcurl.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "%CURL_BUILD%\libcurl.lib" "%OUTPUT_DIR%" || goto build_failed
copy /y "%CURL_BUILD%\libcurl.lib" "%WORK_DIR%\curl\libcurl.lib" || goto build_failed


exit /B 0

:file_not_found_bin
@echo File not found: "%SOURCE_DIR%\%CURL%"
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@exit /B 1


-> 
