//
//  iPad_FacebookViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface iPad_FacebookViewController : UIViewController<EGORefreshTableHeaderDelegate>
{
 
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (weak, nonatomic) IBOutlet UIView *loginInfobasevIEW;

@end



