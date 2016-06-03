//
//  FacebookCD+CoreDataProperties.h
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FacebookCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacebookCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *created_time;
@property (nullable, nonatomic, retain) NSString *fbID;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *picture;

@end

NS_ASSUME_NONNULL_END
