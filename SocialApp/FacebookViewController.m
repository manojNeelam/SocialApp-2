//
//  FacebookViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//
#define LOGIN_INFO_MSG  @"Login with Facebook to view feeds"
#define FB_ALERT    121


#import "FacebookViewController.h"
#import "FacebookXmlParser.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "YouTubeCustomCell.h"
#import "YouTubeDetailViewController.h"

//Import fb
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FacebookFeedData.h"
#import "TAlertView.h"
#import "AppConstants.h"
#import "SCLAlertView.h"

#import "Reachability.h"
#import "MTReachabilityManager.h"

#import "FacebookCD.h"
#import "FacebookCoreService.h"

@interface FacebookViewController ()<FacebookXmlParserDelegate, FBSDKLoginButtonDelegate, UIAlertViewDelegate>
{
    FacebookCoreService *facebookCoreService;
}
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITableView *facebookTableView;
@property (strong, nonatomic) NSMutableArray *listArray;
@end


@implementation FacebookViewController
@synthesize listArray;
@synthesize facebookTableView;

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
    
    
    
    //listArray = [[NSMutableArray alloc] init];
    
    //self.title = @"Facebook";
    
    facebookCoreService = [FacebookCoreService defaultInstance];
    
    
    if([self.tabBarController selectedIndex] < 4)
    {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
        self.navigationItem.leftBarButtonItem = anotherButton;
        
    }

    [self addRefreshView];

    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"facebookstrip.png"] forBarMetrics:UIBarMetricsDefault];
    
    //Amar changes
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0f)
    {
        [self customizeNavigationControllerWith:[UIColor colorWithRed:79/255.0f green:114/255.0f blue:184/255.0f alpha:1] andImage:@"facebookstrip.png"];
        self.navigationController.navigationBar.translucent =NO;
    }
    
    [self customView];
    [self fetchAllFBFeeds];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ProgressHUD hideHUD];

    [super viewWillDisappear:animated];
}

- (void)addRefreshView
{
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
		view.delegate = self;
		[self.facebookTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

-(void)fetchAllFBFeeds
{
    NSArray *dbList = [facebookCoreService fetchFacebookList];
    if(dbList.count)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for(FacebookCD *fbCD in dbList)
        {
            FacebookFeedData *fbData = [[FacebookFeedData alloc] init];
            [fbData populateObjectFromCorData:fbCD];

            [temp addObject:fbData];
        }
        self.listArray = temp;
        [self.facebookTableView reloadData];
    }
    else
    {
        [self getAllFeeds];
    }
}

-(void)customView
{
    BOOL status = [self getFaceBookLoginStatus];
    if(status)
    {
        [self.loginInfobasevIEW setHidden:YES];
        [self.facebookTableView setHidden:NO];
    }
    else
    {
        [self.facebookTableView setHidden:YES];
        [self.loginInfobasevIEW setHidden:NO];
    }
}

- (void)callAPI
{
    FacebookXmlParser *facebookXmlParser = [[FacebookXmlParser alloc] init];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [facebookXmlParser startXmlParsingWithDelegate:self];
    });
}

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self getAllFeeds];
    
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.facebookTableView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.facebookTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.facebookTableView];
}

#pragma mark - YoutubeXmlParserDelegate method

