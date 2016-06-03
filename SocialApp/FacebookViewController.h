//
//  FacebookViewController.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "BaseViewController.h"

@interface FacebookViewController : BaseViewController <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
}
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@property (weak, nonatomic) IBOutlet UIView *loginInfobasevIEW;

@end
