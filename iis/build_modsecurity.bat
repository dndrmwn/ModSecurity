
@echo off
@set "DEPENDENCIES_DIR=dependencies\build_dir"
@set "OUTPUT_DIR=%cd%\dependencies\release_files"
@set "CURRENT_DIR=%cd%"

@echo Checking for vcargs... %1
@if not "%~1"=="" call "%~1"
@if errorlevel 1 goto build_wrong_vcargs

@echo Deleting old stuff...
@del *.obj *.dll *.lib

@echo apache2...
@cd /d "%CURRENT_DIR%\..\apache2"
@del /q *.obj *.dll *.lib 2>nul
@del /q others\libinjection\src\*.obj others\libinjection\src\*.dll others\libinjection\src\*.lib 2>nul
NMAKE -f Makefile.win APACHE=..\iis\%DEPENDENCIES_DIR%\Apache24 PCRE=..\iis\%DEPENDENCIES_DIR%\pcre LIBXML2=..\iis\%DEPENDENCIES_DIR%\libxml2 LUA=..\iis\%DEPENDENCIES_DIR%\lua\src VERSION=VERSION_IIS YAJL=..\iis\%DEPENDENCIES_DIR%\yajl\build\yajl-2.1.0 SSDEEP=..\iis\%DEPENDENCIES_DIR%\ssdeep CURL=..\iis\%DEPENDENCIES_DIR%\curl IIS_BUILD=yes
@if errorlevel 1 goto build_failed

@echo mlogc...
@cd /d "%CURRENT_DIR%\..\mlogc"
del *.obj *.dll *.lib
nmake -f Makefile.win clean
nmake -f Makefile.win APACHE=..\iis\%DEPENDENCIES_DIR%\Apache24 PCRE=..\iis\%DEPENDENCIES_DIR%\pcre CURL=..\iis\%DEPENDENCIES_DIR%\curl YAJL=..\iis\%DEPENDENCIES_DIR%\yajl\build\yajl-2.1.0 SSDEEP=..\iis\%DEPENDENCIES_DIR%\ssdeep VERSION=VERSION_IIS
@if errorlevel 1 goto build_failed

@echo iis...
@cd /d "%CURRENT_DIR%"
del *.obj *.dll *.lib
nmake -f Makefile.win clean
NMAKE -f Makefile.win APACHE=..\iis\%DEPENDENCIES_DIR%\Apache24 PCRE=..\iis\%DEPENDENCIES_DIR%\pcre LIBXML2=..\iis\%DEPENDENCIES_DIR%\libxml2 LUA=..\iis\%DEPENDENCIES_DIR%\lua\src VERSION=VERSION_IIS YAJL=..\iis\%DEPENDENCIES_DIR%\yajl\build\yajl-2.1.0 SSDEEP=..\iis\%DEPENDENCIES_DIR%\ssdeep CURL=..\iis\%DEPENDENCIES_DIR%\curl
@if errorlevel 1 goto build_failed

@cd /d "%CURRENT_DIR%"

@echo Copy...
copy /y "..\mlogc\mlogc.exe" "%OUTPUT_DIR%" || goto build_failed
copy /y "..\iis\modsecurityiis.dll" "%OUTPUT_DIR%" || goto build_failed
copy /y "..\iis\modsecurityiis.pdb" "%OUTPUT_DIR%" || goto build_failed

@exit /B 0

:build_wrong_vcargs
@echo Please specify a valid vcargs
@goto failed

:build_failed
@echo Problems during the building phase
@goto failed

:failed
@cd /d "%CURRENT_DIR%"
@exit /B 1

