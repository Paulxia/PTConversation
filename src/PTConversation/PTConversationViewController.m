    //
//  PTConversationViewController.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTConversationViewController.h"``

///////////////////////////////////////////////////////////////////////////////////
// Private Methods
@interface PTConversationViewController (Private)
- (void)addHeaderButtons;
- (void)createProgressView;
- (void)conversationDidLoad;
@end

@implementation PTConversationViewController

@synthesize style = _style;
@synthesize conversationTableViewController;
@synthesize entryBarViewController;
@synthesize contactViewController;
@synthesize showContact;
@synthesize progressView;
@synthesize currentSelectedMessage;
@synthesize delegate;
@synthesize saveTitle;

- (id)initWithStyle:(PTConversationViewStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.autoresizesForKeyboard = YES;
    
    CGRect rect = self.view.frame;
    
    self.saveTitle = self.title;

    // Initialize container
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Create Conversation TableView
    conversationTableViewController = [[PTConversationTableViewController alloc] initWithStyle:UITableViewStylePlain];
    conversationTableViewController.tableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - kEntryBarHeight);
    //conversationTableViewController.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    conversationTableViewController.delegate = self;
    [_container addSubview:conversationTableViewController.tableView];

    // Create Conversation Entry bar
    entryBarViewController = [[PTEntryBarViewController alloc] initWithStyle:PTEntryBarViewControllerStyleMedia];
    entryBarViewController.delegate = self;
    //entryBarViewController.view.frame = CGRectMake(0, rect.size.height - kEntryBarHeight, rect.size.width, kEntryBarHeight);
    entryBarViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_container addSubview:entryBarViewController.view];
    
    // Create Contact picker view
    contactViewController = [[PTContactViewController alloc] init];
    contactViewController.delegate = self;
    [contactViewController.view setHidden:!self.showContact];
    contactViewController.view.frame = CGRectMake(0, 0, rect.size.width, kContactPickerHeight);
    contactViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth; // | UIViewAutoresizingFlexibleTopMargin;
    [_container addSubview:contactViewController.view];
    
    [self.view addSubview:_container];
    
    // Add button in table view
    [self addHeaderButtons];
    
    // Create Progress View
    [self createProgressView];
    
    // Waiting half second to complete initialization
    [self performSelector:@selector(conversationDidLoad) withObject:nil afterDelay:0.7f];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addHeaderButtons
{
    CGFloat buttonWidth = 200.0f;
    CGFloat buttonHeight = 30.0f;
    
    UITableView *tableView = conversationTableViewController.tableView;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, buttonHeight + 10)];
    parent.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parent.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake((tableView.frame.size.width - buttonWidth) /2, 5, buttonWidth, buttonHeight)];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //[button addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"Call" forState:UIControlStateNormal];
    
    if([self.delegate headerButton:button]) {
        [parent addSubview:button];
        tableView.tableHeaderView = parent;
        
    } else {
        [parent release];
    }    
}

#pragma mark -
#pragma mark Keyboard Notification methods

- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
    _container.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, self.view.frame.size.height - bounds.size.height);
}

- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {
    // When keyboard appears resize view appropriately 
    _container.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, self.view.frame.size.height - bounds.size.height);
}

- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    // When keyboard disappears resize view appropriately 
    _container.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, self.view.frame.size.height + bounds.size.height);
}


- (void)conversationDidLoad {
    [self.delegate conversationDidLoad:self tableView:conversationTableViewController.tableView];
}

#pragma mark -
#pragma mark Message Delegate methods

- (int)messageCount:(PTConversationTableViewController *)controller
{
    return [self.delegate messageCount:self];
}

- (PTConversationMessage*)messageAt:(PTConversationTableViewController *)controller row:(int)row
{
    return [self.delegate conversationView:self messageAt:row];
}

- (void)touchAttention:(PTConversationTableViewController *)controller message:(PTConversationMessage*)message
{
    //self.currentSelectedMessage = message;
    [self.delegate touchAttention:self tableView:self.conversationTableViewController.tableView message:message];
}

- (BOOL)touchSend:(PTEntryBarViewController *)controller text:(NSString*)text
{
    BOOL send = TRUE;
    PTConversationMessage *message = [PTConversationMessage initWithText:text
                                   type:PTConversationMessageTypeOutgoing
                                   date:[NSDate date]
                            sendFailed:FALSE];
    
    UITableView *tView = self.conversationTableViewController.tableView;
    
    // Reset progress bar
    [self setProgress:0];
    
    // Save current massage
    self.currentSelectedMessage = message;
    
    send = [self.delegate messageWillSend:self tableView:tView message:message];
    if(send) {
        [self.delegate messageDidSent:self tableView:tView message:message];
    }
    
    [message release];
    
    return send;
}

