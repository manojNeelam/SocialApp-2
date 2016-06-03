//
//  FacebookCoreService.m
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "FacebookCoreService.h"
#import "FacebookCD.h"
#import "FacebookFeedData.h"
#import "CoreDataConstants.h"

@implementation FacebookCoreService
static FacebookCoreService *contact_Instance;
+ (FacebookCoreService *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[FacebookCoreService alloc] initWithDelegate:nil];
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

- (void) saveFacebookListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (FacebookFeedData *aData in dataList)
        {
            [self saveYoutubeInDB:aData withError:&error];
        }
    }
}

-(FacebookCD *) getFacebookBy:(NSString *)fbID
{
    if(!fbID)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fbID = %@)", fbID];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:FB_COREDATA withPredicate:predicate];
    if(result)
        return (FacebookCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveYoutubeInDB:(FacebookFeedData *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    FacebookCD *oldAccount,*youtubeCD;
    oldAccount = [self getFacebookBy:contactObject.idStr];
    if(!oldAccount)
    {
        youtubeCD = (FacebookCD *) [NSEntityDescription insertNewObjectForEntityForName:FB_COREDATA inManagedObjectContext:moContext];
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
- (NSArray *) fetchFacebookList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:FB_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllFacebookList
{
    NSError *error;
    NSArray *cList = [self fetchFacebookList];
    for (FacebookCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
