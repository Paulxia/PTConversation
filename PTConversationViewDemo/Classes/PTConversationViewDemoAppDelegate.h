//
//  PTConversationViewDemoAppDelegate.h
//  PTConversationViewDemo
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright Picktek LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTConversationViewDemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    
    NSDictionary *data;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSDictionary *data;


@end

