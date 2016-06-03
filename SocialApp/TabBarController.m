//
//  TabBarController.m
//  xmlDemo
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "TabBarController.h"
#import "JobsViewController.h"
#import "EventViewController.h"
#import "YouTubeDetailViewController.h"
#import "LinkedIn View Controller.h"
#import "FacebookViewController.h"
#import "TwitterViewController.h"
#import "NewsDetailViewController.h"
#import "NewsViewController.h"

@interface TabBarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>

@end

@implementation TabBarController

- (void) customizeNavigationControllerWith:(UIColor *)bgColor andImage:(NSString *)imgName
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self.navigationController.view viewWithTag:124] removeFromSuperview];
    [self.navigationController.navigationBar setBackgroundImage:_DefaultImage forBarMetrics:UIBarMetricsDefault];
}*/

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(view)
    {
        [view removeFromSuperview];
    }
}
- (void)viewDidLoad
{
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewController:) name:POPV_VIEW_CONTROLLER object:nil];
    
    self.moreNavigationController.delegate = self;
    
    //Amar changes
    
    
   
    
   if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        
        //[[UITabBarItem appearance] setSelectedImage.ColorWithRGB
        
        
        
        //[UITabBarItem.item select(1,@"facebook",@"Twitter",@"Youtube", @"Events",@"News",@"Jobs")];
        
        // [[UITabBar appearance] setTintColor:[UIColor cyanColor]];
        
        // [UITabBar appearance].barTintColor = [UIColor blackColor];
        // [[UITabBar appearance] setTintColor:[UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1]];
        
        
        
        NSUInteger selectedIndex = self.tabBarController.selectedIndex;
        
        
        switch (selectedIndex) {
                
            case 0:
                //configure me
                 [UITabBar appearance].barTintColor = [UIColor blackColor];
                 [[UITabBar appearance] setTintColor:[UIColor colorWithRed:141 green:182 blue:0 alpha:1]];
                [[UITabBar appearance] setTintColor:[UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1]];
                
                
                break;
            case 1:
                //configure me differently!!
                
                //  [[UITabBar appearance] setTintColor:[UIColor blueColor];
                [[UITabBar appearance] setTintColor:[UIColor colorWithRed:200/255.0f green:191/255.0f blue:231/255.0f alpha:1]];
                
                break;
                
                
                
            case 2:
                //configure me differently!!
                
                //  [[UITabBar appearance] setTintColor:[UIColor blueColor];
                [[UITabBar appearance] setTintColor:[UIColor colorWithRed:200/255.0f green:191/255.0f blue:231/255.0f alpha:1]];
                
                break;
            case 3:
                //configure me differently!!
                
                //  [[UITabBar appearance] setTintColor:[UIColor blueColor];
                [[UITabBar appearance] setTintColor:[UIColor colorWithRed:200/255.0f green:191/255.0f blue:231/255.0f alpha:1]];
                
                break;
            case 4:
                //configure me differently!!
                
                //  [[UITabBar appearance] setTintColor:[UIColor blueColor];
                [[UITabBar appearance] setTintColor:[UIColor colorWithRed:200/255.0f green:191/255.0f blue:231/255.0f alpha:1]];
                
                break;
            case 5:
                //configure me differently!!
                
                //  [[UITabBar appearance] setTintColor:[UIColor blueColor];
                [[UITabBar appearance] setTintColor:[UIColor colorWithRed:200/255.0f green:191/255.0f blue:231/255.0f alpha:1]];
                
                break;
                
                
            default:
                break;
        }
        
        
        
 }
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popViewController:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
 //  [[UITabBar appearance] setTintColor:[UIColor blackColor]];

    UINavigationController* more = self.tabBarController.moreNavigationController;
    
    //[more.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];

      more.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    //UIBarStyleBlack
    
/*    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
      // [[UITabBar appearance] setTintColor:[UIColor blackColor]];
        //[[UITabBarItem appearance] setSelectedImage.ColorWithRGB
    
        [UITabBar appearance].barTintColor = [UIColor blackColor];
        
        //[UITabBarItem.item select(1,@"facebook",@"Twitter",@"Youtube", @"Events",@"News",@"Jobs")];
        
      // [[UITabBar appearance] setTintColor:[UIColor cyanColor]];
       [[UITabBar appearance] setTintColor:[UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1]];
        
        //[[UITabBar.UITabBarItemPositioningFill.UIColor col]]
      // [[UITabBar appearance] setTintColor:[UIColor colorWithRed:85.1 green:57.6 blue:71.4 alpha:.5]];
        
      //colorWithRed:85.1 green:57.6 blue:71.4 alpha:.5
        
        //  subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
        
       // [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]];
         
         //cyan color 00ffff  colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0
       //Amar changes
        
      // [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
//NSForegroundColorAttributeName

    }  */
    
    
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if([viewController isKindOfClass:[JobsViewController class]] || [viewController isKindOfClass:[EventViewController class]] ||[viewController isKindOfClass:[YouTubeDetailViewController class]] || [viewController isKindOfClass:[NewsViewController class]] || [viewController isKindOfClass:[LinkedIn_View_Controller class]] || [viewController isKindOfClass:[TwitterViewController class]] || [viewController isKindOfClass:[TwitterViewController class]] || [viewController isKindOfClass:[NewsDetailViewController class]] || [viewController isKindOfClass:[FacebookViewController class]])
    {
//        if(view)
//        {
//            [view removeFromSuperview];
//        }
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"blank_320_44"] forBarMetrics:UIBarMetricsDefault];
        
        [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blank_320_44"] forBarMetrics:UIBarMetricsDefault];
//        if(view)
//        {
//            [view removeFromSuperview];
//        }
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
//        view.tag = 124;
//        view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController.view addSubview:view];
    }
    
    navigationController.navigationBar.topItem.rightBarButtonItem = Nil;

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    tabBarController.moreNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    tabBarController.moreNavigationController.navigationItem.leftBarButtonItem = nil;
    tabBarController.moreNavigationController.navigationItem.rightBarButtonItem = nil;
    [tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];

 
    
}


@end
