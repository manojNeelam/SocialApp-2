//
//  LinkdeInObject.h
//  SocialApp
//
//  Created by Jiten on 27/12/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkdeInObject : NSObject
@property (nonatomic, strong) NSString *descriptionStr, *titleStr, *imageStr, *dateStr, *url, *timeStamp, *idStr;

-(id)getCoreDataFromObject:(id) coreData;
-(void) populateObjectFromCorData:(id)coreData;
@end
