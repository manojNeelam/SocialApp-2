//
//  LinkedinCoreService.h
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface LinkedinCoreService : BaseCoreService
+(LinkedinCoreService *) defaultInstance;

- (void) saveLinkedinListFromJson:(NSArray *)dataList;
- (NSArray *) fetchLinkedinList;
- (void) deleteAllLinkedinList;
@end
