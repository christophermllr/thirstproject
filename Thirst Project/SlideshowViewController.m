//
//  SlideshowViewController.m
//  KenBurns
//
//  Created by Javier Berlana on 9/23/11.
//  Copyright (c) 2011, Javier Berlana
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this 
//  software and associated documentation files (the "Software"), to deal in the Software 
//  without restriction, including without limitation the rights to use, copy, modify, merge, 
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
//  to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies 
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
//  IN THE SOFTWARE.
//

#import "SlideshowViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideshowViewController
@synthesize kenView;
@synthesize label;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.kenView.layer.borderWidth = 1;
    self.kenView.layer.borderColor = [UIColor blackColor].CGColor;
    self.kenView.delegate = self;
    
    // TODO this isn't working
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSArray *images = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"Photo1"],
                         [UIImage imageNamed:@"Photo2"],
                         [UIImage imageNamed:@"Photo3"],
                         [UIImage imageNamed:@"Photo4"],
                         [UIImage imageNamed:@"Photo5"],
                         [UIImage imageNamed:@"Logo"], nil];
    
    [self.kenView animateWithImages:images
                 transitionDuration:6
                               loop:NO
                        isLandscape:NO];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma KenBurnsViewDelegate
- (void)didShowImageAtIndex:(NSUInteger)index
{
    NSArray *headings = [NSArray arrayWithObjects:
                         @"Almost 1 billion people on our planet don't have access to safe, clean drinking water and proper sanitization. That's one in every eight of us.",
                         @"4,500 children die every day from diseases caused by contaminated water. That's huge.",
                         @"That's approximately one child every 15 seconds.",
                         @"80% of all global diseases are water-borne and result from drinking contaminated water.",
                         @"These diseases kill more than 2.2 million people every year.",
                         @"",
                         nil];

    self.label.text = [headings objectAtIndex:index];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    self.label.shadowColor = [UIColor blackColor];
    self.label.shadowOffset = CGSizeMake(0.0, 1.0);
    
    NSLog(@"Finished image: %d", index);
}

- (void)didFinishAllAnimations
{
    self.kenView.delegate = nil;
    [self setKenView:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
