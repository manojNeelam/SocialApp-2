//
//  AppDelegate.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <FacebookSDK/FacebookSDK.h>
#import "TabBarController.h"
#import "ipad_Tab BarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) TabBarController *tabBarController;
@end
