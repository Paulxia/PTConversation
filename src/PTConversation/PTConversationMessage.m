//
//  PTConversationMessage.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/22/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTConversationMessage.h"


@implementation PTConversationMessage

@synthesize text,image,video,thumbnailImage,type,mediaType,date,sendFailed,tag;


+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type
{
    return [PTConversationMessage initWithText:text type:type date:[NSDate date] sendFailed:FALSE thumbnailImage:nil];
}

+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type thumbnailImage:(UIImage*)thumbnailImage
{
    return [PTConversationMessage initWithText:text type:type date:[NSDate date] sendFailed:FALSE thumbnailImage:thumbnailImage];
}

+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date thumbnailImage:(UIImage*)thumbnailImage
{
    return [PTConversationMessage initWithText:text type:type date:[NSDate date] sendFailed:FALSE thumbnailImage:nil];
}

+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date sendFailed:(BOOL)sendFailed
{
    return [PTConversationMessage initWithText:text type:type date:[NSDate date] sendFailed:sendFailed thumbnailImage:nil];    
}

+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date
{
    return [PTConversationMessage initWithText:text type:type date:[NSDate date] sendFailed:FALSE thumbnailImage:nil];    
}

+ (PTConversationMessage*)initWithText:(NSString*)text type:(PTConversationMessageType)type date:(NSDate*)date sendFailed:(BOOL)sendFailed thumbnailImage:(UIImage*)thumbnailImage;
{
    PTConversationMessage *instance = [[PTConversationMessage alloc] init];
    
    [instance setText:text];
    [instance setThumbnailImage:thumbnailImage];
    [instance setType:type];
    [instance setDate:date];
    [instance setSendFailed:sendFailed];
    
    return instance;    
}

- (BOOL) isImage {
    return self.mediaType == PTConversationMessageMediaTypeImage;
}

- (BOOL) isVideo {
    return self.mediaType == PTConversationMessageMediaTypeVideo;
}

- (NSInteger) videoSize
{
    NSInteger videoFileSize = -1;
    BOOL isDirectory;
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:[video path] isDirectory:&isDirectory]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:[video path] error:nil];
        
        NSNumber *theFileSize;
        if (theFileSize = [attributes objectForKey:NSFileSize]) {
            videoFileSize = [theFileSize intValue];
        }
        
        videoFileSize = [theFileSize longValue];
        
        NSLog(@"Video File Size %d", videoFileSize);
        
    }
    
    [filemanager release];
    
    return videoFileSize;
}

- (id)init
{
    if (self = [super init]) {
        self.sendFailed = FALSE;
        //NSLog(@"PTConversationMessage - Alloc");
    }
    return self;
}

- (void)dealloc {
    //NSLog(@"PTConversationMessage - Dealloc");
    [thumbnailImage release];
    [image release];
    [video release];
    [date release];
    [super dealloc];
}

@end
