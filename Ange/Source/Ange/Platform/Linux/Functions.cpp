#include "Apch.h"

#ifdef ANGE_PLATFORM_LINUX
#include "Ange/Platform/Linux/Functions.h"

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xresource.h>

namespace Ange {

	std::string utf8_encode(const std::wstring &wstr)
	{
		return "";
	}

	std::wstring utf8_decode(const std::string &str)
	{
		return L"";
	}

	int GetScreenDPI()
	{
		Display* disp = XOpenDisplay(NULL);
		int scr = 0;
 		double hPixelsPerInch = ((double) DisplayWidth(disp,scr)) * 25.4 / ((double) DisplayWidthMM(disp,scr));
        double vPixelsPerInch = ((double) DisplayHeight(disp,scr)) * 25.4 / ((double) DisplayHeightMM(disp,scr));
		return (int)((hPixelsPerInch + vPixelsPerInch) * 0.5);
	}

}

#endif
