/*
 * Attack.cxx
 * Daniel Nelson - 8/29/0
 *
 * Copyright (C) 2000  Daniel Nelson
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * Daniel Nelson - aluminumangel.org
 * 174 W. 18th Ave.
 * Columbus, OH  43210
 */

/****

This source file is designed specifically for use on Mac OS X.  I originally had only a few parts ifdef'ed out
but, due to this source file now being Objective-C++ which is only understood on Mac OS X, I had to make it a
seperate source file (extension needs to be different).  Sorry for the duplication.

This isn't actually needed and this component can be compiled using the normal header (if the glut header location
is changed, of course) but this entry point allows a panel to be presented to specify the arguments since it
isn't very Mac-like to have to run it from the command line (that only means that most of the user base doesn't
like or understand the command line so that would scare them away from the game).

****/


#if defined(__MACH__) && defined(__APPLE__)
#include <Cocoa/Cocoa.h>
#include <GLUT/glut.h>
#import "CAOptionController.h"
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>

#include <pwd.h>


#include "Game.h"
#include "Attack.h"
#include "Communicator.h"
#include "MetaState.h"
#include "Random.h"
#include "TextureLoader.h"

/*
 * Documentation
 *   html tables don't work right in explorer
 *   man-page bug
 *
 * Issues and Watches
 *   slow if left sitting a long time before game start
 *   gtk+ frontend
 *   central server for online game setup
 *   remove dying_count_2
 *   find and use correct GL_LIGHT_MODEL_COLOR_CONTROL defines
 */

int main ( int argc, char **argv )
{
  char player_name[GC_PLAYER_NAME_LENGTH];
  char host_name[256];
  int port;
  int mode = 0;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
[[NSFileManager defaultManager] changeCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
 
	glutInit(&argc, argv);

  player_name[0] = '\0';
  parseCommandLine(argc, argv, mode, port, host_name, player_name);

  if (player_name[0] == '\0') {
    struct passwd *uinfo = getpwuid(getuid());
    if (uinfo) {
      strncpy(player_name, uinfo->pw_name, GC_PLAYER_NAME_LENGTH);
      for (int n = strlen(player_name); n--; )
        player_name[n] = toupper(player_name[n]);
    } else
      strncpy(player_name, GC_DEFAULT_PLAYER_NAME, GC_PLAYER_NAME_LENGTH);
  }

  cout << GC_MESSAGE << endl;
  
  setupLocalDataDirectory();
 
  if (!(mode & CM_SOLO))
    Communicator::initialize(mode, port, host_name, player_name);
  else
    Random::seed(Random::generateSeed());

  MetaState::programStart(mode, player_name);

  glutMainLoop();

	[pool release];
  return 0;
}

void askForGUIData(int *mode, int *port, char *host_name, char *player_name)
{
	CAOptionController *control = [[CAOptionController alloc] init];
	if (![NSBundle loadNibNamed:@"Crack Attack Options" owner:control])
	{
		NSLog(@"Failure!");
		*mode |= CM_SOLO;
	}
	else
	{
		[control askForMode:mode port:port hostName:host_name playerName:player_name];
	}
	[control release];
}

void parseCommandLine ( int argc, char **argv, int &mode, int &port,
 char *host_name, char *player_name )
{
  for (int n = 1; argv[n]; n++) {

    if (!strcmp(argv[n], "-s") || !strcmp(argv[n], "--server")) {
      if (mode & (CM_SERVER | CM_CLIENT | CM_SOLO))
		askForGUIData(&mode, &port, host_name, player_name);

      mode |= CM_SERVER;
      if (argv[n + 1] && argv[n + 1][0] != '-')
        port = atoi(argv[++n]);
      else
        port = 0;

    } else if (!strcmp(argv[n], "-1") || !strcmp(argv[n], "--solo")) {
      if (mode & (CM_SERVER | CM_CLIENT | CM_SOLO))
		askForGUIData(&mode, &port, host_name, player_name);

      mode |= CM_SOLO;

    } else if (!strcmp(argv[n], "-n") || !strcmp(argv[n], "--name")) {
      if (!argv[n + 1])
		askForGUIData(&mode, &port, host_name, player_name);

      strncpy(player_name, argv[++n], GC_PLAYER_NAME_LENGTH);
      player_name[GC_PLAYER_NAME_LENGTH - 1] = '\0';
      for (char *p = player_name; *p; p++)
        if (!isprint(*p)) *p = ' ';

    } else if (!strcmp(argv[n], "-l") || !strcmp(argv[n], "--low"))

      mode |= CM_LOW_GRAPHICS;

    else if (!strcmp(argv[n], "-X") || !strcmp(argv[n], "--extreme"))

      mode |= CM_X;

    else if (!strcmp(argv[n], "-w") || !strcmp(argv[n], "--wait"))
      mode |= CM_NO_TIME_OUT;

    else {
      if (mode & (CM_SERVER | CM_CLIENT | CM_SOLO))
		askForGUIData(&mode, &port, host_name, player_name);

      mode |= CM_CLIENT;
      strcpy(host_name, argv[n]);
      char *ptr = strchr(host_name, ':');
      if (ptr) {
        port = atoi(ptr + 1);
        *ptr = '\0';
      } else
        port = 0;
    }
  }

  if (!(mode & (CM_SERVER | CM_CLIENT | CM_SOLO)))
		askForGUIData(&mode, &port, host_name, player_name);

  if ((mode & CM_NO_TIME_OUT) && !(mode & CM_SERVER))
		askForGUIData(&mode, &port, host_name, player_name);
}

void setupLocalDataDirectory (   )
{
  char local_directory[256];
  TextureLoader::buildLocalDataDirectoryName(local_directory);
  if (!TextureLoader::fileExists(local_directory)
   && mkdir(local_directory, 0777)) {
    cerr << "Error creating local data directory '" << local_directory
     << "'." << endl;
    exit(1);
  }
}
#endif