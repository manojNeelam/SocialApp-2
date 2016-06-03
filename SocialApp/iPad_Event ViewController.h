//
//  iPad_Event ViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface iPad_Event_ViewController : UIViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

}

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;


@end


