- (void)FacebookXmlParsingFailWithError:(NSError *)error
{
    [self doneLoadingTableViewData];
    [ProgressHUD hideHUD];
    [[[UIAlertView alloc] initWithTitle:NETWORK_CONNECTION_TITLE message:NETWORK_CONNECTION_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)FacebookXmlParsingWithResponse:(NSMutableArray *)array
{
    [self doneLoadingTableViewData];
    NSLog(@"%@",array);
    [ProgressHUD hideHUD];
    self.listArray = array;
    [self.facebookTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    FacebookFeedData *facebookData = [self.listArray objectAtIndex:indexPath.row];

    
    NSString *url = facebookData.picture; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"image"];

    UITableViewCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = facebookData.message;
    
    titleLabel.numberOfLines = 3;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = NORMAL_FONT(FONTSIZE_TITLE);
    titleLabel.backgroundColor = [UIColor clearColor];
    //[titleLabel setFrame:CGRectMake(5,5, 205, 62)];
    [titleLabel setFrame:CGRectMake(5, 5, 205, 62)];
//=========================================================
    // Amar change
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
       // [titleLabel setFrame:CGRectMake(15,15, 205, 92)];
       // [titleLabel setFrame:CGRectMake(5, 5, 205, 62)];
        
        
       titleLabel.textColor=[UIColor whiteColor];
        
        cell.backgroundColor = [UIColor blackColor];
        
        
                //titleLabel.appearance.backgroundColor.blue;
        //self.titleLabel.textColor.blue;
       }
   
 //===========================================================
    
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = facebookData.created_time;
    //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    subTitleLabel.font = NORMAL_FONT(FONTSIZE_SUB_TITLE);;
    subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(218, 5, 100, 85)];
    [imagView setBackgroundColor:[UIColor clearColor]];
    
    if(![url isEqualToString:@""])
    {
        //[imagView setImageWithURL:[NSURL URLWithString:[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@""]];
        
        __weak UIImageView *imageview = imagView;
        
        [imagView setImageWithURL:[NSURL URLWithString:facebookData.picture] success:^(UIImage *image, BOOL cached) {
            if(imageview)
            {
                [imageview setAlpha:1];
                
                CGSize maximumLabelSize = CGSizeMake(205, FLT_MAX);
                CGSize expectedLabelSize = [titleLabel.text sizeWithFont:titleLabel.font
                                                       constrainedToSize:maximumLabelSize
                                                           lineBreakMode:NSLineBreakByCharWrapping];
                CGRect newFrame = titleLabel.frame;
                newFrame.size.height = expectedLabelSize.height;
                titleLabel.frame = newFrame;
                [titleLabel sizeToFit];
                
                [subTitleLabel setFrame:CGRectMake(5, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, 205, 21)];
            }
        } failure:^(NSError *error) {
            [imageview setAlpha:0];
            [titleLabel setFrame:CGRectMake(5, 5, 310, 62)];
            
            CGSize maximumLabelSize = CGSizeMake(310, FLT_MAX);
            CGSize expectedLabelSize = [titleLabel.text sizeWithFont:titleLabel.font
                                                   constrainedToSize:maximumLabelSize
                                                       lineBreakMode:NSLineBreakByCharWrapping];
            CGRect newFrame = titleLabel.frame;
            newFrame.size.height = expectedLabelSize.height;
            titleLabel.frame = newFrame;
            [titleLabel sizeToFit];
            
            [subTitleLabel setFrame:CGRectMake(5, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, 310, 21)];
        }];
        
        
    }
    else
    {
        [imagView setAlpha:0];
        [titleLabel setFrame:CGRectMake(5, 5, 310, 62)];
        
        CGSize maximumLabelSize = CGSizeMake(310, FLT_MAX);
        CGSize expectedLabelSize = [titleLabel.text sizeWithFont:titleLabel.font
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByCharWrapping];
        CGRect newFrame = titleLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        titleLabel.frame = newFrame;
        [titleLabel sizeToFit];
        
        [subTitleLabel setFrame:CGRectMake(5, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, 310, 21)];
        
    }
    
    [imagView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [imagView.layer setBorderWidth: 2.0];
    imagView.contentMode = UIViewContentModeScaleAspectFit;

   
    /*cell.titleLabel.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.titleLabel.numberOfLines = 3;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.titleLabel.font = [UIFont fontWithName:@"" size:16];
    cell.subTitleLabel.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    cell.subTitleLabel.font = [UIFont fontWithName:@"" size:13];
    cell.subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];*/
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:subTitleLabel];
    [cell.contentView addSubview:imagView];


    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FacebookFeedData *facebookData = [self.listArray objectAtIndex:indexPath.row];
    if(facebookData.link && facebookData.link != nil)
    {
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        YouTubeDetailViewController *detailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"YouTubeDetailViewController"];
        detailVC.youTubeLink = facebookData.link;//[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"link"];
        detailVC.backgroundColor = [UIColor colorWithRed:79/255.0f green:114/255.0f blue:184/255.0f alpha:1];
        detailVC.imgName = @"facebookstrip.png";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    
//    else if (editingStyle == UITableViewCellEditingStyleInsert)
//    {
//    }
//}



-(void)Cancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:POPV_VIEW_CONTROLLER object:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark 
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
    });
}

/*!
 @abstract Sent to the delegate when the button was used to logout.
 @param loginButton The button that was clicked.
 */
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

/*
 
 *///https://gdata.youtube.com/feeds/mobile/users/syntel/uploads?v=2&alt=jsonc&start-index=1&max-results=50&orderby=published

-(NSString *)getFBAccessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:APP_FACEBOOK_USER_TOKEN];
    
    return token;
}

-(void)saveFBAccessToken
{
    NSString *fbToken = [FBSDKAccessToken currentAccessToken].tokenString;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:fbToken forKey:APP_FACEBOOK_USER_TOKEN];
    [defaults synchronize];
}

