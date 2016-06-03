//
//  FacebookFeedData.h
//  SocialApp
//
//  Created by Pai, Ankeet on 10/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookFeedData : NSObject
@property (nonatomic, strong) NSString *created_time, *idStr, *message, *link, *picture;

-(id)initwithDictionary:(NSDictionary *)dict;

-(id)getCoreDataFromObject:(id) coreData;
-(void) populateObjectFromCorData:(id)coreData;
@end
