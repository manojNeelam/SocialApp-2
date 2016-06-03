//
//  iPad_LinkedIn View Controller.m
//  SocialApp
//
//  Created by Syntel-Amargoal1 on 11/21/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//
#define CellIdentifier @"LinkedInCell"
#define CellHeight 94

#import "LinkedIn View Controller.h"
#import <Foundation/NSNotificationQueue.h>
#import "LinkedInCell.h"
#import "UIImageView+WebCache.h"
#import "LinkdeInObject.h"
#import "YouTubeDetailViewController.h"
#import "ProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "iPad_LinkedIn View Controller.h"


#import "LinkedinCoreService.h"
#import "LinkedinCD.h"

@interface iPad_LinkedIn_View_Controller ()
{
    LinkdeInObject *linkdeinObj;
    NSMutableArray *listData;
    
    LinkedinCoreService *linkdeinCoreservice;
}
@end

@implementation iPad_LinkedIn_View_Controller

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
    
    linkdeinCoreservice = [LinkedinCoreService defaultInstance];
    
    
    self.oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:@"OAuthLoginView" bundle:nil];
    [self.oAuthLoginView initLinkedInApi];
    
    self.linkdeinTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.view.layer.contents = (id)[UIImage imageNamed:@"backImage.png"].CGImage;
    
    if([self.tabBarController selectedIndex] < 4)
    {
//        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
//        anotherButton.title=@" ";
//        self.navigationItem.leftBarButtonItem = anotherButton;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,768, 20)];
        // view.backgroundColor=[UIColor grayColor];
        
        //Amar changes
        
        
        // subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
        // view.backgroundColor =[UIColor colorWithRed:0/255.0f green:76/255.0f blue:153/255.0f alpha:1];
        
        view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:79/255.0f green:114/255.0f blue:184/255.0f alpha:1];
        
        
        
        //[self.window.rootViewController.view addSubview:view];
        [self.navigationController.view addSubview:view];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }

    
    [self addRefreshView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LinkedInstrip~ipad.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarController.tabBar.translucent = NO;
    
    //Amar changes
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0f)
    {
        
        self.navigationController.navigationBar.translucent =NO;
    }
    
    NSArray *dbList = [linkdeinCoreservice fetchLinkedinList];
    if(dbList.count)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for(LinkedinCD *lkCD in dbList)
        {
            LinkdeInObject *lkData = [[LinkdeInObject alloc] init];
            [lkData populateObjectFromCorData:lkCD];
            
            [temp addObject:lkData];
        }
        listData = temp;
        [self.linkdeinTableview reloadData];
    }
    else
    {
        [self companyUpdatesApiCall];
    }
    
    
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
		[self.linkdeinTableview addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self companyUpdatesApiCall];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.linkdeinTableview];
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

- (void)companyUpdatesApiCall
{
    /*NSURL *url = [NSURL URLWithString:LINKDEIN_COMPANY_UPDATES_URL];
    
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.oAuthLoginView.consumer
                                       token:nil
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(companyUpdatesApiCallResult:didFinish:)
                  didFailSelector:@selector(companyUpdatesApiCallResult:didFail:)];*/
    
    [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];

    //AQXUOwRGbzPMoV74_mfL2xtkLOqvQ6d3gBvI-wkfU8zY55inuYSFH8G65E8pxelyIq17v37iUdiOACz0J7gGhhX-Ise6_KVA3l3hcgfCUhXgmnJLeaP-PVvrGONqg2fQPn8jxIBOdWFBjEw5uC3fRNcF4uZzpJCxXlfJlIOwxmVljQ0ORes
    /*
     /v1/companies/4280/updates/key=UPDATE-c1337-5986518397255454720?oauth2_access_token=AQX2HgaC7QGyQ0nMGler-4TBO_hs0f1ayDSMywZ3vDhw3_mwJkBT9BCM7QIX1QT1kh1ejwfYtdqY34HC99th7hUZ5O1-RhVfgDPi4ikkjD37h8oDBlrSYAHaKVmqZFfS2GIlrTqvn73AFTlwarIIqcN7T_YsLjZXIuIH_2Wi7NqfabXg6mA&format=json HTTP/1.1
     */
    //AQV59XPrkowtKhJNsokIDmavKIVMQwuXaC4zQJzX32hIBiU6qJhnZMCk2Sv-p8CybO391zh4oj1bICqY5_BcQs9FBsVJQNICZvTm8Wyy8E0xDOS_VaqIVbtltH_PgcxlOLa24NW9ssxLBDipwsz6EvysIgVM1A0wTrSpZxr0Mho5-2rNhkQ
    
    NSURL *URL = [NSURL URLWithString:@"https://api.linkedin.com/v1/companies/4280/updates?oauth2_access_token=AQX2HgaC7QGyQ0nMGler-4TBO_hs0f1ayDSMywZ3vDhw3_mwJkBT9BCM7QIX1QT1kh1ejwfYtdqY34HC99th7hUZ5O1-RhVfgDPi4ikkjD37h8oDBlrSYAHaKVmqZFfS2GIlrTqvn73AFTlwarIIqcN7T_YsLjZXIuIH_2Wi7NqfabXg6mA&format=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // ...
                               
                               [ProgressHUD hideHUD];
                               
                               [self companyUpdatesApiCallResult:nil didFinish:data];
                               
                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&error];
                               
                               NSLog(@"%@", json);
                               
                           }];
    
    
}

