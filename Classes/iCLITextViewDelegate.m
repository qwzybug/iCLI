//
//  iCLITextViewDelegate.m
//  iCLI
//
//  Created by Devin Chalmers on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iCLITextViewDelegate.h"

@implementation iCLITextViewDelegate

@synthesize delegate;
@synthesize promptLength;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
	NSUInteger start = 0, end = 0, contentsEnd = 0;
	[textView.text getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:range];
	
	// end == contentsEnd iff we're on the last line
	if (end != contentsEnd)
		return NO;
	
	// can't change the prompt!
	if (range.location - start < self.promptLength)
		return NO;
	
	if ([text isEqual:@"\n"]) {
		// newline: process the command!
		NSRange commandRange = NSMakeRange(start + self.promptLength, contentsEnd - start - self.promptLength);
		NSString *command = [textView.text substringWithRange:commandRange];
		[self.delegate processCommand:command];
		return NO;
	}
	
	return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView;
{
	// by default, it likes to chop off the trailing space after the prompt when you try and place the carat.
	// I hate that.
	NSRange range = textView.selectedRange;
	NSUInteger start = 0, end = 0, contentsEnd = 0;
	@try {
		[textView.text getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:range];
			
		if (range.length == 0 && range.location - start < self.promptLength) {
			range.location = start + self.promptLength;
			textView.selectedRange = range;
		}
	}
	@catch (NSException *e) {
		NSLog(@"Er, what? %@", NSStringFromRange(range));
	}
}

@end
