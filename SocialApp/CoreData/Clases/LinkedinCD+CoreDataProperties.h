//
//  LinkedinCD+CoreDataProperties.h
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LinkedinCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinkedinCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *descriptionStr;
@property (nullable, nonatomic, retain) NSString *eyebrowUrl;
@property (nullable, nonatomic, retain) NSString *thumbnailUrl;
@property (nullable, nonatomic, retain) NSString *timestamp;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *idStr;

@end

NS_ASSUME_NONNULL_END
