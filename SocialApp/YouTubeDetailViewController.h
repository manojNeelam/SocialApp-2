//
//  YouTubeDetailViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YTPlayerView.h"

@interface YouTubeDetailViewController : BaseViewController <UIWebViewDelegate>
@property (nonatomic, copy) NSString *youTubeLink;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *imgName;
@property (weak, nonatomic) IBOutlet YTPlayerView *ytPlayer;
@property (nonatomic, assign) BOOL isYoutube;


@property (nonatomic, weak) IBOutlet UIWebView *detailWebView;

@end
