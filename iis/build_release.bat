
@echo off
echo Building release...

@set "RELEASE_DIR=release"
@set "OUTPUT_DIR=%cd%\dependencies\release_files"
@set "CURRENT_DIR=%cd%"

@set "AMD64=%RELEASE_DIR%\amd64"
@set "X86=%RELEASE_DIR%\x86"

@if not exist "%RELEASE_DIR%" mkdir "%RELEASE_DIR%"
@if errorlevel 1 goto build_failed
@if exist "%AMD64%" rmdir /s /q "%AMD64%"
@if errorlevel 1 goto build_failed
@if exist "%X86%" rmdir /s /q "%X86%"
@if errorlevel 1 goto build_failed
mkdir "%AMD64%"
@if errorlevel 1 goto build_failed
mkdir "%X86%"
@if errorlevel 1 goto build_failed

@set "VCARGS32=C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars32.bat"
@set "VCARGS64=C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsx86_amd64.bat"

@if not exist "%VCARGS64%" (
    echo Visual Studio x64 vcvars script not found: "%VCARGS64%"
    goto build_failed
)

@call build_dependencies.bat "%VCARGS64%"
@if errorlevel 1 goto build_failed
@call build_modsecurity.bat "%VCARGS64%"
@if errorlevel 1 goto build_failed

copy /y "%OUTPUT_DIR%\libapr-1.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\libapriconv-1.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\libaprutil-1.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\libcurl.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\libxml2.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\lua5.1.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\mlogc.exe" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\ModSecurityIIS.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\pcre2-8.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\zlib1.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\yajl.dll" "%AMD64%" || goto build_failed
copy /y "%OUTPUT_DIR%\fuzzy.dll" "%AMD64%" || goto build_failed

@if not exist "%VCARGS32%" (
    echo Visual Studio x86 vcvars script not found: "%VCARGS32%"
    goto build_failed
)

@call build_dependencies.bat "%VCARGS32%"
@if errorlevel 1 goto build_failed
@call build_modsecurity.bat "%VCARGS32%"
@if errorlevel 1 goto build_failed

copy /y "%OUTPUT_DIR%\libapr-1.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\libapriconv-1.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\libaprutil-1.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\libcurl.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\libxml2.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\lua5.1.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\mlogc.exe" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\ModSecurityIIS.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\pcre2-8.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\zlib1.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\yajl.dll" "%X86%" || goto build_failed
copy /y "%OUTPUT_DIR%\fuzzy.dll" "%X86%" || goto build_failed


:: copy %OUTPUT_DIR%\Installer.exe %RELEASE_DIR%
:: copy %OUTPUT_DIR%\ModSecurity.xml %RELEASE_DIR%
:: copy %OUTPUT_DIR%\owasp_csr.zip %RELEASE_DIR%
:: copy %OUTPUT_DIR%\README.txt %RELEASE_DIR%


@cd /d "%CURRENT_DIR%"
@exit /B 0

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@cd /d "%CURRENT_DIR%"
@exit /B 1

