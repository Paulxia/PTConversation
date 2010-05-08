//
//  RootViewController.h
//  PTConversationViewDemo
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright Picktek LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTConversation/PTConversationViewController.h"

@interface RootViewController : UITableViewController <PTConversationViewControllerDelegate> {
	
	NSArray *tableDataSource;
	NSString *CurrentTitle;
	NSInteger CurrentLevel;
    NSMutableArray  *buddies;
    NSMutableArray  *messages;
}

@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSString *CurrentTitle;
@property (nonatomic, readwrite) NSInteger CurrentLevel;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSMutableArray *buddies;

@end

