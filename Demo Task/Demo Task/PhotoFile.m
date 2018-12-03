//
//  PhotoFile.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "PhotoFile.h"

@implementation PhotoFile
@synthesize filePath,fileExtension,fileName,fileURL,thumbnailImg;

-(id)initWithFileUrl:(NSString *)fileUrl
{
    if (self = [super init])
    {
        self.filePath = fileUrl;
        self.fileExtension = [fileUrl pathExtension];
        self.fileName = [[fileUrl pathComponents]lastObject];
        self.fileURL = fileUrl;
    }
    return self;
}

@end
