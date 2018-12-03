//
//  PhotoFile.h
//  Demo Task
//
//  Created by Sanket Nagar on 04/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@class PhotoFile;

@protocol PhotoFileDelegate <NSObject>
-(void)fileDownloadedAndSavedAtPath:(NSURL *)filePath photoObj:(PhotoFile *)photoObj;
@end

@interface PhotoFile : NSObject
@property (readwrite, weak) id <PhotoFileDelegate> delegate;
@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *fileExtension;
@property (nonatomic,retain) NSImage *thumbnailImg;
@property (nonatomic,retain) NSString *fileURL;
@property (nonatomic,retain) NSImage *image;

-(id)initWithFileUrl:(NSString *)fileUrl;
-(void)downloadImage;
@end
