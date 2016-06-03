//
//  TabBarController.h
//  xmlDemo
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController
{
    UIView *view;
    UIImage * _DefaultImage;
}
- (void) customizeNavigationControllerWith:(UIColor *)bgColor andImage:(NSString *)imgName;
@end
