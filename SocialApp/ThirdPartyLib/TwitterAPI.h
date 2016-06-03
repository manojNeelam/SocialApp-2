//
//  TwitterAPI.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterAPIDelegate <NSObject>

- (void)twitterParsingFailWithError:(NSError *)error;
- (void)twitterParsingWithResponse:(NSMutableArray *)array;
- (void)isAlreadyFollowesResultWithBool:(BOOL )isFollowed;


@end

@interface TwitterAPI : NSObject

@property(nonatomic, retain) id<TwitterAPIDelegate> delegate;

- (void)getTwitterTimeline:(id)aDelegate;
- (void)followUs:(id)aDelegate;
//- (void)isAlreadyFollowed;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;
@end
