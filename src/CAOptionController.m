#import "CAOptionController.h"

#define CM_SERVER                        (1 << 0)
#define CM_CLIENT                        (1 << 1)
#define CM_SOLO                          (1 << 2)
#define CM_X                             (1 << 3)
#define CM_NO_TIME_OUT                   (1 << 4)
#define CM_LOW_GRAPHICS                  (1 << 5)

#define GAME_TYPE_KEY @"Game Type"
#define SERVER_NAME_KEY @"Server Name"
#define PORT_NUMBER_KEY @"Port Number"
#define LOW_SWITCH_KEY @"User Low Graphics"
#define EXTREME_SWITCH_KEY @"Extreme"
#define WAIT_SWITCH_KEY @"Wait"
#define PLAYER_NAME_KEY @"Player Name"

@implementation CAOptionController

- (IBAction)playAction:(id)sender
{
	[optionsWindow close];
	[NSApp stopModal];
}

- (IBAction)quitAction:(id)sender
{
	[NSApp stopModal];
	exit(1);
}

- (void)askForMode:(int *)mode port:(int *)port hostName:(char *)host playerName:(char *)player
{
//set the UI of the optionsWindow to be what they were last time
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *serverName = (nil != [defaults objectForKey:SERVER_NAME_KEY]) ? [defaults objectForKey:SERVER_NAME_KEY] : @"";
	NSString *playerName = (nil != [defaults objectForKey:PLAYER_NAME_KEY]) ? [defaults objectForKey:PLAYER_NAME_KEY] : @"";

	[gameTypeRadios selectCellWithTag:[defaults integerForKey:GAME_TYPE_KEY]];
	[serverNameField setStringValue:serverName];
	[portNumberField setIntValue:[defaults integerForKey:PORT_NUMBER_KEY]];
	[lowSwitch setState:[defaults boolForKey:LOW_SWITCH_KEY]];
	[xSwitch setState:[defaults boolForKey:EXTREME_SWITCH_KEY]];
	[waitSwitch setState:[defaults boolForKey:WAIT_SWITCH_KEY]];
	[nameField setStringValue:playerName];
//now show the panel

	[NSApp runModalForWindow:optionsWindow];
	switch ([[gameTypeRadios selectedCell] tag])
	{
		case 0:
			// single player
			*mode |= CM_SOLO;
		break;
		case 1:
			// client
			*mode |= CM_CLIENT;
			*port = [portNumberField intValue];
			strcpy(host, [[serverNameField stringValue] cString]);
		break; 
		case 2: 
			// server
			*mode |= CM_SERVER;
			*port = [portNumberField intValue];
		break;
	}
	if (NSOnState == [lowSwitch state])
	{
		*mode |= CM_LOW_GRAPHICS;
	}
	if (NSOnState == [xSwitch state])
	{
		*mode |= CM_X;
	}
	if (NSOnState == [waitSwitch state])
	{
		*mode |= CM_NO_TIME_OUT;
	}
	
	strcpy(player, [[nameField stringValue] cString]);
	//now set the preferences to reflect what they chose here
	[defaults setInteger:[[gameTypeRadios selectedCell] tag] forKey:GAME_TYPE_KEY];
	[defaults setObject:[serverNameField stringValue] forKey:SERVER_NAME_KEY];
	[defaults setInteger:[portNumberField intValue] forKey:PORT_NUMBER_KEY];
	[defaults setBool:(NSOnState == [lowSwitch state]) forKey:LOW_SWITCH_KEY];
	[defaults setBool:(NSOnState == [xSwitch state]) forKey:EXTREME_SWITCH_KEY];
	[defaults setBool:(NSOnState == [waitSwitch state]) forKey:WAIT_SWITCH_KEY];
	[defaults setObject:[nameField stringValue] forKey:PLAYER_NAME_KEY];
	[defaults synchronize];
}

@end