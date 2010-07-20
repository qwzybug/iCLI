//
//  iCLIViewController.m
//  iCLI
//
//  Created by Devin Chalmers on 7/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iCLIViewController.h"

#import "lualib.h"
#import "lauxlib.h"

#define PROMPT @"> "

static NSMutableString *resultString;

static int l_print(lua_State *L) {
	const char *msg = luaL_checkstring(L, 1);
	[resultString appendString:[NSString stringWithFormat:@"%s", msg]];
	return 0;
}

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
	
	[self showOutput:@"Welcome to iCLI. Now with Lua™!\n"];
	
	L = lua_open();
	luaL_openlibs(L);
	lua_pushcfunction(L, l_print);
	lua_setglobal(L, "print");
}

- (void)stackTrace;
{
	int i;
	int top = lua_gettop(L);
	for (i = 1; i <= top; i++) {  /* repeat for each level */
        int t = lua_type(L, i);
        switch (t) {
				
			case LUA_TSTRING:  /* strings */
				printf("`%s'", lua_tostring(L, i));
				break;
				
			case LUA_TBOOLEAN:  /* booleans */
				printf(lua_toboolean(L, i) ? "true" : "false");
				break;
				
			case LUA_TNUMBER:  /* numbers */
				printf("%g", lua_tonumber(L, i));
				break;
				
			default:  /* other values */
				printf("%s", lua_typename(L, t));
				break;
				
        }
        printf("  ");  /* put a separator */
	}
	printf("\n");  /* end the listing */	
}


- (void)showOutput:(NSString *)output;
{
	NSMutableString *out = [NSMutableString stringWithString:@"\n"];
	if (output && output.length > 0)
		[out appendFormat:@"%@\n", output];
	[out appendString:PROMPT];
	self.textView.text = [self.textView.text stringByAppendingString:out];
	self.textView.selectedRange = NSMakeRange(self.textView.text.length, 0);
}

#pragma mark -
#pragma mark Command delegate

static int report (lua_State *L, int status, id self) {
  if (status && !lua_isnil(L, -1)) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) msg = "(error object is not a string)";
	[self showOutput:[NSString stringWithCString:msg encoding:NSASCIIStringEncoding]];
    lua_pop(L, 1);
  }
  return status;
}

- (void)processCommand:(NSString *)command;
{
	[resultString release];
	resultString = [[NSMutableString alloc] initWithCapacity:80];
	const char *s = [command cStringUsingEncoding:NSASCIIStringEncoding];
	int status = luaL_loadbuffer(L, s, strlen(s), "command") ||
				 lua_pcall(L, 0, 0, 0);;
	status = report(L, status, self);
	if (!status) {
		[self showOutput:resultString];
	}
	
	[self stackTrace];
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
