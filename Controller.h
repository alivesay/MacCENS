/* Controller */

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import "CENSViewController.h"

@interface Controller : NSObject
{
	IBOutlet id censPanel;
	IBOutlet id censB;
	IBOutlet id SBMenu;
	NSTimer *timer;
	bool inAlert;
	bool firstRun;
	NSSound *sound;
}

- (void)showFullscreenWindow;
- (void)StopFullscreen;
- (void)checkForAlert;
@end
