//
//  MainCoreDataBase.h
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomError.h"
#import <CoreData/CoreData.h>

@interface MainCoreDataBase : NSObject
//Static
+(MainCoreDataBase *) sharedInstanse;
+(NSManagedObjectContext *) managedObjectContext;
+(NSNumber *) getUniqueRecordID;

//access by instane
-(NSManagedObjectContext *) getManageObjectContext;
-(id) getRecordFromDB:(NSString *) tblName withPredicate:(NSPredicate *) predicate;

-(NSArray *) getListFromDB:(NSString *) tblName withPredicate:(NSPredicate *) predicate;
-(NSArray *) getListFromDB:(NSString *) tblName withPredicate:(NSPredicate *) predicate sortDescriptor:(NSArray *) sortDescriptors;

+(BOOL) saveManagedObject:(NSManagedObject *) rec;
+(BOOL) deleteManagedObject:(NSManagedObject *) rec;
-(NSArray*) getUniqueValues:(NSString*) tblName forField:(NSString *) field withPredicate:(NSPredicate *) predicate;
- (void) flushDataBase;
@end
