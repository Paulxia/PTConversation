//
//  PTEntryBarViewController.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PTConversationHelper.h"

#define kEntryBarHeight             40.0f

#define kPTEntryBarTextFieldTag         101
#define kPTEntryBarCameraButtonTag      102
#define kPTEntryBarSendButtonTag        103

#define kSendButtonTitle                @"Send"

typedef enum {
    PTEntryBarViewControllerStyleSimple = 0,
    PTEntryBarViewControllerStyleMedia = 1,
} PTEntryBarViewControllerStyle;


//
// BCZeroEdgeTextView
//
// UITextView seems to automatically be resetting the contentInset
// bottom margin to 32.0f, causing strange scroll behavior in our small
// textView.  Maybe there is a setting for this, but it seems like odd behavior.
// override contentInset to always be zero.
//
@interface BCZeroEdgeTextView : UITextView
@end



@protocol PTEntryBarViewControllerDelegate;

@interface PTEntryBarViewController : UIViewController <UITextViewDelegate> {
 
    PTEntryBarViewControllerStyle _style;

    id<PTEntryBarViewControllerDelegate> delegate;
    
    UIButton            *cameraButton;
    UIButton            *sendButton;
    BCZeroEdgeTextView  *textView;
    
    CGFloat             frameHeight;
    
}

@property (nonatomic) PTEntryBarViewControllerStyle style;
@property (nonatomic,assign) id<PTEntryBarViewControllerDelegate> delegate;
@property (nonatomic,retain) UIButton *cameraButton;
@property (nonatomic,retain) UIButton *sendButton;
@property (nonatomic,retain) BCZeroEdgeTextView  *textView;
@end


@protocol PTEntryBarViewControllerDelegate <NSObject>
- (BOOL)touchSend:(PTEntryBarViewController *)controller text:(NSString*)text;
- (void)touchMedia:(PTEntryBarViewController *)controller;

@end