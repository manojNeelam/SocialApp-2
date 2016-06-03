//
//  TwitterCD+CoreDataProperties.h
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TwitterCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface TwitterCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *created_at;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *pubDate;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *link;

@end

NS_ASSUME_NONNULL_END
