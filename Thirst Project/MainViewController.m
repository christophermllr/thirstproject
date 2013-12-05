//
//  MainViewController.m
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2013, PayPal
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface MainViewController ()

@property (nonatomic, strong, readwrite) IBOutlet UITextField *amountField;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *payButton;
@property (nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property (nonatomic, strong, readwrite) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong, readwrite)          NSMutableArray *schools;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.acceptCreditCards = YES;
    
    // - For live charges, use PayPalEnvironmentProduction (default).
    // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
    // - For testing, use PayPalEnvironmentNoNetwork.
    self.environment = PayPalEnvironmentNoNetwork;
    
    // Parse the school data.
    NSError *e = nil;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.schoolData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An Internet connection is required for the list of schools."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return; //TODO send user back to initial view controller?
    }
    
    self.schools = [NSJSONSerialization JSONObjectWithData:appDelegate.schoolData
                                                   options:kNilOptions
                                                     error:&e];
    if (e) {
        NSLog(@"Error : %@", e);
    }
    
    // Setup view things.
    self.successView.hidden = YES;
    self.amountField.keyboardType = UIKeyboardTypeDecimalPad;
    
    // Set Navbar color for iOS6/7.
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
    }
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalPaymentViewController libraryVersion]);
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
    
    // Optimization: Prepare for display of the payment UI by getting network work done early
    NSString *clientId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalClientId"];
    [PayPalPaymentViewController setEnvironment:self.environment];
    [PayPalPaymentViewController prepareForPaymentUsingClientId:clientId];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.amountField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - School picker

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.schools.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.schools objectAtIndex:row];
}

#pragma mark - Pay action

- (IBAction)pay {
    
    // Remove our last completed payment, just for demo purposes.
    self.completedPayment = nil;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Did the user enter an amount?
    if (self.amountField.text == nil || [self.amountField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter an amount."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (([[self.amountField.text componentsSeparatedByString:@"."] count] - 1) > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"The amount you entered is not valid."
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
    
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSString *selectedText = [self.schools objectAtIndex:row];
    payment.shortDescription = selectedText;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Set the environment:
    [PayPalPaymentViewController setEnvironment:self.environment];
    
    NSString *clientId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalClientId"];
    NSString *emailAddress = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalReceiverEmail"];
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:clientId
                                                                                                 receiverEmail:emailAddress
                                                                                                       payerId:nil
                                                                                                       payment:payment
                                                                                                      delegate:self];
    paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
    
    // Set Navbar color for iOS6/7.
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        
        paymentViewController.navigationBar.barTintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
        paymentViewController.navigationBar.tintColor = [UIColor whiteColor];
        paymentViewController.navigationBar.translucent = NO;
        paymentViewController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        
    } else {
        paymentViewController.navigationBar.tintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
    }
    
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.completedPayment = completedPayment;
    self.successView.hidden = NO;
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    NSLog(@"PayPal Payment Canceled");
    self.completedPayment = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
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
}

- (IBAction)togglePopover:(id)sender {
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
