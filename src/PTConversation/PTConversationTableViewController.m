//
//  PTConversationTableViewController.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTConversationTableViewController.h"



@implementation PTConversationTableViewController

@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.delegate messageCount:self];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    PTConversationViewCell *cell = (PTConversationViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PTConversationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [cell.attentionButton addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    PTConversationMessage *message = [self.delegate messageAt:self row:indexPath.row];    
    cell.conversationMessage = message;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    PTConversationMessage *message = [self.delegate messageAt:self row:indexPath.row];
     
    NSString *text = message.text;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] 
                   constrainedToSize:CGSizeMake(240.0f, 480.0f) 
                       lineBreakMode:UILineBreakModeWordWrap];
 
    // Calculate cell height
    CGFloat calculatedHeight = size.height;

    if([message thumbnailImage] != nil) {
        if(size.height < message.thumbnailImage.size.height) {
            calculatedHeight = message.thumbnailImage.size.height;
        }
    }
    
    return calculatedHeight + 35.0f;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.entryBarViewController.textView resignFirstResponder]; 
}

#pragma mark -
#pragma mark Action methods

- (void)clickAttention:(id)sender
{
    PTConversationViewCell *cell = (PTConversationViewCell*)[[[sender superview] superview] superview];
    PTConversationMessage *message = [cell conversationMessage];

    [self.delegate touchAttention:self message:message];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    
}


- (void)dealloc {
    [super dealloc];
}


@end

