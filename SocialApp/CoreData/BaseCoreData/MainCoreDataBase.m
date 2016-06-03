//
//  MainCoreDataBase.m
//  SocialApp
//
//  Created by Pai, Ankeet on 24/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "MainCoreDataBase.h"

@implementation MainCoreDataBase
static NSManagedObjectContext *__managedObjectContext;
static NSManagedObjectModel *__managedObjectModel;
static NSPersistentStoreCoordinator *__persistentStoreCoordinator;

static MainCoreDataBase *_instance;
+(MainCoreDataBase *) sharedInstanse
{
	if(!_instance)
    {
		_instance = [[MainCoreDataBase alloc] init];
    }
	return _instance;
}
+(NSManagedObjectContext *) managedObjectContext
{
	return  [[MainCoreDataBase sharedInstanse] getManageObjectContext];
}

-(id) init
{
	self = [super self];
	if(self)
	{
		[self getManageObjectContext];
	}
	return self;
}

-(NSManagedObjectContext *) getManageObjectContext
{
    if (__managedObjectContext)
	{
        return __managedObjectContext;
	}
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SocioCalyx" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SocioCalyx.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    return __persistentStoreCoordinator;
}

#pragma Get Record From DB
-(id) getRecordFromDB:(NSString *) tblName withPredicate:(NSPredicate *) predicate
{
	CustomError *error;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:tblName];
	if(predicate)
        [fetch setPredicate:predicate];
	fetch.fetchLimit = 1;
    NSArray *results = [[self getManageObjectContext] executeFetchRequest:fetch error:&error];
    if(results && [results count] > 0)
    {
		return [results objectAtIndex:0];
    }
	else if(error)
    {
        NSLog(@"Error: %@", error);
    }
    return nil;
}

#pragma Get List fromDB

-(NSArray *) getListFromDB:(NSString *) tblName withPredicate:(NSPredicate *) predicate sortDescriptor:(NSArray *) sortDescriptors
{
	CustomError *error;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:tblName];
	if(predicate)
		[fetch setPredicate:predicate];
	if(sortDescriptors)
		[fetch setSortDescriptors:sortDescriptors];
    
	NSArray *results = [[self getManageObjectContext] executeFetchRequest:fetch error:&error];
	if(error)
	{
		NSLog(@"Error in  %@ list retrival: %@",tblName, error);
        
	}
	return results;
}

-(NSArray *) getListFromDB:(NSString *) tblName withPredicate:(NSPredicate *) predicate
{
	CustomError *error;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:tblName];
	if(predicate)
        [fetch setPredicate:predicate];
    
	NSArray *results = [[self getManageObjectContext] executeFetchRequest:fetch error:&error];
	if(error)
    {
		NSLog(@"Error in  %@ list retrival: %@",tblName, error);
    }
	return results;
}

// Unique Negative record ID

+(NSNumber *) getUniqueRecordID
{
    NSDate *date = [NSDate date];
    NSTimeInterval ti =  ([date timeIntervalSince1970] * 10.0);
    return [NSNumber numberWithLongLong: -(long long)ti];
}

+(BOOL) saveManagedObject:(NSManagedObject *) rec
{
	NSError *error;
	if([rec.managedObjectContext save:&error])
		return YES;
    
	NSLog(@"Error in saving data:%@",[error localizedDescription]);
    
	return NO;
}

+(BOOL) deleteManagedObject:(NSManagedObject *) rec
{
	[rec.managedObjectContext deleteObject:rec];
	return YES;
}

-(NSArray*) getUniqueValues:(NSString*) tblName forField:(NSString *) field withPredicate:(NSPredicate *) predicate
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:tblName];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tblName inManagedObjectContext:[self getManageObjectContext]];
    
	fetchRequest.resultType = NSDictionaryResultType;
	fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:field]];
	fetchRequest.returnsDistinctResults = YES;
	if(predicate)
		[fetchRequest setPredicate:predicate];
    
	// Now it should yield an NSArray of distinct values in dictionaries.
	NSArray *dictionaries = [[self getManageObjectContext] executeFetchRequest:fetchRequest error:nil];
	if(!dictionaries || dictionaries.count == 0)
		return nil;
    
	return dictionaries;
}

- (void) flushDataBase
{
    [__managedObjectContext lock];
    NSArray *stores = [__persistentStoreCoordinator persistentStores];
    for(NSPersistentStore *store in stores) {
        [__persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    [__managedObjectContext unlock];
    __managedObjectModel    = nil;
    __managedObjectContext  = nil;
    __persistentStoreCoordinator = nil;
}
@end
