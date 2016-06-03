//
//  EventsCD+CoreDataProperties.h
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EventsCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventsCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *pubDate;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *link;

@end

NS_ASSUME_NONNULL_END
