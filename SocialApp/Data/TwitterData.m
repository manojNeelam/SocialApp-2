//
//  TwitterData.m
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "TwitterData.h"
#import "TwitterCD.h"

@implementation TwitterData
@synthesize text, created_at, pubDate, url, link;

-(id)initwithDictionary:(NSDictionary *)dict
{
    [self parseDictionary:dict];
    return self;
}

-(void)parseDictionary:(NSDictionary *)dict
{
    self.text = [dict objectForKey:@"title"];
    self.link = [dict objectForKey:@"link"];
    self.pubDate = [dict objectForKey:@"pubDate"];
    self.url = [dict objectForKey:@"url"];
}

-(id)getCoreDataFromObject:(id) coreData
{
    TwitterCD *cData = (TwitterCD *) coreData;
    cData.title = self.text;
    cData.link = self.link;
    //cData.descriptionStr = self.descriptionStr;
    
    
    cData.pubDate = self.pubDate;
    cData.url = self.url;
    
    return cData;
    
}

-(void) populateObjectFromCorData:(id)coreData
{
    TwitterCD *cData = (TwitterCD *) coreData;
    self.text = cData.title;
    self.link = cData.link;
    //self.descriptionStr = cData.descriptionStr;
    
    self.pubDate = cData.pubDate;
    self.url = cData.url;
}

@end
