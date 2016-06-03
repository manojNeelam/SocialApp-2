//
//  BaseCoreService.h
//  ReceiptLess
//
//  Created by SanC on 14/03/14.
//  Copyright (c) 2014 Enovate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomError.h"
#import "MainCoreDataBase.h"
#import "CoreDataConstants.h"

#define INVALID_RESPONSE_CODE  9999

@protocol BaseCoreServiceDelegate <NSObject>
@optional
- (void) onCoreDataResponse:(NSString *) opType withData:(id) data withError:(CustomError *)error;
- (void) onWebResponse:(NSString *) opType withData:(id) data withError:(CustomError *)error;
@end

@interface BaseCoreService : NSObject
{
    NSManagedObjectContext *moContext;
	id<BaseCoreServiceDelegate> mainDelegate;
}

@property (nonatomic,strong) id<BaseCoreServiceDelegate> mainDelegate;
-(id) initWithDelegate:(id<BaseCoreServiceDelegate>) delegate;
-(NSString *) SessionID;
- (NSObject *) getValueFromNSUserDefalutsWithKey:(NSString *) key;
-(void) deleteAllEntityRecords:(NSString *) tableName;
-(NSString *) encodeStringData:(NSString *) unencodedString;

@end
