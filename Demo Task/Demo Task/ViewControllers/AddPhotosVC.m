//
//  AddPhotosVC.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "AddPhotosVC.h"
#import "PhotoFile.h"
#import "AppDelegate.h"
#import "GridCell.h"

#import <AFNetworking/AFNetworking.h>
#import "UICKeyChainStore.h"

static NSString * const identifier = @"CollectionViewCELL";

#define  arrExternalFormats  @[@"eps",@"jpc",@"p7",@"pc",@"pgm",@"pnm",@"ppm",@"ptif",@"ui",@"pct",   @"EPS",@"JPC",@"P7",@"PC",@"PGM",@"PNM",@"PPM",@"PTIF",@"UI",@"PCT"  ]//,@"svg"

@interface AddPhotosVC ()<PhotoFileDelegate>
{
    NSMutableArray  *arraySelectedImagesToProcess;
    
    int                    IMAGES_VIEW_MODE;
    NSTimer               *scrollingTimer;
    NSMutableDictionary   *dictFileAdded;
    NSMutableDictionary   *dictPhotoImages;
    PhotoFile             *selectedImageFile;
    BOOL                   isScrollingDone;
    int                    selectedIndex;
    BOOL                   isPreviewDisplayed;
}

@end

@implementation AddPhotosVC

-(void)loadView
{
    [super loadView];
    
    [self initialSetupView];
    
    JNWCollectionViewGridLayout *gridLayout = [[JNWCollectionViewGridLayout alloc] init];
    gridLayout.delegate = self;
    gridLayout.verticalSpacing = 10.f;
    
    self.customCollectionView.collectionViewLayout = gridLayout;
    self.customCollectionView.dataSource = self;
    self.customCollectionView.animatesSelection = NO; // (this is the default option)
    
    [self.customCollectionView registerClass:GridCell.class forCellWithReuseIdentifier:identifier];

    self.customCollectionView.backgroundColor = [NSColor clearColor];
    
    [[self.customCollectionView contentView] setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionViewBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[self.customCollectionView contentView]];
}

-(void)viewWillAppear
{
    dictPhotoImages = [[NSMutableDictionary alloc] init];
    dictFileAdded  = [[NSMutableDictionary alloc] init];
    
    if (!scrCollectionVw.hidden)
        [self collectionViewBoundsDidChange:nil];
    else
        [self tableviewPhotosBoundDidChange:nil];
}

#pragma mark - Notifications Handler