- (void)companyUpdatesApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    [ProgressHUD hideHUD];
    [self doneLoadingTableViewData];
    listData = [[NSMutableArray alloc] init];
    
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    NSArray *updatesArray = [profile objectForKey:@"values"];
    NSDictionary *updatesDict;
    for(updatesDict in updatesArray)
    {
        NSDictionary *updateContentDict = [[[[updatesDict objectForKey:@"updateContent"] objectForKey:@"companyStatusUpdate"] objectForKey:@"share"] objectForKey:@"content"];
        if(updateContentDict)
        {
            linkdeinObj = [[LinkdeInObject alloc] init];

            if([updatesDict objectForKey:@"timestamp"])
            {
                linkdeinObj.timeStamp = [updatesDict objectForKey:@"timestamp"];
            }
            if([updateContentDict objectForKey:@"title"])
                linkdeinObj.titleStr = [updateContentDict objectForKey:@"title"];
            if([updateContentDict objectForKey:@"description"])
                linkdeinObj.descriptionStr = [updateContentDict objectForKey:@"description"];
            if([updateContentDict objectForKey:@"thumbnailUrl"])
                linkdeinObj.imageStr = [updateContentDict objectForKey:@"thumbnailUrl"];
            if([updateContentDict objectForKey:@"eyebrowUrl"])
                linkdeinObj.url = [updateContentDict objectForKey:@"eyebrowUrl"];
            [listData addObject:linkdeinObj];
        }
        else
        {

            NSDictionary *companyJobUpdateDict = [[[updatesDict objectForKey:@"updateContent"] objectForKey:@"companyJobUpdate"] objectForKey:@"job"];
            
            if(companyJobUpdateDict && companyJobUpdateDict != nil)
            {
                linkdeinObj = [[LinkdeInObject alloc] init];

                
                if([updatesDict objectForKey:@"timestamp"])
                {
                    linkdeinObj.timeStamp = [updatesDict objectForKey:@"timestamp"];
                }
                
                if([[companyJobUpdateDict objectForKey:@"position"] objectForKey:@"title"])
                    linkdeinObj.titleStr = [[companyJobUpdateDict objectForKey:@"position"] objectForKey:@"title"];
                if([companyJobUpdateDict objectForKey:@"description"])
                    linkdeinObj.descriptionStr = [companyJobUpdateDict objectForKey:@"description"];
                if([companyJobUpdateDict objectForKey:@"thumbnailUrl"])
                    linkdeinObj.imageStr = [companyJobUpdateDict objectForKey:@"thumbnailUrl"];
                if([[companyJobUpdateDict objectForKey:@"siteJobRequest"] objectForKey:@"url"])
                    linkdeinObj.url = [[companyJobUpdateDict objectForKey:@"siteJobRequest"] objectForKey:@"url"];
                [listData addObject:linkdeinObj];
            }
            
        }
    }
    
    //Save in DB
    [linkdeinCoreservice saveLinkedinListFromJson:listData];

    [self.linkdeinTableview reloadData];
}

- (void)companyUpdatesApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.linkdeinTableview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.linkdeinTableview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = CellIdentifier;
    LinkedInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    [cell.titleLabel setFont:NORMAL_FONT_BOLD(FONTSIZE_TITLE)];
    [cell.titleLabel setTextColor:[UIColor whiteColor]];
    
    [cell.timeStampLbl setTextColor:[UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1]];
    [cell.timeStampLbl setFont:NORMAL_FONT(FONTSIZE_SUB_TITLE)];
    
    linkdeinObj = [listData objectAtIndex:indexPath.row];
    [cell.titleLabel setText:linkdeinObj.titleStr];
    [cell.timeStampLbl setText:[self timeAgoString:linkdeinObj.timeStamp]];
    [cell.linkdeinImg setImageWithURL:[NSURL URLWithString:[linkdeinObj imageStr]] placeholderImage:[UIImage imageNamed:@""]];
    // Configure the cell...
    
    return cell;
}

- (NSString*)timeAgoString:(NSString *)timestampString
{
    double eventSecondsSince1970 =
    [timestampString doubleValue] / 1000.0; // milliseconds to seconds
    NSDate *eventDate =
    [NSDate dateWithTimeIntervalSince1970:eventSecondsSince1970];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd MMM yyyy"];
    NSString *_date=[_formatter stringFromDate:eventDate];
    
    return _date;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    linkdeinObj = [listData objectAtIndex:indexPath.row];
    CGSize size = [linkdeinObj.titleStr sizeWithFont:NORMAL_FONT_BOLD(FONTSIZE_TITLE) constrainedToSize:CGSizeMake(260, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    return size.height + 51;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    linkdeinObj = [listData objectAtIndex:indexPath.row];
    if([linkdeinObj.url length]>0)
    {
        UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        YouTubeDetailViewController *detailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"YouTubeDetailViewController"];
        detailVC.youTubeLink = linkdeinObj.url;
        detailVC.backgroundColor = [UIColor whiteColor];
        detailVC.imgName = @"LinkedInstrip.png";
        //detailVC.title = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        //detailVC.hidesBottomBarWhenPushed = YES
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}




@end
