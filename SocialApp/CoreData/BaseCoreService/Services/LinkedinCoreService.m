//
//  LinkedinCoreService.m
//  SocialApp
//
//  Created by Pai, Ankeet on 30/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//

#import "LinkedinCoreService.h"
#import "LinkedinCD.h"
#import "LinkdeInObject.h"


@implementation LinkedinCoreService
static LinkedinCoreService *contact_Instance;
+ (LinkedinCoreService *) defaultInstance
{
    if(contact_Instance)
        return contact_Instance;
    else
    {
        contact_Instance = [[LinkedinCoreService alloc] initWithDelegate:nil];
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

- (void) saveLinkedinListFromJson:(NSArray *)dataList
{
    //if(dataList && dataList.count > 0)
    //{
    //delete old entries
    NSError *error ;
    if(dataList && dataList.count > 0)
    {
        for (LinkdeInObject *aData in dataList)
        {
            [self saveLinkedinInDB:aData withError:&error];
        }
    }
}

-(LinkedinCD *) getLinkedinCDBy:(NSString *)linkID
{
    if(!linkID)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(idStr = %@)", linkID];
    
    id result = [[MainCoreDataBase sharedInstanse] getRecordFromDB:LINKEDIN_COREDATA withPredicate:predicate];
    if(result)
        return (LinkedinCD *) result;
    
    return nil;
}

#pragma  Save Account into DB
-(BOOL) saveLinkedinInDB:(LinkdeInObject *) contactObject withError:(CustomError **) error
{
    BOOL result = YES;
    //Perform Offline
    LinkedinCD *oldAccount,*linkedinCD;
    oldAccount = [self getLinkedinCDBy:contactObject.idStr];
    if(!oldAccount)
    {
        linkedinCD = (LinkedinCD *) [NSEntityDescription insertNewObjectForEntityForName:LINKEDIN_COREDATA inManagedObjectContext:moContext];
    }
    else
        linkedinCD = oldAccount;
    
    
    linkedinCD = [contactObject getCoreDataFromObject:linkedinCD];
    
    if (![moContext save:error])
    {
        result = NO;
    }
    return result;
}

#pragma mark Fetch All Contact
- (NSArray *) fetchLinkedinList{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cfp_user = %@", loggedUser];
    NSArray *result = [[MainCoreDataBase sharedInstanse] getListFromDB:LINKEDIN_COREDATA withPredicate:nil];
    if(!result)
    {
        result = [[NSArray alloc] init];
    }
    return result;
}

- (void) deleteAllLinkedinList
{
    NSError *error;
    NSArray *cList = [self fetchLinkedinList];
    for (LinkedinCD *cData in cList)
    {
        [moContext deleteObject:cData];
    }
    if (![moContext save:&error])
    {
        
    }
}
@end
