workspace "Ange"
	startproject "Sandbox"

	configurations
	{
		"Debug",
		"Release",
	}


--Add options
	newoption {
	   trigger     = "arch",
	   value       = "ARCHITECTURE",
	   description = "Choose a particular CPU architecture",
	   allowed = {
		  { "x86",  "x86" },
		  { "x64",  "x64" }
	   }
	}

	newoption {
	   trigger     = "compiler",
	   value       = "COMPILER",
	   description = "Choose a particular compiler to use in build",
	   allowed = {
		  { "gcc",  "GNU GCC (gcc/g++)" },
		  { "msc",  "Microsoft Visual C++ Compiler" },
		  { "clang","Clang (clang) [Only Linux]" }
	   }
	}
	
-- Add actions

newaction {
   trigger     = "install",
   description = "Exports ANGE library to INSTALL directory.",
   execute = function ()
	filter "system:windows"
		postbuildcommands {
			'mkdir include',
			'mkdir lib',
			'xcopy /F "../Ange/Build/'.. outputdir ..'/Ange/Ange.lib" "../Install/lib"',
			'xcopy /F "../Vendor/freetype/Build/'.. outputdir ..'/FreeType/FreeType.lib" "../Install/lib"',
			'xcopy /F "../Vendor/glad/Build/'.. outputdir ..'/glad/glad.lib" "../Install/lib"',
			'xcopy /F "../Vendor/GLFW/Build/'.. outputdir ..'/GLFW/GLFW.lib" "../Install/lib"',
			'xcopy /F "../Vendor/libjpeg/Build/'.. outputdir ..'/libjpeg/libjpeg.lib" "../Install/lib"',
			'xcopy /F "../Vendor/libpng/Build/'.. outputdir ..'/libpng/libpng.lib" "../Install/lib"',
			'xcopy /F "../Vendor/zlib/Build/'.. outputdir ..'/zlib/zlib.lib" "../Install/lib"',
			'xcopy /E /Y /F "../Ange/Source" "../Install/include"',
			'xcopy /E /I /F"../Vendor/boost/boost" "../Install/include/boost/boost"',
			'xcopy /E /F "../Vendor/GLM" "../Install/include"',
			'xcopy /E /F "../Vendor/glad/include" "../Install/include"',
			'xcopy /E /F "../Vendor/freetype/include" "../Install/include"',
			'xcopy /E /F"../Vendor/GLFW/include" "../Install/include"',
			'xcopy /I /F "../Vendor/libjpeg/*.h" "../Install/include/libjpeg"',
			'xcopy /I /F "../Vendor/libpng/*.h" "../Install/include/libpng"',
			'xcopy /I /F "../Vendor/zlib/*.h" "../Install/include/zlib"',

		}
	filter "system:linux"
		postbuildcommands {
			"{COPY} %{cfg.targetdir}/Ange.lib ../Install/lib",
			'cp -R "Source" "../Install/include"'
		}
	end
}


print("----------------------------")

-- Architecture
if not _OPTIONS["arch"] then
   _OPTIONS["arch"] = "x64"
end
architecture (_OPTIONS["arch"])

-- Print message
if _OPTIONS["arch"] == "x64" then
	print("Choosen architecture - x64");
elseif _OPTIONS["arch"] == "x86" then
	print("Choosen architecture - x86");
end

-- Toolset
if not _OPTIONS["compiler"] then
   _OPTIONS["compiler"] = "clang"
end
toolset (_OPTIONS["compiler"])

-- Print message & Fix GCC
if _OPTIONS["compiler"] == "gcc" then
	print("Configuring for      - GCC")
	makesettings [[
	CC = gcc
	CCX = g++
	]]
elseif _OPTIONS["compiler"] == "clang" then
	print("Configuring for - CLANG")	
	makesettings [[
	CC = clang
	CCX = clang++
	]]
elseif _OPTIONS["compiler"] == "msc" then
	print("Configuring for - MSVC")
end

print("----------------------------")


outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

include "Vendor/GLFW"
include "Vendor/freetype"
include "Vendor/libjpeg"
include "Vendor/libpng"
include "Vendor/glad"
include "Vendor/zlib"

project "INSTALL"
	location "INSTALL"
	kind "Utility"
	
	dependson {"Ange"}
	
	targetdir ("INSTALL")
	objdir ("INSTALL/LOG")
	
	-- Compatibility with Visual Studio
	filter "system:windows"
		systemversion "latest"
	
	-- Copy files to the target directory
	filter "system:windows"
		postbuildcommands {
			'mkdir include',
			'mkdir lib',
			'xcopy /F "../Ange/Build/'.. outputdir ..'/Ange/Ange.lib" "../Install/lib"',
			'xcopy /F "../Vendor/freetype/Build/'.. outputdir ..'/FreeType/FreeType.lib" "../Install/lib"',
			'xcopy /F "../Vendor/glad/Build/'.. outputdir ..'/glad/glad.lib" "../Install/lib"',
			'xcopy /F "../Vendor/GLFW/Build/'.. outputdir ..'/GLFW/GLFW.lib" "../Install/lib"',
			'xcopy /F "../Vendor/libjpeg/Build/'.. outputdir ..'/libjpeg/libjpeg.lib" "../Install/lib"',
			'xcopy /F "../Vendor/libpng/Build/'.. outputdir ..'/libpng/libpng.lib" "../Install/lib"',
			'xcopy /F "../Vendor/zlib/Build/'.. outputdir ..'/zlib/zlib.lib" "../Install/lib"',
			'xcopy /E /Y /F "../Ange/Source" "../Install/include"',
			'xcopy /E /I /F"../Vendor/boost/boost" "../Install/include/boost/boost"',
			'xcopy /E /F "../Vendor/GLM" "../Install/include"',
			'xcopy /E /F "../Vendor/glad/include" "../Install/include"',
			'xcopy /E /F "../Vendor/freetype/include" "../Install/include"',
			'xcopy /E /F"../Vendor/GLFW/include" "../Install/include"',
			'xcopy /I /F "../Vendor/libjpeg/*.h" "../Install/include/libjpeg"',
			'xcopy /I /F "../Vendor/libpng/*.h" "../Install/include/libpng"',
			'xcopy /I /F "../Vendor/zlib/*.h" "../Install/include/zlib"',

		}
	filter "system:linux"
		postbuildcommands {
			"{COPY} %{cfg.targetdir}/Ange.lib ../Install/lib",
			'cp -R "Source" "../Install/include"'
		}

project "Ange"
	location "Ange"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	linkgroups "on"

	targetdir ("Ange/Build/" .. outputdir .. "/%{prj.name}")
	objdir ("Ange/Build-obj/" .. outputdir .. "/%{prj.name}")

	pchheader "Apch.h"
	pchsource "Ange/Source/Apch.cpp"

	files 
	{
		"%{prj.name}/**.h",
		"%{prj.name}/**.cpp",
	}

	includedirs
	{
		"%{prj.name}/Source",
		"Vendor/GLM",
		"Vendor/GLFW/include",
		"Vendor/libjpeg",
		"Vendor/libpng",
		"Vendor/glad/include",
		"Vendor/boost/",
		"Vendor/freetype/include",
	}

	links 
	{
		"GLFW",
		"glad",
		"libpng",
		"libjpeg",
		"zlib",
		"FreeType",
	}

	filter "system:windows"
		systemversion "latest"

		defines 
		{
			"ANGE_PLATFORM_WINDOWS",
			"GLFW_INCLUDE_NONE",
			"_CRT_SECURE_NO_WARNINGS",
			"_CRT_NONSTDC_NO_DEPRECATE"
		}
	
		removefiles { "%{prj.name}/Source/%{prj.name}/Platform/Linux/**" }

		links 
		{
			"opengl32",
			"gdi32"
		}

	filter "system:linux"
		
		defines
		{
			"ANGE_PLATFORM_LINUX",
			"GLFW_INCLUDE_NONE"		
		}

		removefiles { "%{prj.name}/Source/%{prj.name}/Platform/Win32/**" }

		links 
		{
			"pthread",
			"GLU",
			"GL",
			"rt",
			"Xrandr",
			"Xxf86vm",
			"Xi",
			"Xinerama",
			"X11",
			"dl",
			"Xcursor"
		}

	filter "configurations:Debug"
		defines "ANGE_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "ANGE_RELEASE"
		runtime "Release"
		optimize "on"
		
		
