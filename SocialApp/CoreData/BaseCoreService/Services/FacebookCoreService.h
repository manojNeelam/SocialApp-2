//
//  FacebookCoreService.h
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface FacebookCoreService : BaseCoreService
+(FacebookCoreService *) defaultInstance;

- (void) saveFacebookListFromJson:(NSArray *)dataList;
- (NSArray *) fetchFacebookList;
- (void) deleteAllFacebookList;
@end
