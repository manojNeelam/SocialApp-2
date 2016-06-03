//
//  FacebookFeedData.m
//  SocialApp
//
//  Created by Pai, Ankeet on 10/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "FacebookFeedData.h"
#import "FacebookCD.h"

@implementation FacebookFeedData
@synthesize message, idStr, created_time, link, picture;

-(id)initwithDictionary:(NSDictionary *)dict
{
    [self parsedictionary:dict];
    return self;
}

-(void)parsedictionary:(NSDictionary *)param
{
    self.message = [param objectForKey:@"message"];
    self.idStr = [param objectForKey:@"id"];
    self.created_time = [param objectForKey:@"created_time"];
    self.link = [param objectForKey:@"link"];
    self.picture = [param objectForKey:@"picture"];
}

/*
 @property (nullable, nonatomic, retain) NSString *created_time;
 @property (nullable, nonatomic, retain) NSString *fbID;
 @property (nullable, nonatomic, retain) NSString *link;
 @property (nullable, nonatomic, retain) NSString *message;
 @property (nullable, nonatomic, retain) NSString *picture;
 
 */

#pragma Overide Default Functions

-(id)getCoreDataFromObject:(id) coreData
{
    FacebookCD *cData = (FacebookCD *) coreData;
    cData.created_time = self.created_time;
    cData.fbID = self.idStr;
    cData.link = self.link;
    cData.picture = self.picture;
    cData.message = self.message;
    
    return cData;
}

-(void) populateObjectFromCorData:(id)coreData
{
    FacebookCD *cData = (FacebookCD *) coreData;
    self.created_time = cData.created_time;
    self.idStr = cData.fbID;
    self.link = cData.link;
    self.picture = cData.picture;
    self.message = cData.message;
}
@end
