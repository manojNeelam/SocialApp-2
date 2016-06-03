//
//  iPad_LinkedIn View Controller.h
//  SocialApp
//
//  Created by Syntel-Amargoal1 on 11/21/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import "EGORefreshTableHeaderView.h"
#import "BaseViewController.h"

@interface iPad_LinkedIn_View_Controller : UITableViewController <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
}
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@property (nonatomic, strong) OAuthLoginView *oAuthLoginView;
@property (nonatomic, strong) IBOutlet UITableView *linkdeinTableview;
@end
