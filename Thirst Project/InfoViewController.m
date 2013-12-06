//
//  InfoViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 12/5/13.
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "InfoViewController.h"
#import "AMBlurView.h"
#import "AppDelegate.h"

@interface InfoViewController ()
@property (nonatomic, retain) IBOutlet UILabel *version;
@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    AMBlurView *blurView = [AMBlurView new];
//    [blurView setFrame:CGRectMake(0.0f,0.0f,320.0f,480.0f)];
//    [self.view addSubview:blurView];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"Version: %@", version];
    
    // Set Navbar color for iOS6/7.
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self.delegate infoViewControllerDidClose:self];
}

@end