-(void)initialSetupView
{
    arraySelectedImagesToProcess = [[NSMutableArray alloc]init];
    
    IMAGES_VIEW_MODE = grid_VIEW;
    dictFileAdded = [[NSMutableDictionary alloc]init];
    
    [self.tblPhotos setDelegate:self];
    [self.tblPhotos setDataSource:self];
    [self.customCollectionView setScrollerStyle:NSScrollerStyleOverlay];
    [self.customCollectionView setDrawsBackground:NO];
    [self.customCollectionView setScrollerKnobStyle:NSScrollerKnobStyleLight];
    
    [[[_tblPhotos enclosingScrollView] contentView] setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableviewPhotosBoundDidChange:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[[_tblPhotos enclosingScrollView] contentView]];
    
    [_tblPhotos setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    
    [self getImagesFromFlicker];
}

#pragma mark - NSTableView Datasource & Delegate

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 30;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(tableView == _tblPhotos)
    {
        return [arraySelectedImagesToProcess count];
    }
    
    return 0;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableView == _tblPhotos)
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        
        if (cellView == nil)
        {
            cellView = [[NSTableCellView alloc] initWithFrame:NSZeroRect];
            cellView.identifier = tableColumn.identifier;
        }
        
        PhotoFile *photoFile = [arraySelectedImagesToProcess objectAtIndex:row];
        [cellView setWantsLayer:YES];
        
        if (row % 2 == 0)
        {
            [cellView.layer setBackgroundColor:[NSColor colorWithCalibratedRed:22/255.0 green:21/255.0 blue:21/255.0 alpha:0.7f].CGColor];
        }
        else
        {
            [cellView.layer setBackgroundColor:[NSColor colorWithCalibratedRed:22/255.0 green:21/255.0 blue:21/255.0 alpha:1.0f].CGColor];
        }
      
        if( [tableColumn.identifier isEqualToString:@"checkColumn"] )
        {
           /*
            if ([arrTableSelectedRows containsObject:@(row)])
                [cellView.imageView setImage:[NSImage imageNamed:@"checked_sq_icon.png"]];
            else
                [cellView.imageView setImage:[NSImage imageNamed:@"unchecked_icon.png"]];
            */
            [cellView.imageView setTag:0];
            return cellView;
        }
        
        
        if( [tableColumn.identifier isEqualToString:@"nameColumn"] )
        {
            
            if ( cellView.imageView.image == imgPlaceHolder || cellView.imageView.image == nil )
                cellView.imageView.image = imgPlaceHolder;
            
            cellView.textField.stringValue = photoFile.fileName;
            [cellView.imageView setTag:0];
            [cellView.textField setToolTip:photoFile.fileName];
            
            return cellView;
        }
        if( [tableColumn.identifier isEqualToString:@"typeColumn"] )
        {
            [cellView.textField setAlignment:NSCenterTextAlignment];
            cellView.textField.stringValue = photoFile.fileExtension;
            return cellView;
        }
        if( [tableColumn.identifier isEqualToString:@"dimensionsColumn"] )
        {
            [cellView.textField setAlignment:NSCenterTextAlignment];
          //  cellView.textField.stringValue = [NSString stringWithFormat:@"%dX%d",(int)photoFile.width,(int)photoFile.height];
            return cellView;
        }
        if( [tableColumn.identifier isEqualToString:@"fileSizeColumn"] )
        {
            [cellView.textField setAlignment:NSCenterTextAlignment];
          //  cellView.textField.stringValue = photoFile.fileSizeAsString;
            return cellView;
        }
        if( [tableColumn.identifier isEqualToString:@"fileLocationColumn"] )
        {
            cellView.textField.stringValue = photoFile.filePath;
            [cellView.textField setToolTip:photoFile.filePath];
            
            return cellView;
        }
       
        return cellView;
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSTableView *tableView = [aNotification valueForKey:@"object"];
    
    if (tableView == _tblPhotos)
    {
        int selCount = (int)[[_tblPhotos selectedRowIndexes] count];
        
        if (selCount)
        {
            NSInteger row = [[_tblPhotos selectedRowIndexes] lastIndex];
            selectedIndex = (int)row;
            [self setPreviewImageWithIndex:row];
        }
    }
}


- (IBAction)btnViewPhotosModetapped:(NSButton *)sender
{
    NSLog(@"view photos mode tapped tapped");
    int selectedIndex = (int)sender.tag;
    [self changePhotosViewImageMode:selectedIndex isFirstTime:NO];
}

-(void)changePhotosViewImageMode:(int)viewMode isFirstTime:(BOOL)isFirstTime
{
    IMAGES_VIEW_MODE = viewMode;
    
    if (arraySelectedImagesToProcess.count)
    {
        if (IMAGES_VIEW_MODE == list_VIEW)
        {
            scrTblView.hidden = NO;
            scrCollectionVw.hidden = YES;
            line_thumbnail.hidden = YES;
            line_list.hidden = NO;
            [_tblPhotos reloadData];
            [self tableviewPhotosBoundDidChange:nil];
        }
        else
        {
            scrTblView.hidden = YES;
            scrCollectionVw.hidden = NO;
            line_thumbnail.hidden = NO;
            line_list.hidden = YES;
            [self collectionViewBoundsDidChange:nil];
        }
    }
    else
    {
        scrTblView.hidden = YES;
        scrCollectionVw.hidden = YES;
    }
}

