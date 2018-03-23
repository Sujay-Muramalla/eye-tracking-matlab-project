
Windows
-------
1. To be able to run the samples you have to add ..\Modules to the PYTHONPATH.
	From a command prompt run: set PYTHONPATH=%PYTHONPATH%;%cd%\..\Modules (will only affect the current command shell)
	You can also set these environment variables permanently in the Windows control panel.

2. PyGTK is required to run the samples.
	The PyGTK graphical toolkit is not installed by default on Windows. 
	PyGTK can be obtained from the following URL: http://www.pygtk.org/.

Ubuntu
------
1. To be able to run the samples you have to add ..\Modules to the PYTHONPATH.
	From a command shell run: export PYTHONPATH=$PYTHONPATH:$(pwd)/../modules

2. PyGTK is required to run the samples.
	PyGTK can be obtained from the following URL: http://www.pygtk.org/.
	It can preferably be installed using: sudo apt-get install python-gtk2
    
Mac OS X
------
1. To be able to run the samples you have to add ..\Modules to the PYTHONPATH.
	From a command shell run: export PYTHONPATH=$PYTHONPATH:$(pwd)/../modules

2. PyGTK is required to run the samples.
	PyGTK is installed with the following command: port install py27-pygtk –x11 +quartz 
    It is important to get the quartz version of pygtk, since the X11 window system on Mac do not honor full screen requests 
    in the correct way. Full screen is required for the calibration screen.

