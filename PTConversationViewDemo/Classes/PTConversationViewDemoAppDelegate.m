//
//  PTConversationViewDemoAppDelegate.m
//  PTConversationViewDemo
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright Picktek LLC 2010. All rights reserved.
//

#import "PTConversationViewDemoAppDelegate.h"
#import "RootViewController.h"


@implementation PTConversationViewDemoAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize data;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
   
    
	NSString *Path = [[NSBundle mainBundle] bundlePath];
	NSString *DataPath = [Path stringByAppendingPathComponent:@"data.plist"];
	
	NSDictionary *tempDict = [[NSDictionary alloc] initWithContentsOfFile:DataPath];
	self.data = tempDict;
	[tempDict release];

    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [data release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

