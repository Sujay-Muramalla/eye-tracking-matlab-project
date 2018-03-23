@ECHO OFF
REM THis is a small bat file for building the tobiictl, call this batch file in this way   
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
  mkdir Release
  mkdir Debug
  copy ..\..\Lib\tetio.dll Release
  copy ..\..\Lib\tetio.dll Debug
) else (
  echo File ..\..\Lib\tetio.dll does not exist.
  echo Failed to copy ..\..\Lib\tetio.dll to this directory
  GOTO END
)

MSBuild.exe tobiictl.msproj /fileLogger /property:Platform=%1 /property:Configuration=%2 /verbosity:diag 
GOTO END

:END
