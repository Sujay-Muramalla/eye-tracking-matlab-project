QT       += core gui


TARGET = QtEyeTrackingSample
TEMPLATE = app

SOURCES += main.cpp \
    mainwindow.cpp \
    qteyetrackingsampleapp.cpp \
    qteyetracker.cpp \
    eyetrackerbrowser.cpp \
    eyetrackerbrowsereventargs.cpp \
    eyetrackerscontroller.cpp \
    listviewdelegate.cpp \
    mainloopthread.cpp \
    trackstatuswidget.cpp \
    gazedataserializer.cpp \
    frameratedialog.cpp \
    calibrationresults.cpp \
    calibrationrunner.cpp \
    plotframe.cpp \
    calibrationdialog.cpp

HEADERS  += \
    appversion.h \
    qteyetracker.h \
    eyetrackerbrowser.h \
    eyetrackerbrowsereventargs.h \
    eyetrackerscontroller.h \
    listviewdelegate.h \
    mainloopthread.h \
    trackstatuswidget.h \
    mainwindow.h \
    qteyetrackingsampleapp.h \
    gazedataserializer.h \
    frameratedialog.h \
    calibrationresults.h \
    calibrationrunner.h \
    plotframe.h \
    calibrationdialog.h

FORMS    += mainwindow.ui \
    frameratedialog.ui \
    calibrationdialog.ui \
    calibrationresults.ui \
    plotframe.ui

LIBS += -ltetio


# linux
unix:!macx {
	LIBS += -lboost_thread -lboost_system
    TARGET = qteyetrackingsample
    QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/:\$$ORIGIN/../lib/\'
    QMAKE_LFLAGS += \'-Wl,-rpath-link,../bin/Release/\'
    QMAKE_LFLAGS += \'-Wl,-rpath-link,../bin/Debug/\'
}


# windows 
win32 {
	
    OBJECTS_DIR = $$quote($$OBJ_PATH)
	DESTDIR = $$quote($$DST_PATH)	
	#The next line is to make the sample find tetio.lib and tetio.dll after it has been published as artifacts.
	QMAKE_LIBDIR += ../../lib/
	QMAKE_LIBDIR += $$quote($$LIB_PATH)
	
	#message( HOST: $$QMAKE_HOST.arch )
	#message( TARGET: $$QMAKE_TARGET.arch )
	#message( VCINSTALLDIR: $(VCINSTALLDIR) )
	#message( INC_BASE_PATH:$$INC_BASE_PATH )
	#message( OBJECTS_DIR:$$OBJECTS_DIR )
	#message( DESTDIR:$$DESTDIR )
	#message( QMAKE_LIBDIR:$$QMAKE_LIBDIR )
	
	contains(QMAKE_HOST.arch, x86_64):{
		message("Building for 64 bit")
		QMAKE_CXXFLAGS_RELEASE += -MP
		QMAKE_LFLAGS -= /MACHINE:X86
		QMAKE_LFLAGS += /MACHINE:X64

		INCLUDEPATH += $$quote($$(BOOST_ROOT_64))
		QMAKE_LIBDIR += $$quote($$(BOOST_ROOT_64))/lib64
		
	} else {
		message("Building for 32 bit")
		QMAKE_CXXFLAGS_RELEASE += -MP
		QMAKE_LFLAGS -= /MACHINE:X64
		QMAKE_LFLAGS += /MACHINE:X86

		INCLUDEPATH += $$quote($$(BOOST_ROOT))
		QMAKE_LIBDIR += $$quote($$(BOOST_ROOT))/lib
	} 
	DEFINES += _WIN32_WINNT=0x0501
	INCLUDEPATH += $$quote($$INC_BASE_PATH)/include
	INCLUDEPATH += $$quote($$INC_BASE_PATH)/include/tobii/sdk/detail

	#message( INCLUDEPATH:$$INCLUDEPATH )
}


# mac os x
macx {
    QMAKE_LIBDIR += /opt/local/lib/
    LIBS += -lboost_thread -lboost_system
    INCLUDEPATH += /opt/local/include
    QMAKE_LFLAGS += \'-Wl,-rpath,@loader_path/../Frameworks\'
}