project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	linkgroups "on"

	targetdir ("Sandbox/Build/" .. outputdir .. "/%{prj.name}")
	objdir ("Sandbox/Build-obj/" .. outputdir .. "/%{prj.name}")

	files 
	{
		"%{prj.name}/**.h",
		"%{prj.name}/**.cpp"
	}

	includedirs 
	{
		"Sandbox",
		"Ange/Source",
		"Vendor/GLM",
		"Vendor/GLFW/include",
		"Vendor/libjpeg",
		"Vendor/libpng",
		"Vendor/glad/include",
		"Vendor/boost",
		"Vendor/freetype/include",
	}

	filter "system:windows"
		systemversion "latest"

		defines 
		{
			"ANGE_PLATFORM_WINDOWS",
		}

		links
		{
			"opengl32",
			"gdi32",
			"GLFW",
			"glad",
			"libpng",
			"libjpeg",
			"zlib",
			"FreeType",
			"Ange",
		}

	filter "system:linux"
		
		defines
		{
			"ANGE_PLATFORM_LINUX",
		}

		libdirs
		{
			"Ange/Build/" .. outputdir .. "/Ange"
		}

		links 
		{
			"pthread",
			"GLU",
			"GL",
			"rt",
			"Xrandr",
			"Xxf86vm",
			"Xi",
			"Xinerama",
			"X11",
			"dl",
			"Xcursor",
			"GLFW",
			"glad",
			"libpng",
			"libjpeg",
			"zlib",
			"FreeType",
			"Ange",
		}

	filter "configurations:Debug"
		defines "ANGE_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "ANGE_RELEASE"
		runtime "Release"
		optimize "on"

project "CustomWidgetsExample"
	location "CustomWidget"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	linkgroups "on"

	targetdir ("CustomWidget/Build/" .. outputdir .. "/%{prj.name}")
	objdir ("CustomWidget/Build-obj/" .. outputdir .. "/%{prj.name}")

	files 
	{
		"CustomWidget/**.h",
		"CustomWidget/**.cpp"
	}

	includedirs 
	{
		"CustomWidget",
		"Ange/Source",
		"Vendor/GLM",
		"Vendor/GLFW/include",
		"Vendor/libjpeg",
		"Vendor/libpng",
		"Vendor/glad/include",
		"Vendor/boost",
		"Vendor/freetype/include",
	}

	filter "system:windows"
		systemversion "latest"

		defines 
		{
			"ANGE_PLATFORM_WINDOWS",
		}

		links
		{
			"opengl32",
			"gdi32",
			"GLFW",
			"glad",
			"libpng",
			"libjpeg",
			"zlib",
			"FreeType",
			"Ange",
		}

	filter "system:linux"
		
		defines
		{
			"ANGE_PLATFORM_LINUX",
		}

		libdirs
		{
			"Ange/Build/" .. outputdir .. "/Ange"
		}

		links 
		{
			"pthread",
			"GLU",
			"GL",
			"rt",
			"Xrandr",
			"Xxf86vm",
			"Xi",
			"Xinerama",
			"X11",
			"dl",
			"Xcursor",
			"GLFW",
			"glad",
			"libpng",
			"libjpeg",
			"zlib",
			"FreeType",
			"Ange",
		}

	filter "configurations:Debug"
		defines "ANGE_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "ANGE_RELEASE"
		runtime "Release"
		optimize "on"
