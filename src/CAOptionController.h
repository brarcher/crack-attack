/* CAOptionController */

#import <Cocoa/Cocoa.h>

@interface CAOptionController : NSObject
{
    IBOutlet NSMatrix *gameTypeRadios;
    IBOutlet NSButton *lowSwitch;
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *portNumberField;
    IBOutlet NSButton *waitSwitch;
    IBOutlet NSButton *xSwitch;
	IBOutlet NSWindow *optionsWindow;
	IBOutlet NSTextField *serverNameField;
}
- (IBAction)playAction:(id)sender;
- (IBAction)quitAction:(id)sender;
- (void)askForMode:(int *)mode port:(int *)port hostName:(char *)host playerName:(char *)player;

@end