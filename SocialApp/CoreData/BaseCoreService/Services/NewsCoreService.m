//
//  NewsCoreService.m
//  SocialApp
//
//  Created by Pai, Ankeet on 31/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "NewsCoreService.h"
#import "NewsCD.h"
#import "NewsData.h"

@implementation NewsCoreService
static NewsCoreService *contact_Instance;
+ (NewsCoreService *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[NewsCoreService alloc] initWithDelegate:nil];
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

- (void) saveNewsListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (NewsData *aData in dataList)
        {
            [self saveYoutubeInDB:aData withError:&error];
        }
    }
}

-(NewsCD *) getNewsBy:(NSString *)fbID
{
    if(!fbID)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(pubDate = %@)", fbID];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:NEWS_COREDATA withPredicate:predicate];
    if(result)
        return (NewsCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveYoutubeInDB:(NewsData *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    NewsCD *oldAccount,*youtubeCD;
    oldAccount = [self getNewsBy:contactObject.pubDate];
    if(!oldAccount)
    {
        youtubeCD = (NewsCD *) [NSEntityDescription insertNewObjectForEntityForName:NEWS_COREDATA inManagedObjectContext:moContext];
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
- (NSArray *) fetchNewsList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:NEWS_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllNewsList
{
    NSError *error;
    NSArray *cList = [self fetchNewsList];
    for (NewsCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
