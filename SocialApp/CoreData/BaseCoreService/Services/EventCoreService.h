//
//  EventCoreService.h
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface EventCoreService : BaseCoreService
+(EventCoreService *) defaultInstance;

- (void) saveEventsListFromJson:(NSArray *)dataList;
- (NSArray *) fetchEventsList;
- (void) deleteAllEventsList;
@end
