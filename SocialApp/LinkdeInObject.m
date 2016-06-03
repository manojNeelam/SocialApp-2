//
//  LinkdeInObject.m
//  SocialApp
//
//  Created by Jiten on 27/12/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import "LinkdeInObject.h"

#import "LinkedinCD.h"

@implementation LinkdeInObject
@synthesize descriptionStr, titleStr, imageStr, dateStr, url, timeStamp, idStr;

/*
 @property (nullable, nonatomic, retain) NSString *timestamp;
 @property (nullable, nonatomic, retain) NSString *title;
 @property (nullable, nonatomic, retain) NSString *descriptionStr;
 @property (nullable, nonatomic, retain) NSString *thumbnailUrl;
 @property (nullable, nonatomic, retain) NSString *eyebrowUrl;
 
 */

#pragma Overide Default Functions

-(id)getCoreDataFromObject:(id) coreData
{
    LinkedinCD *cData = (LinkedinCD *) coreData;
    
    id _timeStamp = self.timeStamp;
    if([_timeStamp isKindOfClass:[NSNumber class]])
    {
        cData.timestamp = [_timeStamp stringValue];
    }
    else
    {
        cData.timestamp = self.timeStamp;
    }
    
    cData.title = self.titleStr;
    cData.descriptionStr = self.descriptionStr;
    cData.thumbnailUrl = self.imageStr;
    cData.eyebrowUrl = self.url;
    cData.idStr = self.idStr;
    
    return cData;
}

-(void) populateObjectFromCorData:(id)coreData
{
    LinkedinCD *cData = (LinkedinCD *) coreData;
    self.timeStamp = cData.timestamp;
    self.titleStr = cData.title;
    self.descriptionStr = cData.descriptionStr;
    self.imageStr = cData.thumbnailUrl;
    self.url = cData.eyebrowUrl;
    self.idStr = cData.idStr;
}
@end
