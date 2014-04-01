//
//  InfoViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 12/5/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "InfoViewController.h"
#import "DeviceUtils.h"
#import "ThirstProjectConfig.h"
#import <MessageUI/MessageUI.h>

@interface InfoViewController ()
@property (nonatomic, retain) IBOutlet UILabel *version;
@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"Version: %@", version];
    
    // Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)sendFeedback:(id)sender
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPFeedbackSubject"]];
    [mc setToRecipients:[NSArray arrayWithObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPFeedbackEmail"]]];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)contactThirstProject:(id)sender
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPContactSubject"]];
    [mc setToRecipients:[NSArray arrayWithObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPContactEmail"]]];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
