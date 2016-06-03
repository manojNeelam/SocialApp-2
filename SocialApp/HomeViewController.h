//
//  ViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterAPI.h"
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"


@interface HomeViewController : UIViewController
@property(nonatomic, retain)TwitterAPI *twitterAPI;
@property (nonatomic, strong) OAuthLoginView *oAuthLoginView;
@end