-(BOOL)getFaceBookLoginStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaults boolForKey:APP_FACEBOOK_USER_LOGIN];
    
    //objectForKey:APP_FACEBOOK_USER_LOGIN];
    
    return islogin;
}

-(void)saveFaceBookLoginStatus:(BOOL)status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:status forKey:APP_FACEBOOK_USER_LOGIN];
    //setObject:fbToken forKey:APP_FACEBOOK_USER_LOGIN];
    [defaults synchronize];
}

-(void)getAllFeeds
{
    if([MTReachabilityManager isUnreachable])
    {
        [self FacebookXmlParsingFailWithError:nil];
        return;
    }
    
    //@{@"fields": @""}
    //["fields": "cover,picture,id,birthday,email"]
    NSDictionary *params = @{
                             @"message": @"This is a test message",@"access_token" : [self getFBAccessToken]
                             };
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"%@?fields=id,name,picture,message,created_time,link",@"/250918001622520/feed/"]
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dataDict = result;
            NSArray *dataArray = [dataDict objectForKey:@"data"];
            
            if(dataArray.count)
            {
                NSMutableArray *temp = [NSMutableArray array];
                for(NSDictionary *dict in dataArray)
                {
                    FacebookFeedData *facebookFeedData = [[FacebookFeedData alloc] initwithDictionary:dict];
                    [temp addObject:facebookFeedData];
                }
                
                //Saving in DB
                [facebookCoreService saveFacebookListFromJson:temp];
                
                [self fetchAllFBFeeds];
                
                //self.listArray = temp;
                //[self.facebookTableView reloadData];
            }
            else
            {
                //Extend App token
                //https://graph.facebook.com/oauth/access_token?client_id=758722117536358&client_secret=d47d53ff89aa0c06d44cf921769c874f&grant_type=fb_exchange_token&fb_exchange_token=EAAKyDcJMimYBAAY1JpJmZCgRDtVZBB1Kf92EICuvqZAQhcTRqeHomXQsjLmCArPCjbQQu7FEGugsIIBAPrUWLw8mpbtKYr8k9D0nRcRlR6VW9tZAVZCMRtozVCMU29sJ3UsqRi0xuDSkLTt6ix17DAr2tsZBGyZBJ9Ka28obEiZCeAZDZD
            
                
                NSString *urlAsStr = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/access_token?client_id=758722117536358&client_secret=d47d53ff89aa0c06d44cf921769c874f&grant_type=fb_exchange_token&fb_exchange_token=%@", [self getFBAccessToken]];
                NSString *encodedString = [urlAsStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setHTTPMethod:@"GET"];
                [request setURL:[NSURL URLWithString:encodedString]];
                NSError *error = [[NSError alloc] init];
                NSHTTPURLResponse *responseCode = nil;
                
                NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
                if([responseCode statusCode] != 200)
                {
                    
                }
                
                if(!error && error == nil)
                {
                    NSString *str = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", str);
                    
                    if(str && str != nil && ![str  isEqual: @""])
                    {
                        NSString *fbAccessToken = [self getAccessToken:str];
                        if(fbAccessToken && fbAccessToken != nil)
                        {
                            NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
                            [defauts setObject:fbAccessToken forKey:APP_FACEBOOK_USER_TOKEN];
                            [defauts synchronize];
                            [self getAllFeeds];
                        }
                    }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LOGIN_INFO_MSG delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
                    alert.tag = FB_ALERT;
                    [alert show];
                }
            }
        });
        // Handle the result
    }];
}

-(NSString *)getAccessToken:(NSString *)aStr
{
    
    NSString *s = aStr;
    
    NSRange r1 = [s rangeOfString:@"access_token="];
    NSRange r2 = [s rangeOfString:@"&expires"];
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSString *sub = [s substringWithRange:rSub];
    
    
    return sub;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == FB_ALERT)
    {
        if(buttonIndex == 1)
        {
            currentlySelectedItem = kFacebookSelected;
            
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login
             logInWithReadPermissions: @[@"public_profile"]
             fromViewController:self
             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
            {
                [self saveFaceBookLoginStatus:YES];
                
                 if (error) {
                     NSLog(@"Process error");
                 } else if (result.isCancelled) {
                     NSLog(@"Cancelled");
                 } else {
                     
                     
                     
                     [self saveFBAccessToken];
                     [self getAllFeeds];
                     NSLog(@"Logged in");
                 }
             }];
        }
        else
        {
            [self saveFaceBookLoginStatus:NO];
            [self customView];
        }
    }
}

@end
