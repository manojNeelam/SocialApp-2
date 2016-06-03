//
//  NewsDetailViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewsDetailViewController : BaseViewController
@property(nonatomic, copy) NSString *link;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *imgName;
@end
