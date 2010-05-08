//
//  PTViewController.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PTViewController : UIViewController {

    BOOL _autoresizesForKeyboard;
    BOOL _isViewAppearing;
}

/**
 * The view is currently visible.
 */
@property(nonatomic,readonly) BOOL isViewAppearing;

/**
 * Determines if the view will be resized automatically to fit the keyboard.
 */
@property(nonatomic) BOOL autoresizesForKeyboard;

/**
 * Sent to the controller before the keyboard slides in.
 */
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller before the keyboard slides out.
 */
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid in.
 */
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid out.
 */
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
