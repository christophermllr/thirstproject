//
//  DonateViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 4/15/13.
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "DonateViewController.h"

@interface DonateViewController ()

@end

@implementation DonateViewController

- (IBAction)pay {
    
    NSString *clientId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalClientId"];
    NSString *emailAddress = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalEmailAddress"];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"39.95"]; //TODO get from UI?
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Awesome saws"; //TODO get selected chapter from UI, tag with "via iOS"
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    // Start out working with the test environment! When you are ready, remove this line to switch to live.
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
    // from the previous step, and a PayPalPaymentDelegate to handle the results.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:clientId
        receiverEmail:emailAddress
        payerId:nil
        payment:payment
        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    //[self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
