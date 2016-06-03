//
//  CustomError.m
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "CustomError.h"

@implementation CustomError
@synthesize errorMessage = _errorMessage;


-(id) initWithCode:(NSInteger) code withMessage:(NSString *) errorMsg
{
	self = [super initWithDomain:@"com.eno.receiptless" code:code userInfo:nil];
	if(self)
	{
	  _errorMessage = errorMsg;
	}
	
	return self;
}


+(CustomError *) customErrorFromError:(NSError *) error
{
	NSString *errorMsg = [error localizedDescription];
	CustomError *customError =[[CustomError alloc] initWithCode:error.code withMessage:errorMsg];

	return customError;

}


@end
