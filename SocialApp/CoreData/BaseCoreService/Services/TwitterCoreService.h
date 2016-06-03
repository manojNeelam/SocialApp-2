//
//  TwitterCoreService.h
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface TwitterCoreService : BaseCoreService
+(TwitterCoreService *) defaultInstance;

- (void) saveTwitterListFromJson:(NSArray *)dataList;
- (NSArray *) fetchTwitterList;
- (void) deleteAllTwitterList;
@end
