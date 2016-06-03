//
//  YoutubeCD+CoreDataProperties.h
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "YoutubeCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoutubeCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *descriptionStr;
@property (nullable, nonatomic, retain) NSString *channelId;
@property (nullable, nonatomic, retain) NSString *channelTitle;
@property (nullable, nonatomic, retain) NSString *playlistId;
@property (nullable, nonatomic, retain) NSString *publishedAt;
@property (nullable, nonatomic, retain) NSString *thumbnails;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *videoId;

@end

NS_ASSUME_NONNULL_END
