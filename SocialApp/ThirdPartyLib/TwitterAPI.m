
//  TwitterAPI.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//


#import "TwitterAPI.h"
#import "STTwitter.h"
#import "STTwitterHTML.h"
#import "NSDateFormatter+STTwitter.h"
#import "ProgressHUD.h"

#import "TwitterCD.h"
#import "TwitterData.h"
#import "TwitterCoreService.h"

@interface TwitterAPI()
{
    TwitterCoreService *twitterCoreService;
}
@property(nonatomic, retain) NSMutableString *currentElementValue;
@property(nonatomic, retain) NSMutableArray *objectArray;
@property(nonatomic, retain) NSMutableDictionary *facebookObjectDict;
@property (nonatomic, retain) STTwitterAPI *twitter;
@property (nonatomic, retain) STTwitterHTML *sTTwitterHTML;
@property (nonatomic, retain) NSString *userName;


@end

@implementation TwitterAPI
@synthesize objectArray;
@synthesize facebookObjectDict;
@synthesize twitter;
@synthesize sTTwitterHTML;
@synthesize userName;


- (id)init
{
    self = [super init];
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"a7pxQYQM8OaRgt3ehbU5fQ" consumerSecret:@"9eQqnz3rFW59zy9p24m3tw9j8i6Uj8s9eBLi5Ivk"];
    
    return self;
}


- (void)getTwitterTimeline:(id)aDelegate
{
    twitterCoreService = [TwitterCoreService defaultInstance];
    
    objectArray = [[NSMutableArray alloc] init];
    self.delegate =aDelegate;
    
     [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"a7pxQYQM8OaRgt3ehbU5fQ"             consumerSecret:@"9eQqnz3rFW59zy9p24m3tw9j8i6Uj8s9eBLi5Ivk"
                        oauthToken:@"916363922-UIqFLgJtn1SjSbldnkbRSvFZ5xyFAikZUo8zzUxl" oauthTokenSecret:@"wKSIw4iUI3v0zsGw3VjNsPB6K8Wyn3sRIhYH2WE"
                    ];
    
    [self.twitter getUserTimelineWithScreenName:@"SYNTEL" count:50 successBlock:^(NSArray *statuses)
    {
                            
        NSLog(@"-- statuses: %@", statuses);
        for(NSDictionary *dict in statuses)
        {
            NSString *title = [NSString stringWithFormat:@"%@", [dict valueForKey:@"text"]];
            
            //Update on may 2014 by Amar
            
            title = [title stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            title = [title stringByReplacingOccurrencesOfString:@"#" withString:@""];
            title = [title stringByReplacingOccurrencesOfString:@"&" withString:@""];
            title = [title stringByReplacingOccurrencesOfString:@"@" withString:@""];
            
            
            NSString *subtitle = [NSString stringWithFormat:@"%@", [dict valueForKey:@"created_at"]];
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setObject:title forKey:@"title"];
            
            NSLog(@"date string = %@",subtitle);
            
            NSDateFormatter *dateFormatter = [NSDateFormatter stTwitterDateFormatter];
            NSDate *date = [dateFormatter dateFromString:subtitle];
            
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"dd MMM YYYY"];
            NSString *dateString = [dateFormatter1 stringFromDate:date];
            [tempDict setObject:[NSString stringWithFormat:@"%@",dateString] forKey:@"pubDate"];
            
            NSArray *arr = [[dict valueForKey:@"entities"] valueForKey:@"urls"];
            NSString *link = @"";
            if([arr count])
            {
                link = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:0] valueForKey:@"url"]];
            }
            
            [tempDict setObject:link forKey:@"link"];
            
            //
            
            TwitterData *twitterData = [[TwitterData alloc] initwithDictionary:tempDict];
            [self.objectArray addObject:twitterData];
        }
        
        
        [twitterCoreService saveTwitterListFromJson:self.objectArray];
        
        [self.delegate twitterParsingWithResponse:self.objectArray];
    }
    errorBlock:^(NSError *error)
     {
         [self.delegate twitterParsingFailWithError:error];
    }];
}










- (void)followUs:(id)aDelegate
{
    self.delegate =aDelegate;

    //self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"a7pxQYQM8OaRgt3ehbU5fQ" consumerSecret:@"9eQqnz3rFW59zy9p24m3tw9j8i6Uj8s9eBLi5Ivk"];
    
    
    // used for login with safari
    [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken)
     {
         NSLog(@"-- url: %@", url);
         NSLog(@"-- oauthToken: %@", oauthToken);
         [[UIApplication sharedApplication] openURL:url];
     }
    oauthCallback:@"myapp://twitter_access_tokens/"errorBlock:^(NSError *error)
     {
         NSLog(@"-- error: %@", error);
         [[[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
     }];
    
   /* [ProgressHUD showHUD:LOADING_MSG];
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username1)
     {
         [self follow];
    }
    errorBlock:^(NSError *error)
    {
        [ProgressHUD hideHUD];
        NSLog(@"-- user: %@", [error description]);
        [self.delegate isAlreadyFollowesResultWithBool:NO];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login in twitter account in setting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];*/
}

// this method call when return from safari after login from appDelegate
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier
{
    
    [self.twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName)
     {
         NSLog(@"-- screenName: %@", screenName);
         [self checkFollowedOrNOT:screenName];
     }
    errorBlock:^(NSError *error)
     {
         NSLog(@"-- %@", [error localizedDescription]);
//         [[[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

     }];
}

/*-(void)isAlreadyFollowed
{
   // [ProgressHUD showHUD:LOADING_MSG];

    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username1)
     {
         [self checkFollowedOrNOT:username1];
     }
        errorBlock:^(NSError *error)
     {
         [ProgressHUD hideHUD];

         NSLog(@"-- user: %@", [error description]);
         [self.delegate isAlreadyFollowesResultWithBool:NO];

         
     }];

}*/

- (void)checkFollowedOrNOT:(NSString *)userName1
{
    [self.twitter getFriendsIDsForScreenName:userName1 successBlock:^(NSArray *friends)
     {
         [ProgressHUD hideHUD];
        // NSLog(@"-- user: %@", friends);
         if([friends containsObject:SYNTEL_PAGE_ID])
         {
             //[self.delegate isAlreadyFollowesResultWithBool:YES];
             [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You already following Syntel!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
         }
         else
         {
             //[self.delegate isAlreadyFollowesResultWithBool:NO];
             [self follow];
         }
        

    } errorBlock:^(NSError *error)
    {
        [ProgressHUD hideHUD];

       // NSLog(@"-- user: %@", error);
       // [self.delegate isAlreadyFollowesResultWithBool:NO];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

    }];
}

// follow us method
- (void)follow
{
    [self.twitter postFollow:@"SYNTEL" successBlock:^(NSDictionary *user)
     {
         [ProgressHUD hideHUD];
         //NSLog(@"-- user: %@", user);
         //[self.delegate isAlreadyFollowesResultWithBool:YES];
         [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Thank you for following Syntel!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
     }
                  errorBlock:^(NSError *error)
     {
         [ProgressHUD hideHUD];
         //NSLog(@"-- user: %@", error);
         //[self.delegate isAlreadyFollowesResultWithBool:NO];
         
         [[[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
     }];
}


//------------------------------------------------------------------------------------------------------------------------


@end
