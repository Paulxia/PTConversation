//
//  PTConversationViewCell.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTConversationViewCell.h"


@implementation PTConversationViewCell

@synthesize ballonView,label,labelTimeStamp,attentionButton,thumbnailImageView,conversationMessage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        // we get content view to place our ballon etc.
		UIView *myContentView = self.contentView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
  
        // Create ballon view
        self.ballonView = [[UIImageView alloc] init];
        
        // Create text lable
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = UILineBreakModeWordWrap;
        self.label.font = [UIFont systemFontOfSize:14.0];
        
        // Create time stamp label
        self.labelTimeStamp = [[UILabel alloc] init];
        self.labelTimeStamp.backgroundColor = [UIColor clearColor];
        self.labelTimeStamp.textColor = [UIColor grayColor];
        self.labelTimeStamp.numberOfLines = 1;
        self.labelTimeStamp.lineBreakMode = UILineBreakModeWordWrap;
        self.labelTimeStamp.font = [UIFont boldSystemFontOfSize:12.0];
        
        // Create atention button
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"PTConversationView.bundle/images/button_attention.png"] 
                                  forState:UIControlStateNormal];
        self.attentionButton.adjustsImageWhenHighlighted = NO;
        
        // Create image view
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailWidth, kThumbnailHeight)];
        
        // Create message view (this is only container view for our controls)
        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        message.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        // Put all together
        [message addSubview:self.attentionButton];
        [message addSubview:self.ballonView];
        [message addSubview:self.thumbnailImageView];
        [message addSubview:self.label];
        [message addSubview:self.labelTimeStamp];
        
        // Add messge view in cell content view
        [myContentView addSubview:message];
        
        [self.ballonView release];
        [self.label release];
        [self.thumbnailImageView release];
        [self.labelTimeStamp release];
        [message release];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



/*
 this function will layout the subviews for the cell
 if the cell is not in editing mode we want to position them
 */
- (void)layoutSubviews {
    
    [super layoutSubviews];

	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
	CGFloat leftImageMargin = 0;
    CGFloat leftTextMargin = 0;
    
    NSString *text = conversationMessage.text;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] 
                   constrainedToSize:CGSizeMake(210.0f, 480.0f) 
                       lineBreakMode:UILineBreakModeCharacterWrap];
    
    NSString *textTime = [PTConversationHelper toConversationDateString:conversationMessage.date]; // e.g "Mar 9, 2010 1:22 PM";
    CGSize sizeTime = [textTime sizeWithFont:[UIFont systemFontOfSize:14.0] 
                           constrainedToSize:CGSizeMake(210.0f, 480.0f) 
                               lineBreakMode:UILineBreakModeCharacterWrap];

    if([conversationMessage thumbnailImage] != nil) {
        if(size.height < conversationMessage.thumbnailImage.size.height) {
            size.height = conversationMessage.thumbnailImage.size.height;
        }     
        size.width += conversationMessage.thumbnailImage.size.width;
        leftImageMargin = conversationMessage.thumbnailImage.size.width + 13.0f;
        
        leftTextMargin = conversationMessage.thumbnailImage.size.width + 10.0f;
    }
    
    UIImage *ballon;
    
    if (!self.editing) {
		    
        
        if(conversationMessage.type == PTConversationMessageTypeOutgoing) {
            
            ballon = [[UIImage imageNamed:@"PTConversationView.bundle/images/bubble_green.png"] 
                      stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0];
            
            self.attentionButton.frame = CGRectMake(contentRect.size.width - (size.width + 60.0f), 16.0f, 35.0f, 35.0f);
            self.attentionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;        

            self.ballonView.frame = CGRectMake(contentRect.size.width - (size.width + 28.0f), 18.0f, size.width + 28.0f, size.height + 20.0f);
            self.ballonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            self.label.frame = CGRectMake((contentRect.size.width - 13.0f) - (size.width + 5.0f), 8.0f, size.width + 5.0f - leftTextMargin, size.height + 35.0f);
            self.label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            self.thumbnailImageView.frame = CGRectMake((contentRect.size.width - 12.0f) - (kThumbnailWidth + 5.0f), 26.0f, kThumbnailWidth, kThumbnailHeight);
            self.thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

            self.labelTimeStamp.frame = CGRectMake((contentRect.size.width - sizeTime.width) / 2, 0.0f, sizeTime.width + 5.0f, sizeTime.height);
            self.labelTimeStamp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
            
        }
        else {
            
            ballon = [[UIImage imageNamed:@"PTConversationView.bundle/images/bubble_grey.png"] 
                      stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0];;

            self.attentionButton.frame = CGRectMake(size.width + 26.0f, 16.0f, 35.0f, 35.0f);
            self.attentionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;        

            self.ballonView.frame = CGRectMake(0.0, 18.0f, size.width + 28.0f, size.height + 20.0f);
            self.ballonView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            
            self.label.frame = CGRectMake(leftImageMargin + 16.0f, 8.0f, size.width + 5.0f, size.height + 35.0f);
            self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            
            self.thumbnailImageView.frame = CGRectMake(16.0f, 26.0f, kThumbnailWidth, kThumbnailHeight);
            self.thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            self.labelTimeStamp.frame = CGRectMake((contentRect.size.width - sizeTime.width) / 2, 0.0f, sizeTime.width + 5.0f, sizeTime.height);
            self.labelTimeStamp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
        }
        
	}
    
    if(conversationMessage.sendFailed) {
        [self.attentionButton setHidden:NO];
    } else {
        [self.attentionButton setHidden:YES];
    }
    
    self.ballonView.image = ballon;
    self.label.text = text;
    self.thumbnailImageView.image = [conversationMessage thumbnailImage];
    self.labelTimeStamp.text = textTime;
    
}


- (void)dealloc {
    [ballonView release];
    [label release];
    [labelTimeStamp release];
    [attentionButton release];
    [thumbnailImageView release];
    [conversationMessage release];
    [super dealloc];
}


@end
