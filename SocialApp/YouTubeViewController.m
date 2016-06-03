//
//  YouTubeViewController.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "YouTubeViewController.h"
#import "YoutubeXmlParser.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "YouTubeCustomCell.h"
#import "YouTubeDetailViewController.h"
#import "AppConstants.h"

#import "YoutubeData.h"
#import "MTReachabilityManager.h"

#import "YoutubeCD.h"
#import "YoutubeCoreService.h"


@interface YouTubeViewController ()<YoutubeXmlParserDelegate>
{
    YoutubeCoreService *youtubeCoreService;
}

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITableView *youTubeTableView;
@property (strong, nonatomic) NSMutableArray *listArray;
@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation YouTubeViewController
@synthesize listArray;
@synthesize youTubeTableView;

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
    
    [super viewDidLoad];
    
    youtubeCoreService = [YoutubeCoreService defaultInstance];
    
    //self.title = @"Youtube";
    if([self.tabBarController selectedIndex] < 4)
    {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
        self.navigationItem.leftBarButtonItem = anotherButton;
        
    }
    [self.youTubeTableView registerNib:[UINib nibWithNibName:@"YouTubeCustomCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self addRefreshView];
                       
	// Do any additional setup after loading the view.
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        //UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
        //view.backgroundColor=[UIColor grayColor];
        //[self.window.rootViewController.view addSubview:view];
        
        //Amar changes
        
      //  view.backgroundColor =[UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1];
        //view.backgroundColor =[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
        
        //[self.navigationController.view addSubview:view];    }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"youtubestrip.png"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];

    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [self customizeNavigationControllerWith:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1] andImage:@"youtubestrip.png"];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self loadYoutubeList];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [ProgressHUD hideHUD];
    
    [super viewWillDisappear:animated];
}

-(void)loadYoutubeList
{
    NSArray *dbList = [youtubeCoreService fetchYoutubeList];
    if(dbList.count)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for(YoutubeCD *fbCD in dbList)
        {
            YoutubeData *fbData = [[YoutubeData alloc] init];
            [fbData populateObjectFromCorData:fbCD];
            
            [temp addObject:fbData];
        }
        self.listArray = temp;
        [self.youTubeTableView reloadData];
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
		[self.youTubeTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)callAPI
{
    /*YoutubeXmlParser *youtubeXmlParser = [[YoutubeXmlParser alloc] init];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [youtubeXmlParser startXmlParsingWithDelegate:self];
    });*/
    
    if([MTReachabilityManager isUnreachable])
    {
        [self youtubeXmlParseringFailWithError:nil];
        return;
    }
    
    NSString *key = KEY_GOOGLE_API;
    NSString *name = NAME_YOUTUBE_SEARCH;
    
    //https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=Apple&key=AIzaSyAetJQGAkFnVsxbNxkYztNRls_niYaxCi0
    [self getChannelIDResult:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=%@&key=%@", name, key]];
    
}

-(void)getChannelIDResult:(NSString *)urlAsStr
{
    
    NSString *encodedString = [urlAsStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error)
    
    {
        
        [ProgressHUD hideHUD];
        
        if(responseData && responseData != nil)
        {
            if(!error && error == nil)
            {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:kNilOptions
                                                                       error:&error];
                NSArray *itemsList = [json objectForKey:@"items"];
                if(itemsList.count)
                {
                    NSDictionary *obj = [itemsList objectAtIndex:0];
                    NSString *idPlaylist = [[[obj objectForKey:@"contentDetails"] objectForKey:@"relatedPlaylists"] objectForKey:@"uploads"];
                    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=%@&key=%@", idPlaylist, KEY_GOOGLE_API];
                    [self getPlaylistbyUrl:url];
                    NSLog(@"%@", json);
                }

            }
            
        }
    }];
}

-(void)getPlaylistbyUrl:(NSString *)urlAsStr
{
    //"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID)&key=\(apiKey)"
    
    NSString *encodedString = [urlAsStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error)
     
     {
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:kNilOptions
                                                                error:&error];
         
         
         NSLog(@"%@", json);
         
         NSArray *itemsList = [json objectForKey:@"items"];
         if(itemsList.count)
         {
             NSMutableArray *array = [NSMutableArray array];
             for(NSDictionary *dict in itemsList)
             {
                 YoutubeData *youtubeData = [[YoutubeData alloc] initwithPraseDictionary:dict];
                 [array addObject:youtubeData];
             }
             
             self.listArray = array;
             [youtubeCoreService saveYoutubeListFromJson:self.listArray];

             [self.youTubeTableView reloadData];
         }
         
     }];
    
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.youTubeTableView];
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
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.youTubeTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.youTubeTableView];
}

#pragma mark - YoutubeXmlParserDelegate method

- (void)youtubeXmlParseringFailWithError:(NSError *)error
{
    [self doneLoadingTableViewData];
    [ProgressHUD hideHUD];
    [[[UIAlertView alloc] initWithTitle:NETWORK_CONNECTION_TITLE message:NETWORK_CONNECTION_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

}

- (void)youtubeXmlParseringWithResponse:(NSMutableArray *)array
{
    [self doneLoadingTableViewData];
    NSLog(@"%@",array);
    [ProgressHUD hideHUD];
    self.listArray = array;
    [self.youTubeTableView reloadData];
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
    
    YoutubeData *youtubeData = [self.listArray objectAtIndex:indexPath.row];
    
    NSString *url = youtubeData.thumbnails; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"image"];
    
    UITableViewCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = youtubeData.title; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    titleLabel.numberOfLines = 3;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = NORMAL_FONT(FONTSIZE_TITLE);;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFrame:CGRectMake(5, 5, 205, 62)];

    
    //Amar changes
    
    if([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0f)
    {
        titleLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor blackColor];
    
    }
    
    
    
    
    
    
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = youtubeData.publishedAt; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"pubDate"];
    subTitleLabel.font = NORMAL_FONT(FONTSIZE_SUB_TITLE);
    subTitleLabel.textColor = [UIColor colorWithRed:152/255.0f green:198/255.0f blue:232/255.0f alpha:1];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(218, 5, 95, 89)];
    imagView.backgroundColor = [UIColor clearColor];
    
    if(![url isEqualToString:@""])
    {
        [imagView setImageWithURL:[NSURL URLWithString:youtubeData.thumbnails] placeholderImage:[UIImage imageNamed:@""]];
        [imagView setAlpha:1];
        
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

    
    YoutubeData *youtubeData = [self.listArray objectAtIndex:indexPath.row];
    
    UIStoryboard *strotyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    YouTubeDetailViewController *detailVC = [strotyBoard instantiateViewControllerWithIdentifier:@"YouTubeDetailViewController"];
    detailVC.youTubeLink =  youtubeData.videoID; //[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"link"];
    detailVC.backgroundColor  = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    detailVC.imgName = @"youtubestrip.png";
    detailVC.isYoutube = YES;
    
    //detailVC.title = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    //detailVC.hidesBottomBarWhenPushed = YES
    ;    [self.navigationController pushViewController:detailVC animated:YES];
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