#pragma mark - JNWCollectionView delegate

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GridCell *cell = (GridCell *)[collectionView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.jnw_item < arraySelectedImagesToProcess.count)
    {
        PhotoFile *photoFile = [arraySelectedImagesToProcess objectAtIndex:indexPath.jnw_item];
        cell.fileName = photoFile.fileName;
        
        if ([dictPhotoImages valueForKey:photoFile.filePath])
            cell.image = (NSImage *)[dictPhotoImages valueForKey:photoFile.filePath];
        else
            cell.image = imgPlaceHolder;
        
        cell.rowIndex = (int)indexPath.jnw_item;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(JNWCollectionView *)collectionView {
    return 1;
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return arraySelectedImagesToProcess.count;
}

- (CGSize)sizeForItemInCollectionView:(JNWCollectionView *)collectionView {
    return CGSizeMake(220, 300);
}

- (void)collectionView:(JNWCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.jnw_item;
    selectedIndex = (int)row;
    [self setPreviewImageWithIndex:selectedIndex];
}



/// Asks the delegate if the item at the specified index path should be deselected.
- (BOOL)collectionView:(JNWCollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedIndices = [collectionView indexPathsForSelectedItems];
    if (selectedIndices.count == 1) {
        return YES;
    }
    
    return YES;
}

- (void)collectionView:(JNWCollectionView *)collectionView didRightClickItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)collectionView:(JNWCollectionView *)collectionView didRightClickItemAtIndexPath:(NSIndexPath *)indexPath Event:(NSEvent*)theEvent
{
   
}

#pragma mark -- notification

-(void)collectionViewBoundsDidChange:(NSNotification *)_notificationObj
{
    isScrollingDone = NO;
    [scrollingTimer invalidate];
    scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(scrollingEndAfterDelay) userInfo:nil repeats:NO];
}

-(void)scrollingEndAfterDelay
{
    isScrollingDone = YES;
    
    NSArray *arrOfPhotos = [[NSArray alloc] initWithArray:arraySelectedImagesToProcess];
    NSArray *visibleIndexPaths = [self.customCollectionView indexPathsForVisibleItems];
    
    for (int i = 0; i < visibleIndexPaths.count; i++)
    {
        NSIndexPath *indexPath = [visibleIndexPaths objectAtIndex:i];
        int index = (int)[indexPath jnw_item];
        
        GridCell *cell = (GridCell *)[self.customCollectionView cellForItemAtIndexPath:[NSIndexPath jnw_indexPathForItem:index inSection:0]];
       
        if (!cell) {
            [self.customCollectionView layout];
        }
        
        if (index < arrOfPhotos.count)
        {
            PhotoFile *photoFile  = (PhotoFile *)[arrOfPhotos objectAtIndex:index];//
        
            if ([dictPhotoImages valueForKey:photoFile.filePath])
            {
                cell.image = (NSImage *)[dictPhotoImages valueForKey:photoFile.filePath];
            }
            else
            {
                [ComapreSharedOperationQueue() addOperationWithBlock:^(void)
                 {
                     @autoreleasepool
                     {
                         [self performImageOperationForCell:photoFile forCell:cell andIndex:index];
                     }
                 }];
            }
        }
    }
}

#pragma mark - Load Thumbnails CollectionView

NSOperationQueue *ComapreSharedOperationQueue() {
    
    static NSOperationQueue *_ITEImageSharedOperationQueue = nil;
    if (_ITEImageSharedOperationQueue == nil) {
        _ITEImageSharedOperationQueue = [[NSOperationQueue alloc] init];
        [_ITEImageSharedOperationQueue setMaxConcurrentOperationCount:1];//NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    return _ITEImageSharedOperationQueue;
}

-(void)performImageOperationForCell:(PhotoFile *)photoFile forCell:(GridCell *)cell andIndex:(int)index
{
    if (cell.rowIndex == index && isScrollingDone)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *photoURL = [NSURL URLWithString:photoFile.fileURL];
        NSURL *URL = [NSURL URLWithString:photoURL.absoluteString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSArray * paths = NSSearchPathForDirectoriesInDomains (NSPicturesDirectory, NSUserDomainMask, YES);
            NSString * documentsDirectoryURL = [paths objectAtIndex:0];
            documentsDirectoryURL = [NSString stringWithFormat:@"%@/%@",documentsDirectoryURL,@"DemoTaskImages"];
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryURL])
            {
                if([[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil])
                {
                    NSLog(@"directory created successfully %@",documentsDirectoryURL);
                }
            }
            
            NSURL *fileUrl = [NSURL fileURLWithPath:documentsDirectoryURL];
            
            return [fileUrl URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
            
            NSLog(@"File downloaded to: %@", [filePath.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]);
            
            NSImage *imgThumbnail = [[NSImage alloc]initWithContentsOfFile:[filePath.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]];

            [cell setImage:imgThumbnail];
            [self->dictPhotoImages setObject:imgThumbnail forKey:photoFile.filePath];
            
        }];
        [downloadTask resume];
    }
}

