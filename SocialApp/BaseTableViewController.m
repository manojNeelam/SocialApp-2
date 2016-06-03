//
//  BaseTableViewController.m
//  SocialApp
//
//  Created by Jiten on 09/01/15.
//  Copyright (c) 2015 KPMG. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
{
    UIView *view;
}
@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [view removeFromSuperview];
}

- (void) customizeNavigationControllerWith:(UIColor *)bgColor
{
    view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.tag = 124;
    view.backgroundColor = bgColor;
    [self.navigationController.view addSubview:view];
}

@end
