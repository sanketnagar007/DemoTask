//
//  AddPhotosVC.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMGButton.h"
#import "Constants.h"
#import "JNWCollectionView.h"
#import "MouseDownView.h"
#import <objectiveflickr/ObjectiveFlickr.h>

@interface AddPhotosVC : NSViewController<NSTableViewDataSource,NSTableViewDelegate,JNWCollectionViewDataSource, JNWCollectionViewGridLayoutDelegate,OFFlickrAPIRequestDelegate>
{
  
    IBOutlet NSBox                *leftBox;                      
    IBOutlet NSView               *scrCollectionVw;
    IBOutlet MouseDownView        *scrTblView;
   
    IBOutlet NSTextField          *line_thumbnail;
    IBOutlet NSTextField          *line_list;
    IBOutlet IMGButton            *btnThumbnail;
    IBOutlet IMGButton            *btnList;
    IBOutlet NSTextField          *middleBG;
    
    OFFlickrAPIContext *flickrContext;
    OFFlickrAPIRequest *flickrRequest;
}

@property (nonatomic,retain) IBOutlet NSTableView       *tblPhotos;
@property (nonatomic, weak) IBOutlet JNWCollectionView  *customCollectionView;

@end
