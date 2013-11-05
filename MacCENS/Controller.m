#import "Controller.h"

extern bool inAlert;
extern bool firstRun;

@interface SoundDelegate : NSObject {}
@end

@implementation SoundDelegate
- (void)sound: (NSSound *) sound didFinishPlaying: (BOOL) aBool
{
	[sound play];
}
@end


@implementation Controller
- (void)AddToLoginItems



{	/* Beginning of ChangeOurApplicationsLoginSetting */
	

	CFArrayRef	theListOfObjectsToLaunchDuringLogin;

	// Let's get the list of objects to launch when we log on.
	theListOfObjectsToLaunchDuringLogin = CFPreferencesCopyValue (CFSTR ("AutoLaunchedApplicationDictionary"),CFSTR ("loginwindow"),kCFPreferencesCurrentUser,kCFPreferencesAnyHost);
	if (NULL != theListOfObjectsToLaunchDuringLogin)
	{	
		CFBundleRef	ourBundle;

		ourBundle = CFBundleGetMainBundle ();
		if (NULL != ourBundle)
		{
			CFURLRef	ourURL;

			ourURL = CFBundleCopyBundleURL (ourBundle);
			if (NULL != ourURL)
			{
				CFStringRef		ourURLStringRef;

				// Let's get the URL to our bundle so we can see if it's already in the list of objects to install
				ourURLStringRef = CFURLCopyFileSystemPath (ourURL,kCFURLPOSIXPathStyle);
				if (NULL != ourURLStringRef)
				{
					CFIndex			count;
					CFIndex			theNumberOfItems;
					CFDictionaryRef	theCurrentSetting;
					CFStringRef		theCurrentPath;
					Boolean			addOurURLToTheArray;
					Boolean			removeOurURLToTheArray;

					theNumberOfItems = CFArrayGetCount (theListOfObjectsToLaunchDuringLogin);
					for (count = 0;count < theNumberOfItems;count++)
					{
						theCurrentSetting = CFArrayGetValueAtIndex (theListOfObjectsToLaunchDuringLogin,count);
						if ((NULL != theCurrentSetting) && (CFDictionaryGetTypeID () == CFGetTypeID (theCurrentSetting)))
						{
							theCurrentPath = CFDictionaryGetValue (theCurrentSetting,CFSTR ("Path"));
							if ((NULL != theCurrentPath) && (CFStringGetTypeID () == CFGetTypeID (theCurrentPath)))
							{
								if (kCFCompareEqualTo == CFStringCompare (ourURLStringRef,theCurrentPath,0))
								{
									// It looks like we found our own URL, so there's no need to keep looking in the array.
									break;
								}
							}
						}
					}

					if  (count == theNumberOfItems)
					{
						// It looks like we are supposed to start Mac OS with our application, but it's not in the set
						// of objects to launch when the Mac OS starts up.
						addOurURLToTheArray = true;
						removeOurURLToTheArray = false;
					}
					else
					{
						// It looks like the array of objects to launch hold the correct information with respect to either
						// launching our application or not.
						addOurURLToTheArray = false;
						removeOurURLToTheArray = false;
					}

					if (addOurURLToTheArray || removeOurURLToTheArray)
					{
						CFMutableArrayRef	theMutableArray;

						// In order to remove or add an item from the array, we need a mutable version of the array of
						// objects to launch, so let's create that.
						theMutableArray = CFArrayCreateMutableCopy (NULL,0,theListOfObjectsToLaunchDuringLogin);
						if (NULL != theMutableArray)
						{
							Boolean	thePreferencesWereUpdated;

							if (addOurURLToTheArray)
							{
								const void*	listOfKeys[2];
								const void*	listOfValues[2];

								listOfKeys[0] = CFSTR ("Hide");
								listOfValues[0] = kCFBooleanFalse;
								listOfKeys[1] = CFSTR ("Path");
								listOfValues[1] = ourURLStringRef;

								theCurrentSetting = CFDictionaryCreate (NULL,listOfKeys,listOfValues,2,NULL,NULL);

								if (NULL != theCurrentSetting)
								{
									CFArrayAppendValue (theMutableArray,theCurrentSetting);
								}
							}
							else if (removeOurURLToTheArray)
							{
								CFArrayRemoveValueAtIndex (theMutableArray,count);
							}
							
							CFPreferencesSetValue (CFSTR ("AutoLaunchedApplicationDictionary"),theMutableArray,CFSTR ("loginwindow"),kCFPreferencesCurrentUser,kCFPreferencesAnyHost);
							thePreferencesWereUpdated = CFPreferencesSynchronize ((CFStringRef)@"loginwindow",kCFPreferencesCurrentUser,kCFPreferencesAnyHost);

							CFRelease (theMutableArray);
							theMutableArray = NULL;
						}
					}

					CFRelease (ourURLStringRef);
					ourURLStringRef = NULL;
				}

				CFRelease (ourURL);
				ourURL = NULL;
			}
		}

		CFRelease (theListOfObjectsToLaunchDuringLogin);
		theListOfObjectsToLaunchDuringLogin = NULL;
	}
}	/* End of ChangeOurApplicationsLoginSetting */

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	NSStatusItem *sItem;

