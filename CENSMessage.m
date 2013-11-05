#import "CENSMessage.h"

@implementation CENSMessage

- (id) init
{
	if (![super init])
		return nil;
	
	return self;
}

- (id) initWithString: (NSString *) aMessageHeader
{
	if (![super init])
		return nil;
	
	// validate aMessageHeader
	if (aMessageHeader == nil) || ([aMessageHeader length] == 0) {
		return nil;
	}
	
	// parse message header parts
	NSArray *headerParts = [aMessageHeader componentsSeparatedByString: @","];
	
	if (headerParts == nil) || ([headerParts count != 4]) {
		NSLog(@"Error:  bad message header");
		return nil;
	}
	
	messageId = [[headerParts objectAtIndex: 0] intValue];
	emergencyId = [[headerParts objectAtIndex: 1] intValue];
	
	return self;
}

- (void) setMessageId: (int) aMessageId
{
	messageId = aMessageId;
}

- (int) messageId
{
	return messageId;
}

- (void) setEmergencyId: (int) anEmergencyId
{
	emergencyId = anEmergencyId;
}

- (int) emergencyId
{
	return emergencyId;
}

- (void) setLocationsId: (int) aLocationsId
{
	locationsId = aLocationsId;
}

- (int) locationsId: 
{
	return locationsId;
}

- (void) setMessageId: (int) aMessageId andEmergencyId: (int) anEmergencyId andLocationId: (int) aLocationsId
{
	messageId = aMesssageId;
	emergencyId = anEmergencyId;
	locationsId = aLocationsId;
}

@end
