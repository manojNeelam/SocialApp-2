//
//  ProgressHUD.m
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProgressHUD.h"

static ProgressHUD *staticProgressHud = nil;

@implementation ProgressHUD

@synthesize progressHUD;

#pragma mark - Class Methods

+ (void)showHUDWithLable:(NSString *) label inView:(UIView *) view
{
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    if(staticProgressHud == nil)
    {
        staticProgressHud = [[ProgressHUD alloc] init];
        [staticProgressHud showHUDWithLable:label inView:view];
    }
    else
    {
        [staticProgressHud showHUDWithLable:label inView:view];

    }
}

+ (void)showHUD:(NSString *)label
{
    if(staticProgressHud == nil)
    {
        staticProgressHud = [[ProgressHUD alloc] init];
        [staticProgressHud showHUDWithLable:label inView:[[UIApplication sharedApplication] delegate].window];
    }
    else
    {
        [staticProgressHud showHUDWithLable:label inView:[[UIApplication sharedApplication] delegate].window];
        
    }
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}
+ (void)hideHUD {
    if (staticProgressHud != nil)
    {
        [staticProgressHud hideHUD];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    }
}

#pragma mark - Public Methods

-(void) showHUDWithLable:(NSString *) label inView:(UIView *) view {
	[self showHUDWithLable:label inView:view animated: YES]; 
}

-(void) hideHUD {
	[progressHUD hide:shownAnimated];
}

-(void) showHUDWithLable:(NSString *) label inView:(UIView *) view animated: (BOOL) animated {
	MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view];
    	HUD.dimBackground = YES;
	self.progressHUD = HUD;
	HUD = nil;
	progressHUD.labelText = label;
	progressHUD.labelFont = [UIFont boldSystemFontOfSize:14];
	progressHUD.delegate = self;
	[view addSubview:progressHUD];
	shownAnimated = animated;
	[progressHUD show:shownAnimated];
}

-(void) setLabel: (NSString *) newLabel {
	progressHUD.labelText = newLabel;
}

- (void) dealloc {
	progressHUD=nil;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden {
	// Remove HUD from screen when the HUD was hidded
	[progressHUD removeFromSuperview];
    
    if (staticProgressHud != nil)
    {
        staticProgressHud = nil;
    }
}

@end
