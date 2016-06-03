//
//  ViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//https://graph.facebook.com/250918001622520/feed?access_token=CAACEdEose0cBANiMl3ZBZCgRlZBvwEpfHZAfgdRvSCU1SQwgCeelrmp2r80HbjHhZBd5dsWnwF5xGnuDsADh4u0MrkONkFEb4w0p4XYZByVWNeax39YH1zBDgQsyhCBrXMSiYvt4wvvI1pPmSgIdGCfZBPiaevXRzyKMHwAgHAUIdplzxls0XxpDcH4M0lo1kR0QGCZC2YtVq9ctACUeWhGIc4YKzh9cVo0ZD

#import "HomeViewController.h"
#import "TwitterAPI.h"
#import "FollowUSViewController.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "TabBarController.h"
#import "ipad_Tab BarController.h"
#import <Foundation/NSNotificationQueue.h>

@interface HomeViewController ()<TwitterAPIDelegate>
{
    BOOL isFollowing;
}
@property (strong, nonatomic) IBOutlet UIButton *connectToFBButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *followOntwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *connectToLinkdein;
@property (weak, nonatomic) IBOutlet UIButton *likeLinkdein;
- (IBAction)onClickLinkdeinButton:(id)sender;
- (IBAction)onClickFollowLindeinButton:(id)sender;

@end

@implementation HomeViewController
@synthesize twitterAPI;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
      [self.navigationController setNavigationBarHidden:YES animated:NO];
    
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    currentlySelectedItem = kNothingSelected;

    twitterAPI = [[TwitterAPI alloc] init];
    twitterAPI.delegate = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        //[self checkFacebookSession];
        
    });
    
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)checkFacebookSession
{
    [self updateView];
    
    if (!APP_DELEGATE.session.isOpen)
    {
        // create a fresh session object
        APP_DELEGATE.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (APP_DELEGATE.session.state == FBSessionStateCreatedTokenLoaded)
        {
            // even though we had a cached token, we need to login to make the session usable
            [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session,
                                                              FBSessionState status,
                                                              NSError *error)
             {
                 // we recurse here, in order to update buttons and labels
                 [self updateView];
             }];
        }
    }
}*/

// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)connetToFBAction:(id)sender
{
    currentlySelectedItem = kFacebookSelected;
    
//    // this button's job is to flip-flop the session from open to closed
//    if (APP_DELEGATE.session.isOpen)
//    {
//        // if a user logs out explicitly, we delete any cached token information, and next
//        // time they run the applicaiton they will be presented with log in UX again; most
//        // users will simply close the app or switch away, without logging out; this will
//        // cause the implicit cached-token login to occur on next launch of the application
//        [APP_DELEGATE.session closeAndClearTokenInformation];
//        
//    }
//    else
//    {
        /*if (APP_DELEGATE.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            APP_DELEGATE.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error)
         {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
             
        }];*/
//    }
}

- (IBAction)goToApp:(id)sender
{
//    UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//    TabBarController *tabBarControllerv= [strotyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:APP_DELEGATE.tabBarController animated:YES];

}
- (IBAction)likeOnFB:(id)sender
{
    /*[FBSession setActiveSession:APP_DELEGATE.session];
    
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceEveryone
                                        completionHandler:^(FBSession *session, NSError *error)
     {
         if (!error && [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] != NSNotFound)
         {
             // Now have the permission
             //[self postOpenGraphAction];
             [self like];
         }
         else if (error)
         {
             // Facebook SDK * error handling *
             // if the operation is not user cancelled
             if ([FBErrorUtility errorCategoryForError:error] != FBErrorCategoryUserCancelled)
             {
                 NSLog(@"MajorError: %@", error);
             }
         }
     }];*/
    

    
    // use only for webview opne link
    
    
    // for iPad identification
    
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
    
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"FollowUSViewController"];
        newsDetailVC.link = LIKE_FACEBOOK_LINK;
        newsDetailVC.title = @"Like on Facebook";
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    
    } else
    {
    
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"iPad_FollowUS_ViewController"];
        newsDetailVC.link = LIKE_FACEBOOK_LINK;
        newsDetailVC.title = @"Like on Facebook";
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}