sItem = [[[NSStatusBar systemStatusBar]statusItemWithLength:NSSquareStatusItemLength] retain];
	
[sItem setEnabled:YES];
[sItem setHighlightMode:YES];
[sItem setMenu:SBMenu];
[sItem setImage:[NSImage imageNamed:@"censicon.tif"]];

firstRun = TRUE;

[self AddToLoginItems];

// add timer
 timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkForAlert) userInfo:nil repeats:YES];
 //[self checkForAlert];
}

- (void)checkForAlert
{
// get current alert header
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *alertPageURL = nil;
	
	[standardUserDefaults synchronize];
	
	if (standardUserDefaults)
		alertPageURL = [standardUserDefaults objectForKey:@"MacCENS_AlertHDR1"];
		
	NSLog(@"alertPageURL = \'%@\'", alertPageURL);
	NSString *alertPage = nil;
	
//	alertPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:alertPageURL] objectAtIndex:0];
	
	NSError* error;
	
	alertPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:alertPageURL] encoding:NSUTF8StringEncoding error:&error];
	
	// get last alert
	
	// NString:stringWithContentsOfURL error?
	if (alertPage == nil) {
		NSLog(@"Load failed with error %@", [error localizedDescription]);
		return;
	}
	
	if ([alertPage length] < 1) {
		NSLog(@"Could not contact server: %@", alertPageURL);
		return;
	}
		
	NSString *lastAlert = nil;
	
	if (standardUserDefaults)
		lastAlert = [standardUserDefaults objectForKey:@"MacCENS_LastMsg"];
		
	NSLog(@"alertPage = \'%@\'", alertPage);
	NSLog(@"lastAlert = \'%@\'", lastAlert);
	
	// if the alert has changed doAlert
	if ([lastAlert compare:alertPage] != NSOrderedSame) {
		// save new message
		if (standardUserDefaults) {
			[standardUserDefaults setObject:alertPage forKey:@"MacCENS_LastMsg"];
			[standardUserDefaults synchronize]; 
		}

		if (firstRun == FALSE)		
			{
			// if inalert remove old alert
			if (inAlert == TRUE) [self StopFullscreen];
		
			[self showFullscreenWindow];
		}
	}
	
	firstRun = FALSE;
}

- (void)showFullscreenWindow
{
	inAlert = TRUE;
	NSRect screenRect;
	// get screen rect of main display
	screenRect = [[NSScreen mainScreen] frame];
	

[NSApp activateIgnoringOtherApps:YES];

[censPanel makeKeyAndOrderFront:nil];

	NSString *resourcepath = [[NSBundle mainBundle] resourcePath];
	NSString *filename = [NSString stringWithFormat:@"%@/cdamsg.wav", resourcepath];
	
	sound = [[NSSound alloc]
						initWithContentsOfFile: filename	
						byReference: YES];
	[sound setDelegate: [[SoundDelegate alloc] init]];
	[sound play];
	[censPanel setFrame:screenRect display:YES];

	[censB doAlert];
	
}

- (void)windowWillClose:(NSNotification *)notification
{
	NSLog(@"window closing");
	[self StopFullscreen];
}

- (IBAction)quit:(id)sender
{
	[self StopFullscreen];
}

-(void)StopFullscreen
{
	[sound setDelegate: nil];
	[censPanel orderOut: nil];
	
	inAlert = FALSE;
	[sound stop];

}

@end
