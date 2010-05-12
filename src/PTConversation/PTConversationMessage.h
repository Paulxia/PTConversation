//
//  PTConversationMessage.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/22/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef enum {
    PTConversationMessageTypeIncoming = 0,
    PTConversationMessageTypeOutgoing = 1,
} PTConversationMessageType;

typedef enum {
    PTConversationMessageMediaTypeImage = 0,
    PTConversationMessageMediaTypeVideo = 1,
} PTConversationMessageMediaType;


@interface PTConversationMessage : NSObject {
    NSString                        *text;
    UIImage                         *image;
    NSURL                           *video;
    UIImage                         *thumbnailImage;
    NSDate                          *date;
    PTConversationMessageMediaType  mediaType;
    BOOL                            sendFailed;
    PTConversationMessageType       type;    
    int                             tag;
}

@property (nonatomic,copy) NSString *text;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,assign) PTConversationMessageType type;
@property (nonatomic,assign) PTConversationMessageMediaType  mediaType;
@property (nonatomic,retain) NSURL    *video;
@property (nonatomic,retain) UIImage  *thumbnailImage;
@property (nonatomic,retain) NSDate *date;
@property (nonatomic,assign) BOOL sendFailed;
@property (nonatomic,assign) int  tag;


+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type;
+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type thumbnailImage:(UIImage*)thumbnailImage;
+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date thumbnailImage:(UIImage*)thumbnailImage;
+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date sendFailed:(BOOL)sendFailed thumbnailImage:(UIImage*)thumbnailImage;
+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date sendFailed:(BOOL)sendFailed;
+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date;
- (BOOL) isImage;
- (BOOL) isVideo;
- (NSInteger) videoSize;
@end
