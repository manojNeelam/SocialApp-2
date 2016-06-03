//
//  TwitterCoreService.m
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "TwitterCoreService.h"
#import "TwitterCD.h"
#import "TwitterData.h"

@implementation TwitterCoreService
static TwitterCoreService *contact_Instance;
+ (TwitterCoreService *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[TwitterCoreService alloc] initWithDelegate:nil];
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

- (void) saveTwitterListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (TwitterData *aData in dataList)
        {
            [self saveYoutubeInDB:aData withError:&error];
        }
    }
}

-(TwitterCD *) getTwitterBy:(NSString *)createdAt
{
    if(!createdAt)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(created_at = %@)", createdAt];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:TWITTER_COREDATA withPredicate:predicate];
    if(result)
        return (TwitterCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveYoutubeInDB:(TwitterData *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    TwitterCD *oldAccount,*youtubeCD;
    oldAccount = [self getTwitterBy:contactObject.created_at];
    if(!oldAccount)
    {
        youtubeCD = (TwitterCD *) [NSEntityDescription insertNewObjectForEntityForName:TWITTER_COREDATA inManagedObjectContext:moContext];
    }
    else
        youtubeCD = oldAccount;
    
    
    youtubeCD = [contactObject getCoreDataFromObject:youtubeCD];
    
    if (![moContext save:error])
    {
        result = NO;
    }
    return result;
}

#pragma mark Fetch All Contact
- (NSArray *) fetchTwitterList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:TWITTER_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllTwitterList
{
    NSError *error;
    NSArray *cList = [self fetchTwitterList];
    for (TwitterCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
