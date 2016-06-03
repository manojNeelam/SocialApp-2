//
//  JobData.h
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobData : NSObject
@property (nonatomic, strong) NSString *title, *link, *pubDate;

-(id)initwithDictionary:(NSDictionary *)dict;
-(id)getCoreDataFromObject:(id) coreData;
-(void) populateObjectFromCorData:(id)coreData;
@end
