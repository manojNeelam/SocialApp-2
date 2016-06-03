//
//  BaseCoreService.m
//  ReceiptLess
//
//  Created by SanC on 14/03/14.
//  Copyright (c) 2014 Enovate. All rights reserved.
//

#import "BaseCoreService.h"

@implementation BaseCoreService
@synthesize mainDelegate = mainDelegate;

-(id) initWithDelegate:(id<BaseCoreServiceDelegate>) delegate
{
	self = [super init];
	if(self)
	{
		[self initilizeScreen];
		if(delegate)
		   mainDelegate = delegate;
		
	}
	return self;
}


-(void) showMessage:(NSString *) msg
{
    
}

-(void) initilizeScreen
{
	moContext = [MainCoreDataBase managedObjectContext];
}


- (NSObject *) getValueFromNSUserDefalutsWithKey:(NSString *) key{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts objectForKey:key];
}

-(NSString *) SessionID
{
	return (NSString *)[self getValueFromNSUserDefalutsWithKey:@""];
}

-(void) deleteAllEntityRecords:(NSString *) tableName
{
	NSArray *records = [[MainCoreDataBase sharedInstanse] getListFromDB:tableName withPredicate:nil];
	//error handling goes here
	for (NSManagedObject * record in records)
	{
		[[MainCoreDataBase managedObjectContext] deleteObject:record];
	}
	NSError *saveError = nil;
	[[MainCoreDataBase managedObjectContext] save:&saveError];
}

-(NSString *) encodeStringData:(NSString *) unencodedString
{
    
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
																				 (CFStringRef)unencodedString,
																				 NULL,
																				 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				 kCFStringEncodingUTF8 ));
	
}


@end
