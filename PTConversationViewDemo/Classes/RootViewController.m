//
//  RootViewController.m
//
//  RootViewController.h
//  PTConversationViewDemo
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright Picktek LLC 2010. All rights reserved.
//


#import "RootViewController.h"
#import "PTConversationViewDemoAppDelegate.h"
#import "DetailViewController.h"

@implementation RootViewController

@synthesize tableDataSource, CurrentTitle, CurrentLevel;
@synthesize messages,buddies;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(CurrentLevel == 0) {
		
		//Initialize our table data source
		//NSArray *tempArray = [[NSArray alloc] init];
		//self.tableDataSource = tempArray;
		//[tempArray release];
		self.buddies = [[NSMutableArray alloc] initWithObjects:@"Anzori", @"Mogeli", @"Goderdzi", @"Machvi",
                                nil];
		//PTConversationViewDemoAppDelegate *AppDelegate = (PTConversationViewDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
		//self.tableDataSource = [AppDelegate.data objectForKey:@"Rows"];
		
		self.navigationItem.title = @"Buddies";
	}
	else 
		self.navigationItem.title = CurrentTitle;	
    
    
    messages = [[NSMutableArray alloc] initWithObjects:
                [PTConversationMessage initWithText:@"Hello 1" 
                                               type:PTConversationMessageTypeOutgoing
                                               date:[NSDate date]
                                          sendFailed:TRUE], 
                [PTConversationMessage initWithText:@"Hello 2\nAba vnaxot enterze ras izams :D" 
                                               type:PTConversationMessageTypeIncoming
                                               date:[NSDate date]
                                         sendFailed:TRUE], 
                [PTConversationMessage initWithText:@"Hello 3\nGauketebia ras erchit" type:PTConversationMessageTypeOutgoing],
                [PTConversationMessage initWithText:@"Hello 4" type:PTConversationMessageTypeIncoming],
                [PTConversationMessage initWithText:@"Hello 5" type:PTConversationMessageTypeOutgoing],
                [PTConversationMessage initWithText:@"Hello 6" type:PTConversationMessageTypeIncoming],
                [PTConversationMessage initWithText:@"Hello 7" type:PTConversationMessageTypeOutgoing],
                [PTConversationMessage initWithText:@"Hello 8" type:PTConversationMessageTypeOutgoing],
                nil];
    
    
    
    //[[self navigationController] setToolbarHidden:NO];
    //[[self navigationController] setNavigationBarHidden:YES];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
                                               target: self
                                               action: @selector(new)] autorelease];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;

}

#pragma mark Actions

- (void) new 
{
    
    PTConversationViewController *conversationViewController = [[PTConversationViewController alloc] initWithStyle:PTConversationViewStyleMedia]; 
    conversationViewController.title = NSLocalizedString(@"New Conversation", @"");
    conversationViewController.delegate = self;    
    conversationViewController.showContact = TRUE;    

    [[self navigationController] setToolbarHidden:YES];
    [[self navigationController] pushViewController:conversationViewController animated:YES];
    [conversationViewController release];
    
    //TTTableTextItem* item = [TTTableTextItem itemWithText:@"Lasha" URL:nil];
    /*TTMessageController* controller =
    [[[TTMessageController alloc] initWithRecipients:nil] autorelease];
    controller.dataSource = [[[MockSearchDataSource alloc] init] autorelease];
    controller.delegate = self;
    
    UINavigationController* navController = [[[UINavigationController alloc] init] autorelease];
    [navController pushViewController:controller animated:NO];
    [[self navigationController] presentModalViewController:navController animated:YES];
    */
    //[[self navigationController] setToolbarHidden:YES];
    //[[self navigationController] presentModalViewController:controller animated:YES];
    //[controller release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.buddies count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	//NSDictionary *dictionary = [self.buddies objectAtIndex:indexPath.row];
	[cell.textLabel setText:[self.buddies objectAtIndex:indexPath.row]]; //[dictionary objectForKey:@"Title"]];
    
    return cell;
}


#pragma mark -
#pragma mark Action methods

-(void) call:(id)sender
{
    NSLog(@"Call");
}


#pragma mark -
#pragma mark PTConversationViewController delegate methods

- (void)touchPlus:(PTConversationViewController *)controller tableView:(UITableView*)tableView sender:(id)sender
{
    TTPickerTextField *textField = [[controller contactViewController] textField];
    
    [textField addCellWithObject:@"Kozla doev"];
}

- (BOOL)headerButton:(UIButton *)button
{
    [button addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Call" forState:UIControlStateNormal];
    
    return TRUE;
}

- (void)conversationDidLoad:(PTConversationViewController *)controller tableView:(UITableView*)tableView
{
    NSLog(@"Conversation did load");
    [controller becomeEntryBar];
    //[controller performSelector:@selector(showLastMessage:) withObject:nil afterDelay:0.2f];
    [controller showLastMessage:NO];
}


- (void)conversationDidUnload:(PTConversationViewController *)controller tableView:(UITableView*)tableView
{
    NSLog(@"Conversation did unload");
}


- (int)messageCount:(PTConversationViewController *)controller
{
    return [messages count];
}


- (PTConversationMessage*)conversationView:(PTConversationViewController*)controller messageAt:(int)row
{
    return [messages objectAtIndex:row];
}

- (void)touchAttention:(PTConversationViewController *)controller tableView:(UITableView*)tableView message:(PTConversationMessage*)message
{
    NSLog(@"Attention clicked %@", [message text]);

   //[message setSendFailed:FALSE];
    
  /*  [messages addObject:[PTConversationMessage initWithText:@"Hello Bolooooooooooooooooooooooo" 
                                                       type:PTConversationMessageTypeOutgoing
                                                       date:[NSDate date]
                                                 sendFailed:TRUE]];*/
   //[tableView reloadData];
}

- (BOOL)chooseMedia:(PTConversationViewController *)controller tableView:(UITableView*)tableView
{
    NSLog(@"----------- chooseMedia ------------");
    return FALSE;
}

- (BOOL)messageWillSend:(PTConversationViewController *)controller tableView:(UITableView*)tableView message:(PTConversationMessage*)message
{
    return TRUE;
}

- (void)messageDidSent:(PTConversationViewController *)controller tableView:(UITableView*)tableView message:(PTConversationMessage*)message
{
    // resize image
    //if([message image] != nil) {
    //    [message setImage:[[message image] _imageScaledToSize:CGSizeMake(60.0f, 60.0f) interpolationQuality:1]];
    //}
    
    
    [messages addObject:message];
    
    [controller reloadMessages];
    [controller showLastMessage:YES];
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PTConversationViewController *dvController = [[PTConversationViewController alloc] initWithStyle:PTConversationViewStyleMedia];
    [dvController setTitle:@"Conversation"];
    dvController.delegate = self;
    [self.navigationController pushViewController:dvController animated:YES];
    [dvController release];
}

- (void)dealloc {
    [messages release];
	[CurrentTitle release];
	[buddies release];
    [super dealloc];
}

@end

