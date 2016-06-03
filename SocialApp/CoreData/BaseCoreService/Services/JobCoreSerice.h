//
//  JobCoreSerice.h
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface JobCoreSerice : BaseCoreService
+(JobCoreSerice *) defaultInstance;

- (void) saveJobListFromJson:(NSArray *)dataList;
- (NSArray *) fetchJobList;
- (void) deleteAllJobList;
@end
