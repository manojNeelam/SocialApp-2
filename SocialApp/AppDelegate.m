//
//  AppDelegate.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "TabBarController.h"
#import "ipad_Tab BarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppConstants.h"
#import "MTReachabilityManager.h"

@implementation AppDelegate
//@synthesize session = _session;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MTReachabilityManager sharedManager];
    
    [self saveDefaultFBAccessToken];
    
    [self.tabBarController setDelegate:self];
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone) {
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        self.tabBarController = [strotyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
        return YES;
    }
    else
    {
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        self.tabBarController=[strotyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
        return YES;
    }
    tabBarController.moreNavigationController.navigationBar.tintColor = [UIColor blackColor];

    
    //UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
  //  self.tabBarController = [strotyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    // Override point for customization after application launch.
   // return YES;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

-(void)saveDefaultFBAccessToken
{
    //EAAKyDcJMimYBAD2zHOeYdICUZCg3l97EGzAl3ZCCSYYzmAlBibrhZBGKjbS649ssLcePen2FalDfxEPXitIsl48eAxrmiDUEKEGM9wssKdhgLNEJH1f3kJShgZBaZBwmvuX5kTnrghYVVSkGZATe6WGyjYWZA48hWrZABrRHSlwl6gZDZD
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:APP_FACEBOOK_USER_TOKEN];
    if(!token || token == nil)
    {
        NSString *defaultToken = @"EAAKyDcJMimYBAGrUBRhJL3Xh8TBxmLs1bysIlVIg7ASbvvUd9ZBMvZA0YDi7egoMCIZCd9t8KIp3TUjAOc2QjFkjZAmu0SR7XcH9cuZCLgBJT8UU8DwtI7fZAqYQF47LVDFZBlxutZBsgJzn6MREZCU9PGeBKmlA38nvahAH7IlWwxwZDZD";
        [defaults setObject:defaultToken forKey:APP_FACEBOOK_USER_TOKEN];
        [defaults synchronize];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[self.session close];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(currentlySelectedItem == kFacebookSelected)
    {
    // attempt to extract a token from the url
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    else if(currentlySelectedItem == kTwitterSelected)
    {
        if ([[url scheme] isEqualToString:@"myapp"] == NO)
            return NO;
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
        
        NSString *token = d[@"oauth_token"];
        NSString *verifier = d[@"oauth_verifier"];
        
        UINavigationController *nv = (UINavigationController *)[[self window] rootViewController];
        HomeViewController *vc = [nv.viewControllers objectAtIndex:0];

        [vc.twitterAPI setOAuthToken:token oauthVerifier:verifier];
        
        return YES;

    }
    
    return YES;

}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString
{
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

// returns the feeds for Twitter
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[viewController navigationController] popToRootViewControllerAnimated:NO];
}

@end
