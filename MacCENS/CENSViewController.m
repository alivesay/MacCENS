#import "CENSViewController.h"

extern bool inAlert;

@implementation CENSViewController

- (void)doAlert
{
	// get alert url
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:@"MacCENS_AlertMSG1"];

	NSURL *url = [NSURL URLWithString:val];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[[webView mainFrame] loadRequest:request];
}

@end
