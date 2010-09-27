//
//  PTConversationViewController.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PTViewController.h"
#import "PTConversationTableViewController.h"
#import "PTEntryBarViewController.h"
#import "PTContactViewController.h"
#import "PTConversationHelper.h"

#define kProgresBar         101

typedef enum {
    PTConversationViewStyleSimple = 0,
    PTConversationViewStyleMedia = 1,
} PTConversationViewStyle;


@protocol PTConversationViewControllerDelegate;

@interface PTConversationViewController : PTViewController <PTConversationTableViewControllerDelegate,PTEntryBarViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PTContactViewControllerDelegate> {

    PTConversationViewStyle             _style;
    NSString                            *saveTitle;
    
    PTConversationTableViewController   *conversationTableViewController;
    PTEntryBarViewController            *entryBarViewController;
    PTContactViewController             *contactViewController;
    
    id<PTConversationViewControllerDelegate> delegate;
    
    
    // View manipulaiton
    BOOL                                showContact;
    UIView                              *_container;
    
    // Progress Bar
    UIProgressView                      *progressView;
    
    PTConversationMessage               *currentSelectedMessage;
    
}

/**
 * Conversation view style read-only.
 */
@property(nonatomic,readonly) PTConversationViewStyle style;

@property(nonatomic,retain) PTConversationTableViewController *conversationTableViewController;
@property(nonatomic,retain) PTEntryBarViewController *entryBarViewController;
@property(nonatomic,retain) PTContactViewController *contactViewController;
@property(nonatomic,assign) id<PTConversationViewControllerDelegate> delegate;
@property(nonatomic,readonly) UIProgressView *progressView;
@property(nonatomic,retain) PTConversationMessage *currentSelectedMessage;
@property(nonatomic,assign) BOOL showContact;

@property(nonatomic,copy) NSString *saveTitle;

    
- (void) becomeEntryBar;
- (void) resignEntryBar;
- (void) becomeContact;
- (void) resignContact;
- (void) showLastMessage:(BOOL)aimation;
- (void) reloadMessages;
- (void) showContact:(BOOL)show;
- (void) showProgress:(BOOL)show;
- (void) setProgress:(CGFloat)completed;
- (void) chooseDialog;

@end




@protocol PTConversationViewControllerDelegate <NSObject>

@required
- (int)messageCount:(PTConversationViewController *)controller;
- (PTConversationMessage*)conversationView:(PTConversationViewController*)controller messageAt:(int)row;

@optional
- (void)conversationDidLoad:(PTConversationViewController *)controller tableView:(UITableView*)tableView;
- (void)conversationDidUnload:(PTConversationViewController *)controller tableView:(UITableView*)tableView;
- (void)touchAttention:(PTConversationViewController *)controller tableView:(UITableView*)tableView message:(PTConversationMessage*)message;
- (BOOL)messageWillSend:(PTConversationViewController *)controller tableView:(UITableView*)tableView message:(PTConversationMessage*)message;
- (void)messageDidSent:(PTConversationViewController *)controller tableView:(UITableView*)tableView message:(PTConversationMessage*)message;
- (BOOL)chooseMedia:(PTConversationViewController *)controller tableView:(UITableView*)tableView;
- (BOOL)headerButton:(UIButton*)button;
- (void)touchPlus:(PTConversationViewController *)controller tableView:(UITableView*)tableView sender:(id)sender;
@end

