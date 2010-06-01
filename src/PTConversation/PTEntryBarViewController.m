    //
//  PTEntryBarViewController.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTEntryBarViewController.h"

//
// BCZeroEdgeTextView
//
// UITextView seems to automatically be resetting the contentInset
// bottom margin to 32.0f, causing strange scroll behavior in our small
// textView.  Maybe there is a setting for this, but it seems like odd behavior.
// override contentInset to always be zero.
//
@implementation BCZeroEdgeTextView

- (UIEdgeInsets) contentInset { return UIEdgeInsetsZero; }

@end

///////////////////////////////////////////////////////////////////////////////////
// Private Methods
@interface PTEntryBarViewController (Private)
- (void) resizeEntryBarInHeight:(NSString*)text;
- (void) updateButtons;
- (void)createEntryBar;
- (void)toucheMedia:(id)sender;
- (void)toucheSend:(id)sender;
@end

@implementation PTEntryBarViewController

@synthesize style = _style;
@synthesize cameraButton;
@synthesize sendButton;
@synthesize textView;
@synthesize contentView;
@synthesize delegate;


- (id)initWithStyle:(PTEntryBarViewControllerStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void) loadView
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - kEntryBarHeight, rect.size.width, kEntryBarHeight)];    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, kEntryBarHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    contentView.autoresizesSubviews = YES;
    [self.view addSubview:contentView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self createEntryBar];
    [self updateButtons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self updateButtons];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateButtons];
}


- (void)createEntryBar
{
    // Background image
    UIImageView *viewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    viewBackground.image = [UIImage imageNamed:@"PTConversationView.bundle/images/entry_bar.png"];
    
    // Rounded text field image
    UIImageView *viewRoundedImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 7.0f, self.contentView.frame.size.width - 115.0f, self.contentView.frame.size.height - 14.0f)];
    viewRoundedImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    viewRoundedImage.image = [[UIImage imageNamed:@"PTConversationView.bundle/images/entry_text.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0];
    
    // Text entry
    self.textView = [[BCZeroEdgeTextView alloc] initWithFrame:CGRectMake(47.0f, 13.0f, self.contentView.frame.size.width - 130.0f, self.contentView.frame.size.height - 24.0f)];  
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.delegate = self;
    
    // Remove Paddings
    self.textView.contentInset = UIEdgeInsetsMake(-11,-8,0,0);    
    self.textView.font = [UIFont systemFontOfSize:14.0];
    self.textView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.textView.tag = kPTEntryBarTextFieldTag;
    
    //[viewText  performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5f];
    
    /*if(self.conversationStyle == ConversationViewControllerStyleDefault) {
        [viewText  performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5f];
    }*/
    
    // Create Camera Button
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"PTConversationView.bundle/images/button_camera.png"] 
                            forState:UIControlStateNormal];
    [self.cameraButton setFrame:CGRectMake(5, 6, 28, 28)];
    [self.cameraButton addTarget:self action:@selector(toucheMedia:) 
           forControlEvents:UIControlEventTouchUpInside];
    //self.cameraButton.tag = kPTEntryBarCameraButtonTag;
    
    // Create Send Button
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"PTConversationView.bundle/images/blue_button_bkg.png"] 
                          forState:UIControlStateNormal];
    [self.sendButton setFrame:CGRectMake(self.contentView.frame.size.width - 70, 6, 66, 28)];
    [self.sendButton setTitle:kSendButtonTitle 
                forState:UIControlStateNormal];
    self.sendButton.titleLabel.font            = [UIFont boldSystemFontOfSize:14];
    self.sendButton.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
    self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.sendButton.titleLabel.shadowOffset    = CGSizeMake (1.0, 0.0);
    [self.sendButton addTarget:self action:@selector(toucheSend:) 
         forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.tag = kPTEntryBarSendButtonTag;
    
    [self.contentView addSubview:viewBackground];
    [self.contentView addSubview:viewRoundedImage];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.cameraButton];
    [self.contentView addSubview:self.sendButton];
    
    [viewBackground release];
    [viewRoundedImage release];
    //[textView release];
}


#pragma mark -
#pragma mark UITextView delegate methods

- (void) resizeEntryBarInHeight:(NSString*) text
{
    // We need to know text height to expand and shrink UITextView appropriately.
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] 
                   constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 150, 2000)
                       lineBreakMode:UILineBreakModeWordWrap];
    
    
    float finalHeight = 0;
    if(size.height > 0) {
        finalHeight = size.height - 18;
    }
    
    // Minimum Entry Bar height is kMessageBarHeight pixel
    if(self.contentView.frame.size.height != finalHeight && (finalHeight >= 0 && finalHeight <= 36)) {
        
        // Start animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.15f];
        
        // Change current UITextView's frame property in height
        [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x, (finalHeight * -1), self.contentView.frame.size.width,  kEntryBarHeight + finalHeight)];
        
        // Perform animation
        [UIView commitAnimations];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
 
    NSString *fullText = self.textView.text;
    
    // We assume that empty string is backspace
    if( ![text isEqualToString:@""]) {
        fullText = [NSString stringWithFormat:@"%@%@ ",self.textView.text, text];
    }
    
    // Resize Entry Bar appropriately 
    [self resizeEntryBarInHeight:fullText];
    
    return TRUE;
}


- (void)textViewDidChange:(UITextView *)textView {
    [self updateButtons];
}


#pragma mark -
#pragma mark Action methods

- (void) updateButtons
{
    if([self.textView.text length] > 0 ) {
        [sendButton setEnabled:YES];
       //[cameraButton setEnabled:YES];
    } else {
        [sendButton setEnabled:NO];
       //[cameraButton setEnabled:NO];
    }
}

- (void)toucheMedia:(id)sender
{
    [self.delegate touchMedia:self];
}

- (void)toucheSend:(id)sender
{
    if([self.delegate touchSend:self text:self.textView.text]) {
        
        // clear input 
        self.textView.text = @"";
        [self resizeEntryBarInHeight:self.textView.text];
    }
}

#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.cameraButton = nil;
    self.sendButton = nil;
    self.textView = nil;
    self.contentView = nil;
}


- (void)dealloc {
    [cameraButton release];
    [sendButton release];
    [textView release];
    [contentView release];
    [super dealloc];
}


@end
