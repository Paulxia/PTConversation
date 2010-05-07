//
//  PTConversationHelper.m
//  PTConversationView
//
//  Created by Lasha Dolidze on 4/22/10.
//  Copyright 2010 Picktek LLC. All rights reserved.
//

#import "PTConversationHelper.h"

// Warning about _imageScaledToSize should be go away 
@interface UIImage (Private)
- (UIImage*) _imageScaledToSize:(CGSize)size interpolationQuality:(int)interpolationQuality;
@end

@implementation PTConversationHelper


+ (void) dumpRect:(CGRect)rect
{
    NSLog(@"-------DUMP RECT--------");
    NSLog(@"X: %f", rect.origin.x);
    NSLog(@"Y: %f", rect.origin.y);
    NSLog(@"WIDTH: %f", rect.size.width);
    NSLog(@"HEIGHT: %f", rect.size.height);
    NSLog(@"------------------------");
}

+ (void) dumpRect:(CGRect)rect title:(NSString*)title
{
    NSLog(@"-------DUMP RECT %@--------", title);
    NSLog(@"X: %f", rect.origin.x);
    NSLog(@"Y: %f", rect.origin.y);
    NSLog(@"WIDTH: %f", rect.size.width);
    NSLog(@"HEIGHT: %f", rect.size.height);
    NSLog(@"------------------------");
}

+ (void) dumpRange:(NSRange)range
{
    NSLog(@"-------DUMP RANGE--------");
    NSLog(@"location: %d", range.location);
    NSLog(@"length: %d", range.length);
    NSLog(@"------------------------");
}


+ (NSString*) pathForBundleResource:(NSString *)relativePath
{
   // NSString* TTPathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
    
}

+ (NSString*)toConversationDateString:(NSDate *)date
{
    // Mar 9, 2010 1:22 PM
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *theString = [formatter stringFromDate:date];
    return theString;
}

// Populates PTConversationMessage object from media picker info dictionary (see UIImagePickerController)
// This method is called from didFinishPickingMediaWithInfo 
//
+ (PTConversationMessage*)mediaInfoToMessage:(NSDictionary *)info text:(NSString*)text type:(PTConversationMessageType)type
{
    UIImage *thumbnailImage;
    PTConversationMessage *message = [[PTConversationMessage alloc] init];
    
    [message setDate:[NSDate date]];
    [message setText:text];
    [message setType:type];
    [message setSendFailed:FALSE];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // For image 
    if ([mediaType isEqualToString:@"public.image"]){
        
        NSLog(@"Found an image");
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if(image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        // Set image media type
        [message setMediaType:PTConversationMessageMediaTypeImage];
        
        // Set original image
        [message setImage:image];
        
        NSLog(@"--------------------- Image size %f", image.size.width);
        
        // Set thumbnail image
        thumbnailImage = [[UIImage alloc] initWithData:UIImagePNGRepresentation(image)];
        thumbnailImage = [thumbnailImage _imageScaledToSize:CGSizeMake(60.0f, 60.0f) interpolationQuality:1];
        [message setThumbnailImage:thumbnailImage];
        //[thumbnailImage release];
        NSLog(@"--------------------- thumbnailImage size %f", thumbnailImage.size.width);
        
        
    } // For movie 
    else if ([mediaType isEqualToString:@"public.movie"])  {
    
        NSLog(@"Found an video");

        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // Set video media type
        [message setMediaType:PTConversationMessageMediaTypeVideo];
        
        // Set video URL
        [message setVideo:videoURL];
        
        NSString *thumbnailPath = [[videoURL path] stringByDeletingLastPathComponent];
        
        // Check if video just captured
        if([[thumbnailPath lastPathComponent] isEqualToString:@"capture"]) {
            thumbnailPath = [thumbnailPath stringByDeletingLastPathComponent];
        }
        
        NSString *jpgFilePath = [PTConversationHelper getLatestFileFromPath:thumbnailPath extention:@"jpg"];
        
        // Set thumbnail image
        thumbnailImage = [[UIImage imageWithContentsOfFile:jpgFilePath] _imageScaledToSize:CGSizeMake(60.0f, 60.0f) interpolationQuality:1];
        [message setThumbnailImage:thumbnailImage];
        //[thumbnailImage release];

    }
    
    
    return message;
}

// Get latest file from given path
// 
+ (NSString*)getLatestFileFromPath:(NSString*)path extention:(NSString*)extention
{
    NSString *file,*latestFile;
    NSDate *latestDate = [NSDate distantPast];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while (file = [dirEnum nextObject]) {
        
        // Only check files with given extension.
        if ([[file pathExtension] isEqualToString:extention]) {
            // Check if current jpg file is the latest one.
            if ([(NSDate *)[[dirEnum fileAttributes] valueForKey:@"NSFileModificationDate"] compare:latestDate] == NSOrderedDescending){
                latestDate = [[dirEnum fileAttributes] valueForKey:@"NSFileModificationDate"];
                latestFile = file;
            }
        }
    }
    
    latestFile = [path stringByAppendingPathComponent:latestFile];
    //NSLog(@"****** The latest file should be this one: %@", latestFile);
    
    return latestFile;
}

@end
