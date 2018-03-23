#include <tobii/sdk/cpp/Library.hpp>

#include "qteyetrackingsampleapp.h"

namespace tetio = tobii::sdk::cpp;

int main(int argc, char *argv[])
{
	tetio::Library::init();

    QtEyeTrackingSampleApp qtEyeTrackingSampleApp(argc, argv);
    qtEyeTrackingSampleApp.getMainWindow()->show();

    return qtEyeTrackingSampleApp.exec();
}
