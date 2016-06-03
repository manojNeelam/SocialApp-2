//
//  YoutubeCoreService.m
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "YoutubeCoreService.h"
#import "YoutubeData.h"
#import "YoutubeCD.h"

@implementation YoutubeCoreService
static YoutubeCoreService *contact_Instance;
+ (YoutubeCoreService *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[YoutubeCoreService alloc] initWithDelegate:nil];
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

- (void) saveYoutubeListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (YoutubeData *aData in dataList)
        {
            [self saveYoutubeInDB:aData withError:&error];
        }
    }
}

-(YoutubeCD *) getYoutubeBy:(NSString *)fbID
{
    if(!fbID)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fbID = %@)", fbID];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:YOUTUBE_COREDATA withPredicate:predicate];
    if(result)
        return (YoutubeCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveYoutubeInDB:(YoutubeData *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    YoutubeCD *oldAccount,*youtubeCD;
    //oldAccount = [self getYoutubeBy:contactObject.idStr];
    if(!oldAccount)
    {
        youtubeCD = (YoutubeCD *) [NSEntityDescription insertNewObjectForEntityForName:YOUTUBE_COREDATA inManagedObjectContext:moContext];
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
- (NSArray *) fetchYoutubeList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:YOUTUBE_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllYoutubeList
{
    NSError *error;
    NSArray *cList = [self fetchYoutubeList];
    for (YoutubeCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
