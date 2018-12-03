//
//  GridCell.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self == nil) return nil;
    self.wantsLayer = YES;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
       
    return self;
}
- (void)setImage:(NSImage *)image {
	_image = image;
	self.backgroundImage = image;
}


-(void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
    self.nameValue = fileName;
}

-(void)setFileDimension:(NSString *)fileDimension
{
    _fileDimension = fileDimension;
    self.dimensionValue = fileDimension;

}


-(void)setFileSize:(NSString *)fileSize
{
    _fileSize = fileSize;
    self.sizeValue = fileSize;
}


-(void)setRowIndex:(int)rowIndex
{
    _rowIndex= rowIndex;
}



- (void)setSelected:(BOOL)selected {
	
    if (selected) {
        self.checkImage = [NSImage imageNamed:@"checked_icon_2.png"];
        self.bgselectedColor = [NSColor colorWithCalibratedRed:27/255.0 green:172/255.0 blue:143/255.0 alpha:0.53f];
    }
    else{
        self.checkImage = nil;
        self.bgselectedColor = [NSColor clearColor];
    }
     //[super setSelected:selected];
	//[self updateBackgroundImage];
}




-(void)setIsForSmallThumbnail:(BOOL)isForSmallThumbnail
{
    [super setIsForSmallThubnails:isForSmallThumbnail];
}



@end
