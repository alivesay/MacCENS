/* CENSViewController */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebView.h>
#import <Foundation/NSTimer.h>

@interface CENSViewController : NSObject
{
    IBOutlet id webView;
}

- (void)doAlert;

@end