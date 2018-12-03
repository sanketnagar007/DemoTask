//
//  PhotoFile.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface PhotoFile : NSObject

@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *fileExtension;
@property (nonatomic,retain) NSImage *thumbnailImg;
@property (nonatomic,retain) NSString *fileURL;

-(id)initWithFileUrl:(NSString *)fileUrl;

@end
