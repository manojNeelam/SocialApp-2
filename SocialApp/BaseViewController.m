//
//  BaseViewController.m
//  SocialApp
//
//  Created by Jiten on 09/01/15.
//  Copyright (c) 2015 KPMG. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIView *view;
    UIImage * _DefaultImage;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

            [[self.navigationController.view viewWithTag:124] removeFromSuperview];
        [self.navigationController.navigationBar setBackgroundImage:_DefaultImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) customizeNavigationControllerWith:(UIColor *)bgColor andImage:(NSString *)imgName
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.tag = 124;
    view.backgroundColor = bgColor;
    [self.navigationController.view addSubview:view];
    
    //[[UINavigationBar appearance] setBarTintColor:bgColor];
    
    _DefaultImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:imgName] forBarMetrics:UIBarMetricsDefault];
}

@end
