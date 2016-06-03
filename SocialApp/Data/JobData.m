//
//  JobData.m
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "JobData.h"
#import "JobsCD.h"


@implementation JobData
@synthesize title, link, pubDate;

-(id)initwithDictionary:(NSDictionary *)dict
{
    [self parseDictionary:dict];
    return self;
}

-(void)parseDictionary:(NSDictionary *)dict
{
    self.title = [dict objectForKey:@"title"];
    self.link = [dict objectForKey:@"link"];
    self.pubDate = [dict objectForKey:@"pubDate"];
}

-(id)getCoreDataFromObject:(id) coreData
{
    JobsCD *cData = (JobsCD *) coreData;
    cData.title = self.title;
    cData.link = self.link;
    //cData.descriptionStr = self.descriptionStr;
    
    
    cData.pubDate = self.pubDate;
    //cData.guid = self.guid;
    
    return cData;
    
}

-(void) populateObjectFromCorData:(id)coreData
{
    JobsCD *cData = (JobsCD *) coreData;
    self.title = cData.title;
    self.link = cData.link;
    //self.descriptionStr = cData.descriptionStr;
    
    self.pubDate = cData.pubDate;
    //self.guid = cData.guid;
}
@end
