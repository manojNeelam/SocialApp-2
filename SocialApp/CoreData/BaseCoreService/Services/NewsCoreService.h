//
//  NewsCoreService.h
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface NewsCoreService : BaseCoreService
+(NewsCoreService *) defaultInstance;

- (void) saveNewsListFromJson:(NSArray *)dataList;
- (NSArray *) fetchNewsList;
- (void) deleteAllNewsList;
@end
