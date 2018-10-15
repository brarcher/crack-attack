#ifndef ATTACK_H
#define ATTACK_H

#include "Game.h"

#if defined(__MACH__) && defined(__APPLE__)
void askForGUIData(int *mode, int *port, char *host_name, char *player_name);
#else
void usage (   );
#endif

void parseCommandLine ( int argc, char **argv, int &mode, int &port,
 char *host_name, char player_name[GC_PLAYER_NAME_LENGTH] );
void setupLocalDataDirectory (   );

#endif
