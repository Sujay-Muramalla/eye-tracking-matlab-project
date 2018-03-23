@ECHO OFF
REM This bat file is designed to be called in the following manner.
REM
REM   qmake.bat [Win32|x64] [Release|Debug]  
REM
REM  The paths in this file assumes that this file is used from where it is out when 
REM  zipping up the SDK, for any other directory structure the paths needs to be modified. 
REM
REM  The bat file first set the msvc2008 environment to either amd64 or x86 and then calls qmake
REM

IF NOT "%1" == "Win32" IF NOT "%1" == "x64" GOTO FAIL
IF NOT "%2" == "Release" IF NOT "%2" == "Debug" GOTO FAIL
IF "%1" == "Win32" IF "%QT_SDK_ROOT%" == "" GOTO QT_SDK_ROOT_NOT_SET
IF "%1" == "x64" IF "%QT_SDK_ROOT_64%" == "" GOTO QT_SDK_ROOT_64_NOT_SET
GOTO BUILD

:FAIL
ECHO Illegal arguments. First argument shall be [Win32|x64] and second argument [Release|Debug].
EXIT /B -1

:QT_SDK_ROOT_NOT_SET
ECHO Error: The QT_SDK_ROOT environment variable has not been set.
EXIT /B -1

:QT_SDK_ROOT_64_NOT_SET
ECHO Error: The QT_SDK_ROOT_64 environment variable has not been set.
EXIT /B -1

:BUILD
REM Initial setup of VS9 environment, e.g. needed to get VCINSTALLDIR correctly set.
CALL "%VS90COMNTOOLS%\vsvars32.bat"

IF "%1" == "x64" GOTO X64

:WIN32
CALL "%VCINSTALLDIR%\vcvarsall.bat" x86

IF "%2" == "Debug" GOTO WIN32_DEBUG

:WIN32_RELEASE
ECHO ON
%QT_SDK_ROOT%\bin\qmake.exe QtEyeTrackingSample.pro -r -spec win32-msvc2008 CONFIG+=release INC_BASE_PATH=../.. DST_PATH=./ LIB_PATH=../../Binaries OBJ_PATH=../temp/QtEyeTrackingSample -tp vc -o QtEyeTrackingSample.vcproj
ECHO OFF
GOTO END

:WIN32_DEBUG
ECHO ON
%QT_SDK_ROOT%\bin\qmake.exe QtEyeTrackingSample.pro -r -spec win32-msvc2008 CONFIG+=debug INC_BASE_PATH=../.. DST_PATH=./ LIB_PATH=../../Binaries OBJ_PATH=../temp/QtEyeTrackingSample -tp vc -o QtEyeTrackingSample.vcproj
ECHO OFF
GOTO END

:X64
CALL "%VCINSTALLDIR%\vcvarsall.bat" amd64

IF "%2" == "Debug" GOTO X64_DEBUG

:X64_RELEASE
ECHO ON
%QT_SDK_ROOT_64%\bin\qmake.exe QtEyeTrackingSample.pro -r -spec win32-msvc2008 CONFIG+=release INC_BASE_PATH=../.. DST_PATH=./ LIB_PATH=../../Binaries OBJ_PATH=../temp/QtEyeTrackingSample -tp vc -o QtEyeTrackingSample.vcproj
ECHO OFF
GOTO END

:X64_DEBUG
ECHO ON
%QT_SDK_ROOT_64%\bin\qmake.exe QtEyeTrackingSample.pro -r -spec win32-msvc2008 CONFIG+=debug INC_BASE_PATH=../.. DST_PATH=./ LIB_PATH=../../Binaries OBJ_PATH=../temp/QtEyeTrackingSample -tp vc -o QtEyeTrackingSample.vcproj
ECHO OFF
GOTO END


:END
