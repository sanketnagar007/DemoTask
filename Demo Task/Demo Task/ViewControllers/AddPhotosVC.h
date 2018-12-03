//
//  AddPhotosVC.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
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
    IBOutlet NSButton            *btnThumbnail;
    IBOutlet NSButton            *btnList;
    IBOutlet NSTextField          *middleBG;
    
    OFFlickrAPIContext *flickrContext;
    OFFlickrAPIRequest *flickrRequest;
    IBOutlet MouseDownView *vwPreview;
    __weak IBOutlet NSImageView *imgVwPreview;
    
    
    __weak IBOutlet NSTextField *txtUserName;
    __weak IBOutlet NSTextField *txtPassword;
    
    IBOutlet NSView *vwLogin;
    __weak IBOutlet NSTextField *lblSavedMsg;
    
}

@property (nonatomic,retain) IBOutlet NSTableView       *tblPhotos;
@property (nonatomic, weak) IBOutlet JNWCollectionView  *customCollectionView;
- (IBAction)btnPrevPhotoTapped:(id)sender;
- (IBAction)btnNextPhotoTapped:(id)sender;
- (IBAction)btnClosePreviewTapped:(id)sender;
- (IBAction)btnSaveDetailsInKCTapped:(id)sender;
- (IBAction)btnCloseLoginTapped:(id)sender;

@end
