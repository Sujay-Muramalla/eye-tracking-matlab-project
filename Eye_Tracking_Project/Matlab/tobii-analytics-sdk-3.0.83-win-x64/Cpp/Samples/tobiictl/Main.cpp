#include "App.h"
#include <tobii/sdk/cpp/Library.hpp>

namespace tetio = tobii::sdk::cpp;

int main(int argc, char *argv[])
{
	tetio::Library::init();
	return App().run(argc, argv);
}
