//
//  iPad_News detailViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import "iPad_News detailViewController.h"
#import "ProgressHUD.h"

@interface iPad_News_detailViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;

@end

@implementation iPad_News_detailViewController

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
    NSLog(@"detail url = %@",self.link);
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.link]];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.detailWebView loadRequest:requestObj];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
    
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
