//
//  PTContactViewController.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Three20/Three20.h"
#import "Three20UI/UIViewAdditions.h"

// Contact picker height
#define kContactPickerHeight    45.0

@protocol PTContactViewControllerDelegate;

@interface PTContactViewController : TTViewController <UITextFieldDelegate> {

    UIScrollView*     _scrollView;
    
    TTPickerTextField     *textField;
    
    id <PTContactViewControllerDelegate>    delegate;
}

@property (nonatomic,assign) id <PTContactViewControllerDelegate>    delegate;
@property (nonatomic,retain) TTPickerTextField  *textField;

- (void)layoutViews;

@end


@protocol PTContactViewControllerDelegate <NSObject>
- (void)touchPlus:(id)sender;
@end