//
//  PTContactViewController.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// Contact picker height
#define kContactPickerHeight    45.0

@protocol PTContactViewControllerDelegate;

@interface PTContactViewController : UIViewController {

    UITextField     *textField;
    
    id <PTContactViewControllerDelegate>    delegate;
}

@property (nonatomic,assign) id <PTContactViewControllerDelegate>    delegate;
@property (nonatomic,retain) UITextField  *textField;

@end


@protocol PTContactViewControllerDelegate <NSObject>
- (void)touchPlus:(id)sender;
@end