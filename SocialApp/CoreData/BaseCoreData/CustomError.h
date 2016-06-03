//
//  CustomError.h
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomError : NSError
{
	NSString *_errorMessage;
}

@property (strong,nonatomic) NSString *errorMessage;

+(CustomError *) customErrorFromError:(NSError *) error;

-(id) initWithCode:(NSInteger) code withMessage:(NSString *) errorMsg;

@end
