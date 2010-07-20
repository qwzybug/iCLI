//
//  iCLIAppDelegate.h
//  iCLI
//
//  Created by Devin Chalmers on 7/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iCLIViewController;

@interface iCLIAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iCLIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iCLIViewController *viewController;

@end

