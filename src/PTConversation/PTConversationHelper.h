//
//  PTConversationHelper.h
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/22/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PTConversationMessage.h"

@interface PTConversationHelper : NSObject {

}


+ (void) dumpRect:(CGRect)rect;
+ (void) dumpRect:(CGRect)rect title:(NSString*)title;
+ (void) dumpRange:(NSRange)range;
+ (NSString*) pathForBundleResource:(NSString *)relativePath;
+ (NSString*)toConversationDateString:(NSDate *)date;
+ (PTConversationMessage*)mediaInfoToMessage:(UIImagePickerController *)picker info:(NSDictionary *)info text:(NSString*)text type:(PTConversationMessageType)type;
+ (UIImage*)toThumbnail:(UIImagePickerController *)picker;
+ (NSString*)getLatestFileFromPath:(NSString*)path extention:(NSString*)extention;
+ (BOOL)checkPhoneNumber:(NSString*)phoneNumber;

@end
