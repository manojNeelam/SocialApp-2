//
//  iPad_Home ViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 30/06/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterAPI.h"
#import "TwitterAPI.h"
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"


@interface iPad_Home_ViewController : UIViewController
@property(nonatomic, retain)TwitterAPI *twitterAPI;
@property (nonatomic, strong) OAuthLoginView *oAuthLoginView;

@end



