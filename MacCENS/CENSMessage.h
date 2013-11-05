/* CENSMessage */

/*
 CENS Message Header Definition
 
 Data available from the header-url should contain information in the following format:
 
 cens-header	= message-id "," emergency-id "," locations-id "," timestamp CRLF
 ; e.g., "155,1,(3007),5/10/2007 11:59:58 AM"
 
 message-id		= 1*DIGIT
 
 emergency-id	=  "1" / "5" / "6"
 ; currently available values seem to be static:
 ; 1 : EMERGENCY
 ; 5 : INFORMATION or ALL CLEAR
 ; 6 : ALERT
 
 locations-id	= "(" (1*DIGIT) ")"	;  currently unused in MacCENS 
 
 timestamp		= month-part "/" day-part "/" year-part SP hour-part ":" minute-part ":" second-part SP meridiem-part
							; what a crappy date format!  MacCENS is currently ignoring this and tracks it's own alert times
							; we could use NSDate:dateWithNaturalLanguageString: for this one but it's too buggy
							; If CENS would use international string date format (YYYY-MM-DD HH:MM:SS ±HHMM) we could
							; just use NSDate:dateWithString:
 
 month-part		= 1*2DIGIT	; 1-12
 
 day-part		= 1*2DIGIT	; 1-28, 1-29, 1-30, 1-31 based on month/year
 
 year-part		= 4DIGIT
 
 hour-part		= 1*2DIGIT	; 1-12
 
 minute-part	= 2DIGIT		; 00-59 
 
 second-part	= 2DIGIT		; 00-59
 
 meridiem-part	= "AM" / "PM"
 
*/
#import <Cocoa/Cocoa.h>

@interface CENSMessage : NSObject
{
	int messageId;
	int emergencyId;
	int locationsId;
	
	NSDate * timestamp;
	
	NSString * messageHeader;
	NSString * messageContent;
}
@end