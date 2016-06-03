//
//  YoutubeCoreService.h
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "BaseCoreService.h"

@interface YoutubeCoreService : BaseCoreService
+(YoutubeCoreService *) defaultInstance;

- (void) saveYoutubeListFromJson:(NSArray *)dataList;
- (NSArray *) fetchYoutubeList;
- (void) deleteAllYoutubeList;
@end
