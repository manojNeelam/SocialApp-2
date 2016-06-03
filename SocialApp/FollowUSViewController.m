//
//  FollowUSViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//
#import "FollowUSViewController.h"
#import "ProgressHUD.h"

@interface FollowUSViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;

@end

@implementation FollowUSViewController
@synthesize link;
@synthesize detailWebView;

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
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.link]];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.detailWebView loadRequest:requestObj];
    
    [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ProgressHUD hideHUD];
}


@end