#pragma mark - Load Thumbnails TableView

-(void)tableviewPhotosBoundDidChange:(NSNotification *)notification
{
     [self loadTableViewThumbnailImages];
}

-(void)loadTableViewThumbnailImages
{
    CGRect tableViewVisibleRect = [self.tblPhotos visibleRect];
    NSArray *arrOfPhotos = [[NSArray alloc] initWithArray:arraySelectedImagesToProcess];
    NSRange range = [self.tblPhotos rowsInRect:tableViewVisibleRect];
    
    for (int i = 0; i < arrOfPhotos.count; i++)
    {
        if (!NSLocationInRange(i, range))
        {
            continue;
        }
        
        NSTableCellView *cell = [_tblPhotos viewAtColumn:1 row:i makeIfNecessary:YES];
        
        if(!cell.imageView)
            continue;
        {
            if (i < arrOfPhotos.count)
            {
                PhotoFile *photoFile  = (PhotoFile *)[arrOfPhotos objectAtIndex:i];//
                cell.imageView.image = imgPlaceHolder;
                
                if (cell.imageView.image == imgPlaceHolder)
                {
                    if (![photoFile thumbnailImg] &&  scrCollectionVw.hidden)
                    {
                        [ComapreSharedOperationQueuePhotos() addOperationWithBlock:^(void)
                         {
                             @autoreleasepool
                             {
                                 [self performImageOperationForPhotosCell:photoFile forCell:cell andIndex:i];
                             }
                         }];
                    }
                }
            }
        }
    }
}

NSOperationQueue *ComapreSharedOperationQueuePhotos() {
    
    static NSOperationQueue *_ITEImageSharedOperationQueue = nil;
    if (_ITEImageSharedOperationQueue == nil) {
        _ITEImageSharedOperationQueue = [[NSOperationQueue alloc] init];
        [_ITEImageSharedOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    return _ITEImageSharedOperationQueue;
}

-(void)performImageOperationForPhotosCell:(PhotoFile *)photoFile forCell:(NSTableCellView *)cell andIndex:(int)index
{
    if (cell)
    {
        @autoreleasepool {
            
            NSImage *imgThumbnail = nil;
            
            if ([dictPhotoImages valueForKey:photoFile.filePath])
            {
                imgThumbnail = (NSImage *)[dictPhotoImages valueForKey:photoFile.filePath];
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    cell.imageView.image = imgThumbnail;
                });
            }
            else
            {                
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                
                NSURL *photoURL = [NSURL URLWithString:photoFile.fileURL];
                NSURL *URL = [NSURL URLWithString:photoURL.absoluteString];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSPicturesDirectory, NSUserDomainMask, YES);
                    NSString * documentsDirectoryURL = [paths objectAtIndex:0];
                    documentsDirectoryURL = [NSString stringWithFormat:@"%@/%@",documentsDirectoryURL,@"DemoTaskImages"];
                    
                    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryURL])
                    {
                        if([[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil])
                        {
                            NSLog(@"directory created successfully %@",documentsDirectoryURL);
                        }
                    }
                    
                    NSURL *fileUrl = [NSURL fileURLWithPath:documentsDirectoryURL];
                    
                    return [fileUrl URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                    
                    NSLog(@"File downloaded to: %@", [filePath.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]);
                    
                    NSImage *imgThumbnail = [[NSImage alloc]initWithContentsOfFile:[filePath.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
                    
                    cell.imageView.image = imgThumbnail;
                    [self->dictPhotoImages setObject:imgThumbnail forKey:photoFile.filePath];
                    
                }];
                [downloadTask resume];
            }
        }
    }
}


#pragma mark - flicker api calls
-(void)getImagesFromFlicker
{
    [self initFlickerApi];
}

