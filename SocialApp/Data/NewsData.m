//
//  NewsData.m
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "NewsData.h"
#import "NewsCD.h"


@implementation NewsData
@synthesize title, link, descriptionStr, pubDate, guid;

-(id)initwithDictionary:(NSDictionary *)dict
{
    [self parseDictionary:dict];
    return self;
}

-(void)parseDictionary:(NSDictionary *)dict
{
    self.title = [dict objectForKey:@"title"];
    self.link = [dict objectForKey:@"link"];
    self.descriptionStr = [dict objectForKey:@"description"];
    self.pubDate = [dict objectForKey:@"pubDate"];
    self.guid = [dict objectForKey:@"guid"];
}

-(id)getCoreDataFromObject:(id) coreData
{
    NewsCD *cData = (NewsCD *) coreData;
    cData.title = self.title;
    cData.link = self.link;
    //cData.descriptionStr = self.descriptionStr;
    
    
    cData.pubDate = self.pubDate;
    //cData.guid = self.guid;
    
    return cData;
    
}

-(void) populateObjectFromCorData:(id)coreData
{
    NewsCD *cData = (NewsCD *) coreData;
    self.title = cData.title;
    self.link = cData.link;
    //self.descriptionStr = cData.descriptionStr;
    
    self.pubDate = cData.pubDate;
    //self.guid = cData.guid;
}
@end
