//
//  TwitterData.h
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterData : NSObject
@property (nonatomic, strong) NSString *text, *created_at, *pubDate, *url, *link;
-(id)initwithDictionary:(NSDictionary *)dict;
-(id)getCoreDataFromObject:(id) coreData;
-(void) populateObjectFromCorData:(id)coreData;

@end
