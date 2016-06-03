//
//  iPad_You tube detailViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"


@interface iPad_You_tube_detailViewController : UIViewController
@property (nonatomic, copy) NSString *youTubeLink;
@property (weak, nonatomic) IBOutlet YTPlayerView *ytPlayer;


@property (nonatomic, assign) BOOL isYoutubeVideo;
@end


