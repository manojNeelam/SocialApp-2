//
//  YouTubeDetailViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "YouTubeDetailViewController.h"
#import "ProgressHUD.h"

@interface YouTubeDetailViewController ()<UIWebViewDelegate>

@end

@implementation YouTubeDetailViewController

@synthesize youTubeLink, isYoutube;

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
    //NSURL *url = [NSURL URLWithString:self.youTubeLink];
    
    //URL Requst Object
    //NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
//    [self.detailWebView loadRequest:requestObj];
//    [self.detailWebView setDelegate:self];
//    [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];

    [super viewDidLoad];
    
    if(isYoutube)
    {
        [self.detailWebView setHidden:YES];
        [self.ytPlayer loadWithVideoId:self.youTubeLink];
    }
    else
    {
        [self.ytPlayer setHidden:YES];
        NSURL *url = [NSURL URLWithString:self.youTubeLink];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [self.detailWebView loadRequest:requestObj];
        [self.detailWebView setDelegate:self];
        [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
    }
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self customizeNavigationControllerWith:_backgroundColor andImage:_imgName];
    //[ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ProgressHUD hideHUD];
    
    [super viewWillDisappear:animated];
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
