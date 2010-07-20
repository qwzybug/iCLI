//
//  iCLIViewController.m
//  iCLI
//
//  Created by Devin Chalmers on 7/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iCLIViewController.h"

#define PROMPT @"> "

@implementation iCLIViewController

@synthesize textView;
@synthesize textViewDelegate;

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[textView release], textView = nil;
	
	if (textViewDelegate.delegate == self) textViewDelegate.delegate = nil;
	[textViewDelegate release], textViewDelegate = nil;
	
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    return YES;
}

- (void)viewDidLoad;
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
	
	self.textViewDelegate.promptLength = PROMPT.length;
	
	[self.textView becomeFirstResponder];
	self.textView.font = [UIFont fontWithName:@"Courier New" size:14.0];
	
	[self showOutput:@"Welcome to iCLI!\n"];
}

- (void)showOutput:(NSString *)output;
{
	self.textView.text = [self.textView.text stringByAppendingFormat:@"\n%@\n%@", output, PROMPT];
	self.textView.selectedRange = NSMakeRange(self.textView.text.length, 0);
}

#pragma mark -
#pragma mark Command delegate

- (void)processCommand:(NSString *)command;
{
	NSString *processed = [command uppercaseString];
	[self showOutput:processed];
}

#pragma mark -
#pragma mark Keyboard handling

- (void)keyboardNotification:(NSNotification *)notification;
{
	CGRect kbFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	kbFrame = [self.view convertRect:kbFrame fromView:nil];
	
	double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];
	
	CGRect textFrame = self.textView.frame;
	textFrame.size.height = kbFrame.origin.y - textFrame.origin.y;
	self.textView.frame = textFrame;
	
	[UIView commitAnimations];
}

@end
