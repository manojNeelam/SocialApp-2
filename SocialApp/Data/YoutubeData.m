//
//  YoutubeData.m
//  SocialApp
//
//  Created by Pai, Ankeet on 16/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "YoutubeData.h"
#import "YoutubeCD.h"

@implementation YoutubeData
@synthesize  channelId, channelTitle, channelDescription, playlistId, publishedAt, thumbnails, title,videoID;

-(id)initwithPraseDictionary:(NSDictionary *)param
{
    [self parseDictionary:param];
    return self;
}

-(void)parseDictionary:(NSDictionary *)param
{
    NSDictionary *dict = [param objectForKey:@"snippet"];
    self.title = [dict objectForKey:@"title"];
    self.channelDescription = [dict objectForKey:@"description"];
    self.channelId = [dict objectForKey:@"channelId"];
    self.channelTitle = [dict objectForKey:@"channelTitle"];
    self.playlistId = [dict objectForKey:@"playlistId"];
    self.publishedAt = [dict objectForKey:@"publishedAt"];
    self.title = [dict objectForKey:@"title"];
    
    NSDictionary *thumbnailsDict = [dict objectForKey:@"thumbnails"];
    NSDictionary *defaultDict = [thumbnailsDict objectForKey:@"default"];
    self.thumbnails = [defaultDict objectForKey:@"url"];
    
    self.videoID = [[dict objectForKey:@"resourceId"] objectForKey:@"videoId"];
}

/*
 @property (nullable, nonatomic, retain) NSString *title;
 @property (nullable, nonatomic, retain) NSString *descriptionStr;
 @property (nullable, nonatomic, retain) NSString *channelId;
 @property (nullable, nonatomic, retain) NSString *channelTitle;
 @property (nullable, nonatomic, retain) NSString *playlistId;
 @property (nullable, nonatomic, retain) NSString *publishedAt;
 @property (nullable, nonatomic, retain) NSString *thumbnails;
 @property (nullable, nonatomic, retain) NSString *url;
 @property (nullable, nonatomic, retain) NSString *videoId;
 
 */

#pragma Overide Default Functions

-(id)getCoreDataFromObject:(id) coreData
{
    YoutubeCD *cData = (YoutubeCD *) coreData;
    cData.title = self.title;
    cData.channelId = self.channelId;
    cData.channelTitle = self.channelTitle;
    
    
    cData.descriptionStr = self.channelDescription;
    cData.playlistId = self.playlistId;
    cData.publishedAt = self.publishedAt;
    
    cData.thumbnails = self.thumbnails;
    cData.url = self.thumbnails;
    cData.videoId = self.videoID;
    
    return cData;
}

-(void) populateObjectFromCorData:(id)coreData
{
    YoutubeCD *cData = (YoutubeCD *) coreData;
    self.title = cData.title;
    self.channelId = cData.channelId;
    self.channelTitle = cData.channelTitle;
    
    self.channelDescription = cData.descriptionStr;
    self.playlistId = cData.playlistId;
    self.publishedAt = cData.publishedAt;
    
    self.thumbnails = cData.thumbnails;
    self.thumbnails = cData.url;
    self.videoID = cData.videoId;
}

@end
