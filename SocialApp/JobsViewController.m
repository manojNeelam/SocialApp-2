//
//  JobsViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "JobsViewController.h"
#import "JobXmlParser.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailViewController.h"
#import "NewCustomCell.h"



#import "JobsCD.h"
#import "JobData.h"
#import "JobCoreSerice.h"

@interface JobsViewController ()<JobXmlParserDelegate>
{
    JobCoreSerice *jobCoreService;
}

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITableView *jobTableView;
@property (strong, nonatomic) NSMutableArray *listArray;
@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation JobsViewController
@synthesize listArray;
@synthesize jobTableView;

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
    //listArray = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    
    jobCoreService = [JobCoreSerice defaultInstance];
    
    //self.title = @"Jobs";
    if([self.tabBarController selectedIndex] < 4)
    {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
        self.navigationItem.leftBarButtonItem = anotherButton;
        
    }
    
    //[self.jobTableView registerNib:[UINib nibWithNibName:@"NewCustomCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self addRefreshView];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    

    [super viewWillAppear:YES];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jobsstrip.png"] forBarMetrics:UIBarMetricsDefault];
   
    //Amar changes
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [self customizeNavigationControllerWith:[UIColor colorWithRed:98/255.0f green:190/255.0f blue:219/255.0f alpha:1] andImage:@"jobsstrip.png"];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self fetchAllFBFeeds];
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
		[self.jobTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

-(void)fetchAllFBFeeds
{
    NSArray *dbList = [jobCoreService fetchJobList];
    if(dbList.count)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for(JobsCD *fbCD in dbList)
        {
            JobData *fbData = [[JobData alloc] init];
            [fbData populateObjectFromCorData:fbCD];
            
            [temp addObject:fbData];
        }
        self.listArray = temp;
        [self.jobTableView reloadData];
    }
    else
    {
        [self callAPI];
    }
}

- (void)callAPI
{
    [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
    JobXmlParser *jobXmlParser = [[JobXmlParser alloc] init];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [jobXmlParser startXmlParsingWithDelegate:self];
    });
}

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self callAPI];
    
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.jobTableView];
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
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.jobTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.jobTableView];
}

#pragma mark - XMLParserDelegate method

- (void)jobXmlParseringFailWithError:(NSError *)error
{
    [self doneLoadingTableViewData];
    [ProgressHUD hideHUD];
    [[[UIAlertView alloc] initWithTitle:NETWORK_CONNECTION_TITLE message:NETWORK_CONNECTION_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

}

- (void)jobXmlParseringWithResponse:(NSMutableArray *)array
{
    [self doneLoadingTableViewData];
    NSLog(@"%@",array);
    [ProgressHUD hideHUD];
    self.listArray = array;
    [self.jobTableView reloadData];
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
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = NORMAL_FONT(FONTSIZE_TITLE);;
    cell.detailTextLabel.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    cell.detailTextLabel.font = NORMAL_FONT(FONTSIZE_SUB_TITLE);;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
    return cell;*/
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    JobData *jobData = [self.listArray objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = jobData.title;  //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    titleLabel.numberOfLines = 3;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = NORMAL_FONT(FONTSIZE_TITLE);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFrame:CGRectMake(5, 5, 310, 62)];
    
    
    
    
    if([[[UIDevice currentDevice] systemVersion ] floatValue] >=7.0f)
    
      {
    
          titleLabel.textColor = [UIColor whiteColor];
          cell.backgroundColor = [UIColor blackColor];
      }
    
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = jobData.pubDate; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    subTitleLabel.font = NORMAL_FONT(FONTSIZE_SUB_TITLE);;
    subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    CGSize maximumLabelSize = CGSizeMake(310, FLT_MAX);
    CGSize expectedLabelSize = [titleLabel.text sizeWithFont:titleLabel.font
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:NSLineBreakByCharWrapping];
    CGRect newFrame = titleLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    titleLabel.frame = newFrame;
    [titleLabel sizeToFit];
    
    [subTitleLabel setFrame:CGRectMake(5, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, 310, 21)];
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:subTitleLabel];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    JobData *jobData = [self.listArray objectAtIndex:indexPath.row];
    
    // it controller used for webview controller
    UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NewsDetailViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    newsDetailVC.link = jobData.link; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"link"];
    newsDetailVC.imgName = @"jobsstrip.png";
    newsDetailVC.backgroundColor = [UIColor colorWithRed:98/255.0f green:190/255.0f blue:219/255.0f alpha:1];
    //newsDetailVC.title = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    //newsDetailVC.hidesBottomBarWhenPushed = YES
    ;    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    }
}



-(void)Cancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:POPV_VIEW_CONTROLLER object:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
