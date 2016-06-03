//
//  EventViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "EventViewController.h"
#import "EventXmlParser.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailViewController.h"
#import "YouTubeCustomCell.h"

#import "EventData.h"
#import "EventsCD.h"
#import "EventCoreService.h"

@interface EventViewController ()<EventXmlParserDelegate>
{
    EventCoreService *eventCoreService;
}
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITableView *eventTableView;
@property (strong, nonatomic) NSMutableArray *listArray;
@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation EventViewController
@synthesize listArray;
@synthesize eventTableView;

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

    eventCoreService = [EventCoreService defaultInstance];
    
    
    //self.title = @"Events";
    if([self.tabBarController selectedIndex] < 4)
    {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
        anotherButton.title=@" ";
        self.navigationItem.leftBarButtonItem = anotherButton;
        
    }
    
    [self.eventTableView registerNib:[UINib nibWithNibName:@"YouTubeCustomCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self addRefreshView];
    
    
    
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"eventsstrip.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    //Amar changes
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [self customizeNavigationControllerWith:[UIColor colorWithRed:4/255.0f green:161/255.0f blue:110/255.0f alpha:1] andImage:@"eventsstrip.png"];
        self.navigationController.navigationBar.translucent = NO;
    
    }
    
    [self fetchAllFBFeeds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    // view.backgroundColor=[UIColor orangeColor];
    //[self.window.rootViewController.view addSubview:view];
    
    //view.backgroundColor = [UIColor clearColor];
    
    
    
    //[self.navigationController.view addSubview:view];
    [ProgressHUD hideHUD];
}

-(void)fetchAllFBFeeds
{
    NSArray *dbList = [eventCoreService fetchEventsList];
    if(dbList.count)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for(EventsCD *newsCD in dbList)
        {
            EventData *fbData = [[EventData alloc] init];
            [fbData populateObjectFromCorData:newsCD];
            
            [temp addObject:fbData];
        }
        self.listArray = temp;
        [self.eventTableView reloadData];
    }
    else
    {
        [ProgressHUD showHUDWithLable:LOADING_MSG inView:self.view];
        [self callAPI];
    }
}

- (void)addRefreshView
{
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
		view.delegate = self;
		[self.eventTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)callAPI
{
    EventXmlParser *youtubeXmlParser = [[EventXmlParser alloc] init];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [youtubeXmlParser startXmlParsingWithDelegate:self];
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.eventTableView];
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
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.eventTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.eventTableView];
}

#pragma mark - XMLParserDelegate method

- (void)eventXmlParseringFailWithError:(NSError *)error
{
    [self doneLoadingTableViewData];
    [ProgressHUD hideHUD];
    [[[UIAlertView alloc] initWithTitle:NETWORK_CONNECTION_TITLE message:NETWORK_CONNECTION_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

}

- (void)eventXmlParseringWithResponse:(NSMutableArray *)array
{
    [self doneLoadingTableViewData];
    NSLog(@"%@",array);
    [ProgressHUD hideHUD];
    self.listArray = array;
    [self.eventTableView reloadData];
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
    
    NSString *url = nil;//[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"image"];
    
    UITableViewCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    EventData *eventData = [self.listArray objectAtIndex:indexPath.row];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = eventData.title; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    titleLabel.numberOfLines = 3;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = NORMAL_FONT(FONTSIZE_TITLE);;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFrame:CGRectMake(5, 5, 205, 62)];
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        titleLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor blackColor];
    }
    
    
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = eventData.pubDate; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    subTitleLabel.font = NORMAL_FONT(FONTSIZE_SUB_TITLE);
    subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(218, 5, 95, 89)];
    imagView.backgroundColor = [UIColor clearColor];
    
    if(![url isEqualToString:@""] && !url && url != nil)
    {
        
        __weak UIImageView *imageview = imagView;
        
        [imagView setImageWithURL:[NSURL URLWithString:eventData.link] success:^(UIImage *image, BOOL cached) {
            if(image)
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

    EventData *eventData = [self.listArray objectAtIndex:indexPath.row];
    
    UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NewsDetailViewController *newsDetailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    newsDetailVC.link = eventData.link;  //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"link"];
    newsDetailVC.imgName = @"eventsstrip.png";
    newsDetailVC.backgroundColor = [UIColor colorWithRed:4/255.0f green:161/255.0f blue:110/255.0f alpha:1];
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
