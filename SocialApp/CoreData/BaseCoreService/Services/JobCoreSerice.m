//
//  JobCoreSerice.m
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "JobCoreSerice.h"
#import "JobData.h"
#import "JobsCD.h"

@implementation JobCoreSerice
static JobCoreSerice *contact_Instance;
+ (JobCoreSerice *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[JobCoreSerice alloc] initWithDelegate:nil];
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

- (void) saveJobListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (JobData *aData in dataList)
        {
            [self saveYoutubeInDB:aData withError:&error];
        }
    }
}

-(JobsCD *) getJobBy:(NSString *)fbID
{
    if(!fbID)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(pubDate = %@)", fbID];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:JOBS_COREDATA withPredicate:predicate];
    if(result)
        return (JobsCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveYoutubeInDB:(JobData *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    JobsCD *oldAccount,*youtubeCD;
    oldAccount = [self getJobBy:contactObject.pubDate];
    if(!oldAccount)
    {
        youtubeCD = (JobsCD *) [NSEntityDescription insertNewObjectForEntityForName:JOBS_COREDATA inManagedObjectContext:moContext];
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
- (NSArray *) fetchJobList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:JOBS_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllJobList
{
    NSError *error;
    NSArray *cList = [self fetchJobList];
    for (JobsCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
