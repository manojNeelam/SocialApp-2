//
//  iPad_You tube detailViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import "iPad_You tube detailViewController.h"
#import "ProgressHUD.h"

@interface iPad_You_tube_detailViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;

@end

@implementation iPad_You_tube_detailViewController
@synthesize detailWebView, isYoutubeVideo;
@synthesize youTubeLink;

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
//    NSURL *url = [NSURL URLWithString:self.youTubeLink];
//    
//    //URL Requst Object
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    
//    //Load the request in the UIWebView.
//    [self.detailWebView loadRequest:requestObj];
//    
//    [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
    
    
    [super viewDidLoad];
    
    if(!isYoutubeVideo)
    {
        [self.ytPlayer setHidden:YES];

        NSURL *url = [NSURL URLWithString:self.youTubeLink];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.detailWebView loadRequest:requestObj];
        [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
        
    }
    else
    {
        [self.detailWebView setHidden:YES];

        [self.ytPlayer loadWithVideoId:youTubeLink];
    }

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
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
