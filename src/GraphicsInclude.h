#ifndef __GRAPHICS_INCLUDE_H__
#define __GRAPHICS_INCLUDE_H__
//this file is made to serve the basic purpose of abstracting the many tedious ifdef directives used to made sure that specific includes are used (for non-Windows platforms) or that the includes are named correctly (Mac OS X).

#if defined(__MACH__) && defined(__APPLE__)
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#ifndef _WIN32
#else
#  include <glext.h>
#endif

#endif