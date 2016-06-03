//
//  LinkedInAPI.m
//  SocialApp
//
//  Created by Syntel-Amargoal1 on 11/14/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import "LinkedInAPI.h"

@interface LinkedInAPI ()

@end

@implementation LinkedInAPI

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


/*



#import "TwitterAPI.h"
#import "STTwitter.h"
#import "STTwitterHTML.h"
#import "NSDateFormatter+STTwitter.h"
#import "ProgressHUD.h"


@interface TwitterAPI()

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
             [self.objectArray addObject:tempDict];
         }
         
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

















/*





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













/*



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
 
 */
