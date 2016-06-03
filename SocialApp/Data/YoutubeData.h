//
//  YoutubeData.h
//  SocialApp
//
//  Created by Pai, Ankeet on 16/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YoutubeData : NSObject
@property (nonatomic, strong) NSString *channelId, *channelTitle, *channelDescription, *playlistId, *publishedAt, *thumbnails, *title, *videoID;

-(id)initwithPraseDictionary:(NSDictionary *)param;
-(id)getCoreDataFromObject:(id) coreData;
-(void) populateObjectFromCorData:(id)coreData;
@end
