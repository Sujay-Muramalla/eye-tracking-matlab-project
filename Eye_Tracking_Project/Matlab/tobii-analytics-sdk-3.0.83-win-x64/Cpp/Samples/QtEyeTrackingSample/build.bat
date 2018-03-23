@ECHO OFF
REM This is a small bat file for building the QtEyeTrackerSample, call this batch file in this way   
REM
REM   build [Win32|x64] [Release|Debug]
REM 

IF NOT "%1" == "Win32" IF NOT "%1" == "x64" GOTO FAIL
IF NOT "%2" == "Release" IF NOT "%2" == "Debug" GOTO FAIL
GOTO BUILD

:FAIL
ECHO "Illegal arguments. First argument shall be [Win32|x64] and second argument [Release|Debug]"
GOTO END

:BUILD
rem We need to have tetio.dll and the Qt libs to be able to run the code after we build it.
if exist ..\..\Lib\tetio.dll (
  copy ..\..\Lib\tetio.dll .
  copy ..\..\Lib\tetio.lib .
) else (
  echo File ..\..\Lib\tetio.dll does not exist.
  echo Failed to copy ..\..\Lib\tetio.dll to this directory
  GOTO END
)

if "%1" == "Win32" ( 
  if not exist %QT_SDK_ROOT%\bin\ (
    echo %QT_SDK_ROOT%
    echo Could not find Qt libraries. Please setup QT_SDK_ROOT environment variable.
    goto END
  )
  copy %QT_SDK_ROOT%\bin\QtGUI4.dll .
  copy %QT_SDK_ROOT%\bin\QtCore4.dll .
  copy %QT_SDK_ROOT%\bin\QtGUId4.dll .
  copy %QT_SDK_ROOT%\bin\QtCored4.dll .
)

if "%1" == "x64" ( 
  if not exist %QT_SDK_ROOT_64%\bin\ (
    echo %QT_SDK_ROOT_64%
    echo Could not find Qt libraries. Please setup QT_SDK_ROOT_64 environment variable.
    goto END
  )
  copy %QT_SDK_ROOT_64%\bin\QtGUI4.dll .
  copy %QT_SDK_ROOT_64%\bin\QtCore4.dll .
  copy %QT_SDK_ROOT_64%\bin\QtGUId4.dll .
  copy %QT_SDK_ROOT_64%\bin\QtCored4.dll .
)

rem Start the build
MSBuild.exe QtEyeTrackingSample.msproj /fileLogger /property:Platform=%1 /property:Configuration=%2 /verbosity:diag 
GOTO END

:END