-(void)initFlickerApi
{
    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:FLICKR_SAMPLE_API_KEY sharedSecret:FLICKR_SAMPLE_API_SHARED_SECRET];
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    [flickrRequest setDelegate:self];
    if (![flickrRequest isRunning]) {
        [flickrRequest callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"100", @"per_page", nil]];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSArray *arPhotos = [inResponseDictionary valueForKeyPath:@"photos.photo"];
    
    for (NSDictionary *photoDict in arPhotos)
    {
        NSString *title = [photoDict objectForKey:@"title"];
        if (![title length]) {
            title = @"No title";
        }
        
        NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
        
        PhotoFile *photoObj = [[PhotoFile alloc] initWithFileUrl:photoURL.absoluteString];
        photoObj.delegate = self;
        [arraySelectedImagesToProcess addObject:photoObj];
    }
    
    [self.customCollectionView reloadData];
    [self collectionViewBoundsDidChange:nil];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
}

-(void)fileDownloadedAndSavedAtPath:(NSURL *)filePath photoObj:(PhotoFile *)photoObj{
    
    if ([arraySelectedImagesToProcess containsObject:photoObj]) {
        int indexOfPhotofile = (int)[arraySelectedImagesToProcess indexOfObject:photoObj];
        
        GridCell *cell = (GridCell *)[self.customCollectionView cellForItemAtIndexPath:[NSIndexPath jnw_indexPathForItem:indexOfPhotofile inSection:0]];
        
        cell.image = [NSImage imageNamed:@"thumbview_icon.png"];
        [self->dictPhotoImages setObject:cell.image forKey:photoObj.filePath];
    }
}





#pragma mark - mousedownview delegate

-(void)swipeWithDirection:(int)direction
{
    if (direction == RIGHT_SWIPE) {
        selectedIndex--;
    }else{
        selectedIndex++;
    }
    
    [self setPreviewImageWithIndex:selectedIndex];
}

#pragma mark - preview ui actions

- (IBAction)btnPrevPhotoTapped:(id)sender {
   
    selectedIndex--;
    [self setPreviewImageWithIndex:selectedIndex];
}

- (IBAction)btnNextPhotoTapped:(id)sender {
    
    selectedIndex++;
    [self setPreviewImageWithIndex:selectedIndex];
}

- (IBAction)btnClosePreviewTapped:(id)sender {
     isPreviewDisplayed = NO;
    [vwPreview removeFromSuperview];
}



-(void)setPreviewImageWithIndex:(int)index
{
    if (!isPreviewDisplayed) {
        isPreviewDisplayed = YES;
        CGRect frame = self.view.frame;
        [vwPreview setFrame:frame];
        [vwPreview setDelegate:self];
        [self.view addSubview:vwPreview];
    }
    
    if (arraySelectedImagesToProcess.count > index && index >= 0)
    {
        PhotoFile *photoFile = (PhotoFile *) [arraySelectedImagesToProcess objectAtIndex:index];
        if ([dictPhotoImages valueForKey:photoFile.filePath])
        {
            NSImage *imgThumbnail = (NSImage *)[dictPhotoImages valueForKey:photoFile.filePath];
            [imgVwPreview setImage:imgThumbnail];
        }
        else{
            [imgVwPreview setImage:imgPlaceHolder];
        }
    }
}

#pragma mark - keychain methods

- (IBAction)btnLoginTapped:(id)sender {
    CGRect frame = self.view.frame;
    [vwLogin setFrame:frame];
    [self.view addSubview:vwLogin];
}

- (IBAction)btnSaveDetailsInKCTapped:(id)sender {
    NSString *uname = txtUserName.stringValue;
    NSString *pass = txtPassword.stringValue;
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
    [self saveUsername:uname withPassword:pass forServer:@"DemoTask"];
    
    [self getCredentialsForServer:@"DemoTask"];
}

- (IBAction)btnCloseLoginTapped:(id)sender {
    [vwLogin removeFromSuperview];
}


-(void) saveUsername:(NSString*)user withPassword:(NSString*)pass forServer:(NSString*)server {
    
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    keychainStore[@"user"] = user;
    keychainStore[@"pass"] = pass;
}


-(void) getCredentialsForServer:(NSString*)server {
    
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    NSString *user =  keychainStore[@"user"];
    NSString *pass =  keychainStore[@"pass"];
    NSLog(@"User Name :>>%@ and password %@",user,pass);
    
    [lblSavedMsg setStringValue:[NSString stringWithFormat:@"User Name :>>%@ and password %@ saved in keychain",user,pass]];
}
@end
