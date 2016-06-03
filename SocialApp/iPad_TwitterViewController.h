//
//  iPad_TwitterViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface iPad_TwitterViewController : UIViewController <EGORefreshTableHeaderDelegate>
{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    // Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
    
    BOOL _reloading;
}


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end