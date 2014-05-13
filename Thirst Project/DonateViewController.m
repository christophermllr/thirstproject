//
//  DonateViewController.m
//  Thirst Project
//
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "DonateViewController.h"
#import "InfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DeviceUtils.h"
#import "ThirstProjectConfig.h"

@interface DonateViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *selectedSchoolCell;
@property (nonatomic, strong, readwrite) IBOutlet UITextField *amountField;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *payButton;
@property (nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation DonateViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveSchoolSelectedNotification:)
                                                 name:@"SchoolSelected"
                                               object:nil];
    
    self.acceptCreditCards = YES;
    self.selectedSchoolCell.textLabel.text = @"Thirst Project National";
    
    // - For live charges, use PayPalEnvironmentProduction (default).
    // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
    // - For testing, use PayPalEnvironmentNoNetwork.
    self.environment = PayPalEnvironmentSandbox;
    
    // Setup view things.
    self.successView.hidden = YES;
    self.amountField.keyboardType = UIKeyboardTypeDecimalPad;
    
    // Set text field padding to make room for $ label.
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.amountField setLeftViewMode:UITextFieldViewModeAlways];
    [self.amountField setLeftView:spacerView];
    
    // Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15.0f, 0, 14.0f);
    UIImage *payBackgroundImage = [[UIImage imageNamed:@"button_secondary.png"] resizableImageWithCapInsets:insets];
    UIImage *payBackgroundImageHighlighted = [[UIImage imageNamed:@"button_secondary_selected.png"] resizableImageWithCapInsets:insets];
    [self.payButton setBackgroundImage:payBackgroundImage forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:payBackgroundImageHighlighted forState:UIControlStateHighlighted];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [PayPalMobile preconnectWithEnvironment:self.environment];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.amountField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) receiveSchoolSelectedNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"SchoolSelected"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *school = [userInfo objectForKey:@"schoolName"];
        self.selectedSchoolCell.textLabel.text = school;
    }
}

#pragma mark - Pay action

- (IBAction)pay {
    
    // Remove our last completed payment, just for demo purposes.
    self.completedPayment = nil;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Did the user enter an amount?
    if (self.amountField.text == nil || [self.amountField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a Donation Amount"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (([[self.amountField.text componentsSeparatedByString:@"."] count] - 1) > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Donation Amount"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSNumber *number = [NSNumber numberWithDouble:[self.amountField.text doubleValue]];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMaximumFractionDigits:2];
    [fmt setRoundingMode: NSNumberFormatterRoundUp];
    NSString *numstring = [fmt stringFromNumber:number];
    payment.amount = [NSDecimalNumber decimalNumberWithString:numstring];
    payment.currencyCode = @"USD";
    
    // Is donation amount greater than 0
    if ([self.amountField.text doubleValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Donation amount must be greater than $0"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    payment.shortDescription = self.selectedSchoolCell.textLabel.text;
    payment.intent = PayPalPaymentIntentSale;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Create a PayPalPaymentViewController.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
//    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
//                                                           options:0
//                                                             error:nil];
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
    if ([segue.identifier isEqualToString:@"ViewInfo"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        InfoViewController *infoViewController = [navigationController viewControllers][0];
        infoViewController.delegate = self;
    }
}

- (IBAction)togglePopover:(id)sender {
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

#pragma mark - InfoViewControllerDelegate

- (void)infoViewControllerDidClose:(InfoViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
