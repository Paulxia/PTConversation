//
//  PTConversationTableViewController.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTConversationMessage.h"
#import "PTConversationViewCell.h"

@protocol PTConversationTableViewControllerDelegate;

@interface PTConversationTableViewController : UITableViewController {

    id<PTConversationTableViewControllerDelegate>  delegate;
}

@property (nonatomic, assign) id<PTConversationTableViewControllerDelegate> delegate;


@end


@protocol PTConversationTableViewControllerDelegate <NSObject>
- (int)messageCount:(PTConversationTableViewController *)controller;
- (PTConversationMessage*)messageAt:(PTConversationTableViewController *)controller row:(int)row;
- (void)touchAttention:(PTConversationTableViewController *)controller message:(PTConversationMessage*)message;
@end
