//
//  EventCoreService.m
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "EventCoreService.h"
#import "EventsCD.h"
#import "EventData.h"

@implementation EventCoreService

static EventCoreService *contact_Instance;
+ (EventCoreService *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[EventCoreService alloc] initWithDelegate:nil];
        return contact_Instance;
    }
}

-(id) initWithDelegate:(id<BaseCoreServiceDelegate>)delegate
{
    if(self)
    {
        self = [super initWithDelegate:delegate];
        if(self)
        {
            
        }
    }
    return self;
}

- (void) saveEventsListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (EventData *aData in dataList)
        {
            [self saveEventInDB:aData withError:&error];
        }
    }
}

-(EventsCD *) getEventBy:(NSString *)fbID
{
    if(!fbID)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(pubDate = %@)", fbID];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:EVENTS_COREDATA withPredicate:predicate];
    if(result)
        return (EventsCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveEventInDB:(EventData *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    EventsCD *oldAccount,*eventCD;
    oldAccount = [self getEventBy:contactObject.pubDate];
    if(!oldAccount)
    {
        eventCD = (EventsCD *) [NSEntityDescription insertNewObjectForEntityForName:EVENTS_COREDATA inManagedObjectContext:moContext];
    }
    else
        eventCD = oldAccount;
    
    
    eventCD = [contactObject getCoreDataFromObject:eventCD];
    
    if (![moContext save:error])
    {
        result = NO;
    }
    return result;
}

#pragma mark Fetch All Contact
- (NSArray *) fetchEventsList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:EVENTS_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllEventsList
{
    NSError *error;
    NSArray *cList = [self fetchEventsList];
    for (EventsCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
