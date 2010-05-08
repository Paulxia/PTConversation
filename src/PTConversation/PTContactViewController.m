    //
//  PTContactViewController.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTContactViewController.h"

///////////////////////////////////////////////////////////////////////////////////
// Private Methods
@interface PTContactViewController (Private)
- (void)createContactPicker;
- (void)showPeoplePickerController;
- (void)chooseContact:(id)sender;
@end



@implementation PTContactViewController

@synthesize delegate;
@synthesize textField;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createContactPicker];
}


- (void)createContactPicker
{

    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"To:";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont systemFontOfSize:14.0];
    label.frame = CGRectMake(10, 0, 60.0f, kContactPickerHeight);
    [self.view addSubview:label];
    [label release];
    
    // Add Text field
    textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 14.0, self.view.frame.size.width - 110, kContactPickerHeight - 24)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.placeholder = @"Enter phone number";   
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:14.0];
    
    //[textField  performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5f];
    [self.view addSubview:textField];
    //[textField release];
    
    // Create Add Button
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton setFrame:CGRectMake(self.view.frame.size.width - 35, 9, 32, 30)];
    [addButton addTarget:self action:@selector(chooseContact:) forControlEvents:UIControlEventTouchUpInside];
    addButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:addButton];
}


#pragma mark -
#pragma mark Action methods

- (void)chooseContact:(id)sender
{
    [self.delegate touchPlus:sender];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.textField = nil;
}


- (void)dealloc {
    [textField release];
    [super dealloc];
}


@end