- (void)touchMedia:(PTEntryBarViewController *)controller {
    
    BOOL implemented = FALSE;
    
    if([self.delegate respondsToSelector:@selector(chooseMedia:tableView:)] ) {
        implemented = [self.delegate chooseMedia:self tableView:self.conversationTableViewController.tableView];
    } 
    
    if(!implemented) {
        [self chooseDialog];
    }
}

#pragma mark -
#pragma mark Contact delegate methods

- (void)touchPlus:(id)sender
{
    [self.delegate touchPlus:self tableView:self.conversationTableViewController.tableView sender:sender];
}



#pragma mark -
#pragma mark Media picker methods

- (void)chooseDialog
{
    NSString *title = NSLocalizedString(@"TakePhoto", @"");
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];     
    if([mediaTypes containsObject:@"public.movie"]) {
        title = NSLocalizedString(@"TakePhotoOrVideo", @"");
    }
    
	// open a dialog with Reload and Cabcel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:title, NSLocalizedString(@"ChooseFromLibrary", @""), nil];
    
    
    
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[actionSheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    @try {
        if(buttonIndex == 0 || buttonIndex == 1) {
            
            imagePicker.delegate = self;        
            
            if(buttonIndex == 0) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];     
            
            if([imagePicker.mediaTypes containsObject:@"public.movie"]) {
//#ifdef __IPHONE_3_1
                //imagePicker.allowsEditing = YES;
                imagePicker.videoMaximumDuration = 300; // 5min
//#else
                //imagePicker.allowsImageEditing = YES;
                
//#endif
            }
            
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
    @catch (NSException *exception) { 
        NSLog(@"UIImagePickerControllerSourceTypeCamera: Caught %@: %@", [exception name], [exception reason]);
    }
    
    @finally {
        [imagePicker release];
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL send = TRUE;
    
    [self.entryBarViewController.textView becomeFirstResponder];
    
    PTConversationMessage *message = [PTConversationHelper mediaInfoToMessage:picker 
                                                                         info:info 
                                                                         text:self.entryBarViewController.textView.text 
                                                                         type:PTConversationMessageTypeOutgoing]; 
    UITableView *tView = self.conversationTableViewController.tableView;
    
    
    [picker dismissModalViewControllerAnimated:NO];
    
    // Save current massage
    self.currentSelectedMessage = message;
    
    send = [self.delegate messageWillSend:self tableView:tView message:message];
    if(send) {
        [self.delegate messageDidSent:self tableView:tView message:message];
        
        self.entryBarViewController.textView.text = @"";
    }
    
    [message release];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.entryBarViewController.textView becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Progress View methods

- (void) createProgressView
{
    progressView = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 5.0f, 100.0f, 30.0f)];
    [progressView setHidden:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, 0.0f, 100.0f, 15.0f)];
    label.text = NSLocalizedString(@"Sending", @"");
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    UIProgressView *progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0f, 17.0f, 100.0f, 10.0f)];
    progressBar.progressViewStyle = UIProgressViewStyleBar;
    progressBar.tag = kProgresBar;
    
    [progressView addSubview:label];
    [progressView addSubview:progressBar];
    [label release];
    [progressBar release];
    
    [[[self navigationController] navigationBar] addSubview:progressView];
}



#pragma mark -
#pragma mark Helper methods

- (void) becomeEntryBar {
    [self.entryBarViewController.textView becomeFirstResponder];
}

- (void) resignEntryBar {
    [self.entryBarViewController.textView resignFirstResponder];
}


- (void) becomeContact {
    [self.contactViewController.textField becomeFirstResponder];
}

- (void) resignContact {
    [self.contactViewController.textField resignFirstResponder];
}


- (void) showLastMessage:(BOOL)aimation
{
    int count = [self.delegate messageCount:self];
    UITableView *tView = self.conversationTableViewController.tableView;
    
    if(count > 0) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(count - 1) inSection:0];
        [tView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:aimation];
    }
}

- (void) reloadMessages
{
    UITableView *tView = self.conversationTableViewController.tableView;
    [tView reloadData];
}

- (void) showContact:(BOOL)show
{
    [contactViewController.view setHidden:!show];
}

- (void) showProgress:(BOOL)show
{
    [self.progressView setHidden:!show];

    if(show) {
        self.title = @"";
    } else {
        self.title = self.saveTitle;
    }
}

- (void) setProgress:(CGFloat)completed
{
    [(UIProgressView*)[self.progressView viewWithTag:kProgresBar] setProgress:completed];
    
}


#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.currentSelectedMessage = nil;
    self.conversationTableViewController = nil;
    self.entryBarViewController = nil;
    self.contactViewController = nil;
    self.autoresizesForKeyboard = NO;
    
}


- (void)dealloc {
    [self.delegate conversationDidUnload:self tableView:conversationTableViewController.tableView];
    
    self.autoresizesForKeyboard = NO;
    
    [currentSelectedMessage release];
    [entryBarViewController release];
    [conversationTableViewController release];
    [contactViewController release];
    [_container release];
    [super dealloc];
}


@end
