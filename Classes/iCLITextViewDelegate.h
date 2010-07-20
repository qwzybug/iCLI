//
//  iCLITextViewDelegate.h
//  iCLI
//
//  Created by Devin Chalmers on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iCLICommandDelegate;

@interface iCLITextViewDelegate : NSObject <UITextViewDelegate> {
	id<iCLICommandDelegate> delegate;
}

@property (nonatomic, assign) id<iCLICommandDelegate> delegate;
@property (nonatomic, assign) int promptLength;

@end

@protocol iCLICommandDelegate
- (void)processCommand:(NSString *)command;
@end
