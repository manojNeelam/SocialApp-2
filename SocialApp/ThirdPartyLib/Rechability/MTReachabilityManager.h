//
//  MTReachabilityManager.h
//  SocialApp
//
//  Created by Pai, Ankeet on 18/05/16.
//  Copyright © 2016 KPMG. All rights reserved.
//
@class Reachability;

#import <Foundation/Foundation.h>

@interface MTReachabilityManager : NSObject
@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (MTReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;
@end
