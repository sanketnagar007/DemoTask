//
//  PhotoFile.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "PhotoFile.h"
#import <AFNetworking/AFNetworking.h>

@implementation PhotoFile
@synthesize filePath,fileExtension,fileName,fileURL,thumbnailImg,image;

-(id)initWithFileUrl:(NSString *)fileUrl
{
    if (self = [super init])
    {
        self.filePath = fileUrl;
        self.fileExtension = [fileUrl pathExtension];
        self.fileName = [[fileUrl pathComponents]lastObject];
        self.fileURL = fileUrl;
        self.image = nil;
        
    }
    return self;
}




@end
