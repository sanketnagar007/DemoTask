//
//  GridCell.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "JNWCollectionView.h"

@interface GridCell : JNWCollectionViewCell

@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileDimension;
@property (nonatomic, strong) NSString *fileSize;


@property (nonatomic, assign) int rowIndex;
@property (nonatomic, assign) BOOL isForSmallThumbnail;


//@property (nonatomic, strong) NSButton *btnInfo;


/*
@property (weak) IBOutlet NSImageView *imgPhoto;
@property (strong) IBOutlet NSTextField *bgSelectedState;
@property (nonatomic,retain) IBOutlet NSView *vwSelectedState;


@property (weak) IBOutlet NSTextField *lblFileDimension;
@property (weak) IBOutlet NSTextField *lblFileSize;*/

@end