/*- (void)like
{
    FBGraphObject *objectToLike = [[FBGraphObject alloc]initWithContentsOfURL:[NSURL URLWithString:LIKE_FACEBOOK_LINK]];
    
    FBRequest *requestLike = [[FBRequest alloc]initForPostWithSession:[FBSession activeSession] graphPath:@"me/og.likes" graphObject:objectToLike];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:requestLike
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error &&
             result)
         {
             
             NSLog(@"NothingWentWrong");
         }
         
         NSLog(@"MajorError: %@", error);
         
     }
     ];
    
    [connection start];
    
    NSString *urlToLikeFor = @"590504340982217";
    
    NSString *theWholeUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me/og.likes?object=%@&access_token=%@", urlToLikeFor, FBSession.activeSession.accessTokenData.accessToken];
    NSLog(@"TheWholeUrl: %@", theWholeUrl);
    
    NSURL *facebookUrl = [NSURL URLWithString:theWholeUrl];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:facebookUrl];
    [req setHTTPMethod:@"POST"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    NSString *content = [NSString stringWithUTF8String:[responseData bytes]];
    
    NSLog(@"responseData: %@", content);
}
 */

- (IBAction)followOnTwitterButtonAction:(id)sender
{
    currentlySelectedItem = kTwitterSelected;

    twitterAPI = [[TwitterAPI alloc] init];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [twitterAPI followUs:self];
    });

}


// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
/*- (void)updateView
{
    // get the app delegate, so that we can reference the session property
    if (APP_DELEGATE.session.isOpen)
    {
        // valid account UI is shown whenever the session is open
        //[self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        //[self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/likes?access_token=%@",appDelegate.session.accessTokenData.accessToken]];
        //NSLog(@"%@",self.textNoteOrLink.text);
        
        NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/likes?access_token=%@",APP_DELEGATE.session.accessTokenData.accessToken];
        
        NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
        
        NSRange start = [str rangeOfString:@"250918001622520"];
        if (start.location == NSNotFound)
        {
            [_likeButton setImage:[UIImage imageNamed:@"like_facebook.png"] forState:UIControlStateNormal];
            [_likeButton setEnabled:YES];

        }
        else
        {
            [_likeButton setImage:[UIImage imageNamed:@"like_facebook_disable.png"] forState:UIControlStateNormal];
            [_likeButton setEnabled:NO];
        }

        [_connectToFBButton setImage:[UIImage imageNamed:@"connect_facebook_disable.png"] forState:UIControlStateNormal];
        [_connectToFBButton setEnabled:NO];

    }
    else
    {
        // login-needed account UI is shown whenever the session is closed
        //[self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
        //[self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
        
        [_connectToFBButton setImage:[UIImage imageNamed:@"connect_facebook.png"] forState:UIControlStateNormal];
        [_connectToFBButton setEnabled:YES];
        
        [_likeButton setImage:[UIImage imageNamed:@"like_facebook_disable.png"] forState:UIControlStateNormal];
        [_likeButton setEnabled:NO];
    }
}*/

#pragma mark - Twitter method

- (void)twitterParsingFailWithError:(NSError *)error
{
    [ProgressHUD hideHUD];
    [[[UIAlertView alloc] initWithTitle:NETWORK_CONNECTION_TITLE message:NETWORK_CONNECTION_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
}

- (void)twitterParsingWithResponse:(NSMutableArray *)array
{
    [ProgressHUD hideHUD];
    
 /*   UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
     FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"FollowUSViewController"];
    newsDetailVC.link = @"https://api.twitter.com/1.1/friendships/create.json?screen_name=SYNTEL";//[[array objectAtIndex:0] valueForKey:@"link"];
    newsDetailVC.title = @"Follow us";
    [self.navigationController pushViewController:newsDetailVC animated:YES];

    */
    
    
    //Amar changes
    
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone){
    
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"FollowUSViewController"];
        newsDetailVC.link = @"https://api.twitter.com/1.1/friendships/create.json?screen_name=SYNTEL";//[[array objectAtIndex:0] valueForKey:@"link"];
        newsDetailVC.title = @"Follow us";
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }else
    
    {
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"iPad_FollowUS_ViewController"];
        newsDetailVC.link = @"https://api.twitter.com/1.1/friendships/create.json?screen_name=SYNTEL";//[[array objectAtIndex:0] valueForKey:@"link"];
        newsDetailVC.title = @"Follow us";
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}

