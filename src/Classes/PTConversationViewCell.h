//
//  PTConversationViewCell.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/21/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTConversationMessage.h"
#import "PTConversationHelper.h"

#define kThumbnailWidth     60.0f
#define kThumbnailHeight    60.0f


@interface PTConversationViewCell : UITableViewCell {

    UIImageView *ballonView;
    UILabel     *label;
    UILabel     *labelTimeStamp;
    UIButton    *attentionButton;
    UIImageView *thumbnailImageView;
    
    PTConversationMessage *conversationMessage;
}

@property (nonatomic,retain) UIImageView *ballonView;
@property (nonatomic,retain) UILabel     *label;
@property (nonatomic,retain) UILabel     *labelTimeStamp;
@property (nonatomic,retain) UIButton    *attentionButton;
@property (nonatomic,retain) UIImageView *thumbnailImageView;

@property (nonatomic,retain) PTConversationMessage *conversationMessage;

@end
