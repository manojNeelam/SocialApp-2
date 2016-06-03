//
//  iPad_TwitterViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 01/07/14.
//  Copyright (c) 2014 KPMG. All rights reserved.
//

#import "iPad_TwitterViewController.h"
#import "TwitterAPI.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "iPad_News detailViewController.h"
//#import "NewCustomCell.h"

#import "TwitterData.h"
#import "TwitterCoreService.h"
#import "TwitterCD.h"


@interface iPad_TwitterViewController () <TwitterAPIDelegate>
{
    TwitterCoreService *twitterCoreService;
}
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITableView *twitterTableView;
@property (strong, nonatomic) NSMutableArray *listArray;

@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation iPad_TwitterViewController

@synthesize listArray;
@synthesize twitterTableView;


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
    
    //self.title = @"Twitter";
    
    [super viewDidLoad];
    
    twitterCoreService = [TwitterCoreService defaultInstance];
    
    
    if([self.tabBarController selectedIndex] < 4)
    {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
        self.navigationItem.leftBarButtonItem = anotherButton;
        
        //Amar changes
        
        
        
    }
    self.tabBarController.tabBar.translucent = NO;

    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        self.navigationController.navigationBar.translucent = NO;
        
        
        
    }
    
    
    
    
    
    
    
    //[self.twitterTableView registerNib:[UINib nibWithNibName:@"NewCustomCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    
    [self addRefreshView];
    
	// Do any additional setup after loading the view.
    
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,768, 20)];
       // view.backgroundColor=[UIColor cyanColor];
        //[self.window.rootViewController.view addSubview:view];
        
        //Amar changes
        
       // view.backgroundColor =[UIColor colorWithRed:29/255.0f green:202/255.0f blue:255/255.0f alpha:1];
        
        view.backgroundColor =[UIColor colorWithRed:113/255.0f green:217/255.0f blue:252/255.0f alpha:1];
        

        
        
        [self.navigationController.view addSubview:view];
        
        
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"twitterstrip~ipad.png"] forBarMetrics:UIBarMetricsDefault];
    
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
		[self.twitterTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

-(void)fetchAllFBFeeds
{
    NSArray *dbList = [twitterCoreService fetchTwitterList];
    if(dbList.count)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for(TwitterCD *fbCD in dbList)
        {
            TwitterData *fbData = [[TwitterData alloc] init];
            [fbData populateObjectFromCorData:fbCD];
            
            [temp addObject:fbData];
        }
        self.listArray = temp;
        [self.twitterTableView reloadData];
    }
    else
    {
        [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
        [self callAPI];
    }
}


- (void)callAPI
{
    TwitterAPI *twitterAPI = [[TwitterAPI alloc] init];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [twitterAPI getTwitterTimeline:self];
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.twitterTableView];
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
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.twitterTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.twitterTableView];
}

#pragma mark - Twitter method

- (void)twitterParsingFailWithError:(NSError *)error
{
    [self doneLoadingTableViewData];
    [ProgressHUD hideHUD];
    [[[UIAlertView alloc] initWithTitle:NETWORK_CONNECTION_TITLE message:NETWORK_CONNECTION_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
}

- (void)twitterParsingWithResponse:(NSMutableArray *)array
{
    [self doneLoadingTableViewData];
    NSLog(@"%@",array);
    [ProgressHUD hideHUD];
    self.listArray = array;
    [self.twitterTableView reloadData];
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
    TwitterData *twitterData = [self.listArray objectAtIndex:indexPath.row];
    
    UITextView *titleLabel = [[UITextView alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    titleLabel.text  =  twitterData.text; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    [titleLabel setFrame:CGRectMake(20, 10, 728, 62)];
    
    //Amar changes
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0f)
    {
        [titleLabel setFrame:CGRectMake(20, 10, 728, 62)];
        CGRect frame = titleLabel.frame;
        frame.size.height = titleLabel.contentSize.height;
        
        return frame.size.height + 21 + 100;
        
    }
    
    
    
    
    CGRect frame = titleLabel.frame;
    frame.size.height = titleLabel.contentSize.height;
    
    return frame.size.height + 21 + 10;
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
     cell.textLabel.font = NORMAL_FONT(FONTSIZE_TITLE);
     cell.detailTextLabel.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
     cell.detailTextLabel.font = NORMAL_FONT(FONTSIZE_SUB_TITLE);
     cell.detailTextLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
     return cell;*/
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    TwitterData *twitterData = [self.listArray objectAtIndex:indexPath.row];
    
    UITextView *titleLabel = [[UITextView alloc] init];
    titleLabel.text = twitterData.text; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:IPAD_FONTSIZE_TITLE];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.scrollEnabled = NO;
    titleLabel.editable = NO;
    titleLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    [titleLabel setFrame:CGRectMake(20, 10, 728, 62)];
    
    CGRect frame = titleLabel.frame;
    frame.size.height = titleLabel.contentSize.height;
    titleLabel.frame = frame;
    
    //Amar changes
    
    //cell.bodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    // cell.bodyTextView.dataDetectorTypes = UIDataDetectorTypeAddress | UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0f)
    {
        
        //titleLabel.textColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;

        // titleLabel.backgroundColor = [UIColor clearColor];
        
        titleLabel.text = twitterData.text; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:IPAD_FONTSIZE_TITLE];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.scrollEnabled = NO;
        titleLabel.editable = NO;
        titleLabel.dataDetectorTypes = UIDataDetectorTypeLink;
        
        [titleLabel setFrame:CGRectMake(20, 10, 728, 62)];
        
        CGRect frame = titleLabel.frame;
        frame.size.height = titleLabel.contentSize.height;
        titleLabel.frame = frame;
        cell.backgroundColor = [UIColor blackColor];
        
        
        
    }
    
    
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = twitterData.pubDate; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    subTitleLabel.font = NORMAL_FONT(IPAD_FONTSIZE_SUB_TITLE);;
    subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    //subTitleLabel.font.buttonFontSize.false=subTitleLabel;
    [titleLabel sizeToFit];
    
    
    
    
    //CGRect newFrame = titleLabel.frame;
    //titleLabel.frame = newFrame;
    //[titleLabel sizeToFit];
    
    [subTitleLabel setFrame:CGRectMake(20, titleLabel.frame.origin.y+titleLabel.frame.size.height, 728, 21)];
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:subTitleLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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

- (void)isAlreadyFollowesResultWithBool:(BOOL )isFollowed
{
    
}

@end