- (void)isAlreadyFollowesResultWithBool:(BOOL )isFollowed
{
    if(isFollowed)
    {
        [_followOntwitterButton setImage:[UIImage imageNamed:@"follow_us_disable.png"] forState:UIControlStateNormal];
        [_followOntwitterButton setEnabled:NO];

    }
    else
    {
        [_followOntwitterButton setImage:[UIImage imageNamed:@"follow_us.png"] forState:UIControlStateNormal];
        [_followOntwitterButton setEnabled:YES];

    }
}

- (IBAction)onClickLinkdeinButton:(id)sender {
    
    self.oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:@"OAuthLoginView" bundle:nil];

    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:self.oAuthLoginView];
    
    [self presentViewController:self.oAuthLoginView animated:YES completion:nil];
}

-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self checkIsUserFollowingCompany];
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates	
}


- (IBAction)onClickFollowLindeinButton:(id)sender {
    
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
            UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"FollowUSViewController"];
            newsDetailVC.link = LIKE_LINKDEIN_LINK;
            newsDetailVC.title = @"Like on LinkdeIn";
            [self.navigationController pushViewController:newsDetailVC animated:YES];
            
        }
    else
        {
            UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            FollowUSViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"iPad_FollowUS_ViewController"];
            newsDetailVC.link = LIKE_LINKDEIN_LINK;
            newsDetailVC.title = @"Like on LinkdeIn";
            [self.navigationController pushViewController:newsDetailVC animated:YES];
        }
    }
    
    
   /*if(isFollowing)
   {
       //https://api.linkedin.com/v1/people/~/following/companies/id={id}
       
       NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/following/companies/id=4280"];
       OAMutableURLRequest *request =
       [[OAMutableURLRequest alloc] initWithURL:url
                                       consumer:self.oAuthLoginView.consumer
                                          token:self.oAuthLoginView.accessToken
                                       callback:nil
                              signatureProvider:nil];
       
       [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
       
       [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       [request setHTTPMethod:@"DELETE"];
       OADataFetcher *fetcher = [[OADataFetcher alloc] init];
       [fetcher fetchDataWithRequest:request
                            delegate:self
                   didFinishSelector:@selector(companieUnFollowApiCallResult:didFinish:)
                     didFailSelector:@selector(companieUnFollowApiCallResult:didFail:)];
       
   }
    else
    {
        //https://api.linkedin.com/v1/people/~/following/companies
        NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/following/companies"];
        OAMutableURLRequest *request =
        [[OAMutableURLRequest alloc] initWithURL:url
                                        consumer:self.oAuthLoginView.consumer
                                           token:self.oAuthLoginView.accessToken
                                        callback:nil
                               signatureProvider:nil];
        
        [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
        
        NSDictionary *eventDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"4280",@"id", nil];
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:eventDict options:0 error:nil];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(companieFollowApiCallResult:didFinish:)
                      didFailSelector:@selector(companieFollowApiCallResult:didFail:)];
    }*/

/*- (void)companieUnFollowApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    isFollowing = NO;
}

- (void)companieUnFollowApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    isFollowing = YES;
}

- (void)companieFollowApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    isFollowing = YES;
}

- (void)companieFollowApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    isFollowing = NO;
}*/

- (void)checkIsUserFollowingCompany
{
    NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/following/companies"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.oAuthLoginView.consumer
                                       token:self.oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(companiesApiCallResult:didFinish:)
                  didFailSelector:@selector(companiesApiCallResult:didFail:)];
    
}

- (void)companiesApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    NSArray *arrayCompanies = [profile objectForKey:@"values"];
    if([arrayCompanies count] > 0)
    {
        NSDictionary *dict;
        for(dict in arrayCompanies)
        {
            NSString *companyIDString = [[dict objectForKey:@"id"] stringValue];
            if([companyIDString isEqualToString:@"4280"])
            {
                isFollowing = YES;
                break;
            }
        }
    }
    else
    {
        isFollowing = NO;
    }
}

- (void)companiesApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)data
{
    //NSString *responseBody = [[NSString alloc] initWithData:data
                                                 //  encoding:NSUTF8StringEncoding];
    //NSDictionary *profile = [responseBody objectFromJSONString];
}

@end
