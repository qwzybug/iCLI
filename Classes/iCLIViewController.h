//
//  iCLIViewController.h
//  iCLI
//
//  Created by Devin Chalmers on 7/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCLITextViewDelegate.h";

#import "lua.h"

@interface iCLIViewController : UIViewController <iCLICommandDelegate> {
	lua_State *L;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet iCLITextViewDelegate *textViewDelegate;

- (void)showOutput:(NSString *)output;

@end

