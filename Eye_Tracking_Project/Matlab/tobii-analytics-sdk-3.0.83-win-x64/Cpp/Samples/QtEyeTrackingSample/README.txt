Qt Eye Tracking Sample 
-------------------------
This sample application illustrates how to find eye trackers on the network, connect to a specific
eye tracker, perform a calibration, and subscribe to data from the eye tracker.

The sample comes with full source code, demonstrating how to use the eye tracking 
application programming interface from C++/Qt. 

Requirements
------------
The requirements for building the sample are:
1) Boost libraries (tested with versions >= v1.40)
2) Qt libraries (tested with versions >= 4.6.2)

Building on Windows (32-bit or 64-bit)
--------------------------------------
It is possible to build the sample using other versions of visual studio and boost.
Just adapt the following steps to match your environment.

1. You need Microsoft Visual Studio 2008.
     - Visual Studio 2008 is reffered to as "vc9" in the example. Other versions
       of Visual Studio has different names.

2. You need Boost libraries. (this example shows installation of v1.49).
     - Download the Boost source code from http://www.boost.org/ and unpack the 
       archive to e.g. C:\boost.
     - Using a command window, go to the C:\boost\boost_1_49_0 directory (or wherever 
       you unpacked the Boost sources).
	 - From the "Visual Studio 2008 Command Prompt", build and install Boost with:
	     bootstrap vc9
	     b2 --toolset=msvc-9.0 --build-type=complete stage
	     move stage\lib lib
	   or, for 64-bit:
         - From the "Visual Studio 2008 x64 Win64 Command Prompt", build and install Boost with:
	     bootstrap vc9
	     b2 --address-model=64 --toolset=msvc-9.0 --build-type=complete stage
	     move stage\lib lib64
	 - Set the environment variables BOOST_ROOT or BOOST_ROOT_64 to the folder where 
	   you unpacked the Boost sources, e.g. C:\boost\boost_1_49_0
3. You need QT libraries.
     - Download Qt from http://qt.digia.com or 
       http://code.google.com/p/qt-msvc-installer/ (for 64-bit Windows).
     - Set the environment variables QT_SDK_ROOT or QT_SDK_ROOT_64 to the full path of 
       the Qt SDK. For example: 
         QT_SDK_ROOT=C:\QtSDK\Desktop\Qt\4.8.1\msvc2008
         QT_SDK_ROOT_64=C:\Qt\4.8.1_x64
4. To build the sample from the command line:
     - Install the MSBuild Community Tasks .msi package from https://github.com/loresoft/msbuildtasks/downloads.
     - Go to Cpp\Samples\QtEyeTrackingSample and run "build [Win32|x64] [Release|Debug]". This builds and 
       generates the Visual Studio project files.
5. It is now possible to build the sample from VS2008:
     - Open QtEyeTrackingSample.vcproj in VS2008 and take off from there.

Building on Linux (Ubuntu 10.04 LTS)
-------------------------------------
It is possible to build the sample using other versions of boost and Qt.
Just adapt the following steps to match your environment.

1. You need g++.
     - Install it with: sudo apt-get install g++
2. You need libssh2
     - Install it with “sudo apt-get install libssh2-1-dev”
3. You need Boost libraries
     - Install it with: sudo apt-get install libboost-all-dev
4. You need QT libraries.
     - Install it with: sudo apt-get install qt4-dev-tools
5. To build the sample there is a Makefile, so just run "make".


Building on Mac OS X
--------------------
It is possible to build the sample using other versions of boost and Qt.
Just adapt the following steps to match your environment.

1. You need XCode.
     - Install it from the App Store.
2. You need libssh2
	 - Install it with: sudo port install libssh2 @1.2.7_0+universal
3. You need Boost libraries.
     - Install it with: sudo port install boost -no_static -no_single +universal +python27
4. You need QT libraries.
     - Download Qt from http://qt.digia.com
     - Set the environment variable QT_SDK_ROOT to the full path of 
       the Qt SDK. For example: 
         QT_SDK_ROOT=/opt/local/QtSDK
5. To build the sample there is a Makefile, so just run "make".

