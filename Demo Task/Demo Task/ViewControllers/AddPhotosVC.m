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

@interface AddPhotosVC ()
{
    
    NSArray                       *arrFileTypes;
    NSMutableArray  *arraySelectedImagesToProcess;
    
    int                    photosAdded;
    int                    loaderCounter;
    int                    totalPhotoToAdd;
    int                    IMAGES_VIEW_MODE;

    NSTimer               *scrollingTimer;

    NSMutableDictionary   *dictFileAdded;
    NSMutableDictionary   *dictPhotoImages;
    PhotoFile *selectedImageFile;
    BOOL                   isScrollingDone;

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
    arrFileTypes = [[NSArray alloc]initWithObjects:@"*.*",@"*.JPG",@"*.BMP",@"*.JPEG",@"*.GIF",@"*.PNG",nil];
    
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
        /*
        int selCount = (int)[[_tblPhotos selectedRowIndexes] count];
        
        if (selCount)
        {
            NSInteger row = [[_tblPhotos selectedRowIndexes] lastIndex];
            NSTableCellView *cellView = [_tblPhotos viewAtColumn:0 row:row makeIfNecessary:NO];
            
            if (cellView)
            {
                if (cellView.imageView.image == [NSImage imageNamed:@"unchecked_icon.png"])
                {
                    [cellView.imageView setImage:[NSImage imageNamed:@"checked_sq_icon.png"]];
                    
                    if (![arrTableSelectedRows containsObject:@(row)])
                    {
                        [arrTableSelectedRows addObject:@(row)];
                    }
                }
                else
                {
                    [cellView.imageView setImage:[NSImage imageNamed:@"unchecked_icon.png"]];
                    
                    if ([arrTableSelectedRows containsObject:@(row)])
                    {
                        [arrTableSelectedRows removeObject:@(row)];
                    }
                }
                
                [_tblPhotos deselectRow:row];
                [self setSeletedPhotoFileWithIndex:row];
            }
        }
         */
    }
}

#pragma mark - btn actions

- (IBAction)btnAddPhotosTapped:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanCreateDirectories:YES];
    
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    [panel setPrompt:@"Add Folder"];
    
    NSMutableArray *supportedFileTypes = [[NSMutableArray alloc] initWithObjects:@"public.image", nil];
    [supportedFileTypes addObjectsFromArray:arrExternalFormats];
    [panel setAllowedFileTypes:supportedFileTypes ];//[NSArray arrayWithObject:@"public.image"]
    panel.allowsMultipleSelection = YES;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger resultForPanel){
        
        [panel close];
        
        if (resultForPanel == NSFileHandlingPanelOKButton)
        {
            if([[panel URLs] count] >0)
            {
                NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
                if([theDoc.path.lowercaseString hasPrefix:[NSString stringWithFormat:@"/users/%@/.trash/",NSUserName()]])
                {
                    [panel orderOut:self];
                    NSAlert *alert = [[NSAlert alloc]init];
                    alert.messageText = @"";
                    [alert addButtonWithTitle: @"OK"];
                    [alert layout];
                    [alert runModal];
                }
                else
                {
                    [self addPhotosFromPathUrls:[panel URLs]];
                }
            }
        }
    }];
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
            [btnList setImage:[NSImage imageNamed:@"listview_active_icon.png"]];
            [btnThumbnail setImage:[NSImage imageNamed:@"thumbview_icon.png"]];
           
            /*
            [arrTableSelectedRows removeAllObjects];
            for (NSIndexPath *indexPath in [self.customCollectionView indexPathsForSelectedItems])
            {
                int index = (int)indexPath.jnw_item;
                
                if (index < arraySelectedImagesToProcess.count)
                {
                    if (![arrTableSelectedRows containsObject:@(index)])
                    {
                        [arrTableSelectedRows addObject:@(index)];
                    }
                }
            }
             */
            
            [_tblPhotos reloadData];
            
            /*
            if (arrTableSelectedRows.count)
                [self setSeletedPhotoFileWithIndex:[[arrTableSelectedRows lastObject] intValue]];
            else
                [self setSeletedPhotoFileWithIndex:-1];
             */
            
            [self tableviewPhotosBoundDidChange:nil];
        }
        else
        {
            scrTblView.hidden = YES;
            scrCollectionVw.hidden = NO;
            line_thumbnail.hidden = NO;
            line_list.hidden = YES;
            [btnList setImage:[NSImage imageNamed:@"listview_icon.png"]];
            [btnThumbnail setImage:[NSImage imageNamed:@"thumbview_active_icon.png"]];
            
            if (!isFirstTime)
            {
                /*
                [self.customCollectionView deselectAllItems];

                for (int i = 0; i < arrTableSelectedRows.count; i++)
                {
                    int index = [[arrTableSelectedRows objectAtIndex:i] intValue];
                    NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:index inSection:0];
                       // [self.customCollectionView selectItemAtIndexPath:indexPath atScrollPosition:JNWCollectionViewScrollPositionNone animated:YES selectionType:JNWCollectionViewSelectionTypeMultiple];
                    
                    [self.customCollectionView selectItemAtIndexPath:indexPath atScrollPosition:JNWCollectionViewScrollPositionNone animated:YES];
                }
                              
                if (!arrTableSelectedRows.count)
                {
                    [self setSeletedPhotoFileWithIndex:-1];
                }
                 */
            }
            
            [self collectionViewBoundsDidChange:nil];
        }
    }
    else
    {
        scrTblView.hidden = YES;
        scrCollectionVw.hidden = YES;
    }
}

-(BOOL)isValidPhoto:(NSString *)filePath FileType:(NSString *)fileType
{
    BOOL isValidPhotoFile = NO;
    
    @autoreleasepool {
        
        NSString *lfilePath = filePath;
        if(![dictFileAdded objectForKey:lfilePath])
        {
            CFStringRef fileExtension = (__bridge CFStringRef) [lfilePath pathExtension];
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            NSString *fileExtexnson = [lfilePath pathExtension];

            {
                 if ((UTTypeConformsTo(fileUTI, kUTTypeImage) || [arrExternalFormats containsObject:fileExtexnson]))//[arrSupportedFormats containsObject:[lfilePath.pathExtension lowercaseString]]
                 {
                     if ([fileType isEqualToString:@"ALL"] ||  [lfilePath hasSuffix:fileType])
                     {
                         isValidPhotoFile = YES;
                     }
                 }
                
            }
            
            CFRelease(fileUTI);
        }
    }
    
    return isValidPhotoFile;;
}

-(int)countTotalPhotosToBeAddedFromUrls:(NSArray *)paths FileType:(NSString *)fileType
{
    @autoreleasepool {
        
        __block int counter = 0;
        
        for(NSURL *url in paths)
        {
            BOOL isDir = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir];
            if(!isDir )
            {
                if ([self isValidPhoto:url.path FileType:fileType])
                {
                    counter = counter + 1;
                    
                    if (counter > MAX_PHOTOS_TO_ADD)
                    {
                        // isPHOTOS_PROCESSING_IN_PROGERESS = NO;
                        // isMAX_PHOTOS_LIMIT_EXCEEDED = YES;
                        break;
                    }
                }
            }
            else
            {
                NSMutableArray *aarayOfImages = [[NSMutableArray alloc] init];
                
                @autoreleasepool {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSURL *bundleURL = [NSURL fileURLWithPath:[url path]];//[[NSBundle mainBundle] bundleURL];
                    NSDirectoryEnumerator *enumerator1 = [fileManager enumeratorAtURL:bundleURL
                                                           includingPropertiesForKeys:@[NSURLIsDirectoryKey]
                                                                              options:(NSDirectoryEnumerationSkipsPackageDescendants |
                                                                                       NSDirectoryEnumerationSkipsHiddenFiles)
                                                                         errorHandler:^BOOL(NSURL *url, NSError *error){
                                                                             
                                                                             if (error) {
                                                                                 NSLog(@"[Error] %@ (%@)", error, url);
                                                                                 return NO;
                                                                             }
                                                                             return YES;
                                                                         }];
                    
                    for (NSURL *fileURL in enumerator1)
                    {
                        NSString *filename;
                        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
                        NSNumber *isDirectory;
                        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
                        if(![isDirectory boolValue] )
                        {
                            if (fileURL)
                            {
                                [aarayOfImages addObject:fileURL.path];
                            }
                        }
                    }
                    
                    for (int i = 0 ;  i < aarayOfImages.count; i++)
                    {
                        NSString *strImgUrl = [aarayOfImages objectAtIndex:i];
                        
                        if ([self isValidPhoto:strImgUrl FileType:fileType])
                        {
                            if (counter > MAX_PHOTOS_TO_ADD)
                            {
                                /*
                                isPHOTOS_PROCESSING_IN_PROGERESS = NO;
                                isMAX_PHOTOS_LIMIT_EXCEEDED = YES;
                                 */
                                break;
                            }
                            counter = counter + 1;
                        }
                    }
                }
                
            }
        }
        
        return counter;
    }
}

#pragma mark - Add Photos

- (void)addPhotosFromPathUrls:(NSArray *)paths
{
   @autoreleasepool {
       
        totalPhotoToAdd = 0;
        photosAdded = 0;
       /*
        isMAX_PHOTOS_LIMIT_EXCEEDED = NO;
        isAddingPhotosInCollectionView = YES;
        isPHOTOS_PROCESSING_IN_PROGERESS = YES;
        isPhotosAlreadyAdded = NO;
        isPhotoFormatNotSupported = NO;
        alreadyExistsPhotosCount = 0;
        damagedFileCount = 0;
        */
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
            
            //self->totalPhotoToAdd =  [self countTotalPhotosToBeAddedFromUrls:paths FileType:self->selectedFileType];
            
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                
                NSLog(@"is adding photos count = %d", self->totalPhotoToAdd);
         
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        
                        for(NSURL *url in paths)
                        {
                           
                            BOOL isDir = NO;
                            [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir];
                            if(!isDir )
                            {
                                [self addToImageArray:url.path FileType:@"ALL"];
                            }
                            
                            if ([url isEqual:[paths lastObject]])
                            {
                                dispatch_sync(dispatch_get_main_queue(), ^(void){
                                    
                                    [self processAfterAllPhotosAdded];
                                    
                                });
                            }
                        }
                    });
            });
        });
    }
}

#pragma mark - Search and Add Implementation

-(void)addToImageArray:(NSString *)filePath FileType:(NSString *)fileType
{
    @autoreleasepool {
        
        NSString *lfilePath = filePath;
        if(![dictFileAdded objectForKey:lfilePath])
        {
            CFStringRef fileExtension = (__bridge CFStringRef) [lfilePath pathExtension];
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            NSString *fileExtexnson = [lfilePath pathExtension];
            
            if (([fileType isEqualToString:@"ALL"] ||  [lfilePath hasSuffix:fileType]) && (UTTypeConformsTo(fileUTI, kUTTypeImage) || [arrExternalFormats containsObject:fileExtexnson]))
            {
                PhotoFile *photoFile = [[PhotoFile alloc]initWithFileUrl:filePath];
                
                //if ( photoFile.width > 0 && photoFile.height > 0)
                {
                    [arraySelectedImagesToProcess addObject:photoFile];
                    [dictFileAdded setObject:@"1" forKey:photoFile.filePath];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^(void){
                        
                    });
                }
            }
            
            CFRelease(fileUTI);
        }
    }
}


#pragma mark - PhotoThumnailCell Delegate

-(void)btnCheckBoxTappedAtIndex:(NSIndexSet *)indexSet
{
    int index = (int)[indexSet lastIndex];
    if (index < arraySelectedImagesToProcess.count)
    {
        [self setSeletedPhotoFileWithIndex:index];
    }
}

-(void)setSeletedPhotoFileWithIndex:(NSInteger)selectedIndex
{
    if (selectedIndex<arraySelectedImagesToProcess.count && selectedIndex >= 0)
    {
        @autoreleasepool
        {
            PhotoFile *selecedPhotoObj = (PhotoFile *) [arraySelectedImagesToProcess objectAtIndex:selectedIndex];
            
            if (![selecedPhotoObj.fileURL isEqualToString:selectedImageFile.fileURL])
            {
               
                selectedImageFile = (PhotoFile *) [arraySelectedImagesToProcess objectAtIndex:selectedIndex];
                
            }
        }
    }
   
}

-(void)processAfterAllPhotosAdded
{
    [self.customCollectionView reloadData];
    [self.tblPhotos reloadData];
    [self showPhotosAfterCompletion];
}

-(void)showPhotosAfterCompletion
{
    if (arraySelectedImagesToProcess.count)
    {
       // [self changePhotosViewImageMode:grid_VIEW isFirstTime:YES];

        if( (scrTblView.hidden))
        {
            [self changePhotosViewImageMode:grid_VIEW isFirstTime:YES];
        }
        else if(scrCollectionVw.hidden)
        {
            [self changePhotosViewImageMode:list_VIEW isFirstTime:YES];
        }
        else
        {
            [self changePhotosViewImageMode:grid_VIEW isFirstTime:YES];
        }
        
        NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:0 inSection:0];
        [self.customCollectionView selectItemAtIndexPath:indexPath atScrollPosition:JNWCollectionViewScrollPositionTop animated:YES];
    }
    selectedImageFile = [arraySelectedImagesToProcess firstObject];
}

#pragma mark - JNWCollectionView delegate

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //GridCell *cell = (GridCell *)[collectionView dequeueReusableCellWithIdentifier:identifier SetIndex:(int)indexPath.jnw_item];
    
    GridCell *cell = (GridCell *)[collectionView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.jnw_item < arraySelectedImagesToProcess.count)
    {
        PhotoFile *photoFile = [arraySelectedImagesToProcess objectAtIndex:indexPath.jnw_item];
        cell.fileName = photoFile.fileName;
       // cell.fileDimension = [NSString stringWithFormat:@"Dimensions %d X %d",(int)photoFile.width,(int)photoFile.height];
       // cell.fileSize =  [NSString stringWithFormat:@"Size %@",photoFile.fileSizeAsString];
        
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
    
    if (arraySelectedImagesToProcess.count > row)
    {
        PhotoFile *selecedPhotoObj = (PhotoFile *) [arraySelectedImagesToProcess objectAtIndex:row];
        NSImage *imgSelected = [[NSImage alloc] initWithContentsOfFile:selecedPhotoObj.fileURL];
        
        if (imgSelected)
        {
            NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:row inSection:0];
            GridCell *cell = (GridCell *)[self.customCollectionView cellForItemAtIndexPath:indexPath];
            if (cell)
                [cell setSelected:YES];
            
            [self setSeletedPhotoFileWithIndex:row];
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:row inSection:0];
            GridCell *cell = (GridCell *)[self.customCollectionView cellForItemAtIndexPath:indexPath];
            if (cell)
                [cell setSelected:NO];
            
            return;
        }
    }
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
         
           // continue;
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
    if (cell.rowIndex == index && isScrollingDone)//(cell.indexPath.jnw_item == index)
    {
        NSImage *imgThumbnail;
        
        /*
        if (isOSX_14_AndAbove) {
            imgThumbnail = [[Utils sharedUtils] getThumbnailImageAtFilePathForSmallThumbnails:photoFile.fileURL WithSize:NSMakeSize(202,207)];
        }
        else
        {
            imgThumbnail = [[Utils sharedUtils] getThumbnailImageAtFilePath:photoFile.fileURL WithSize:NSMakeSize(202,207)];
        }
        */
        
        if (imgThumbnail && cell)
        {
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                
                [cell setImage:imgThumbnail];
                [self->dictPhotoImages setObject:imgThumbnail forKey:photoFile.filePath];
            });
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                cell.image = [NSImage imageNamed:@"not_av_big.png"];
            });
        }
    }
}

#pragma mark - Load Thumbnails TableView

-(void)tableviewPhotosBoundDidChange:(NSNotification *)notification
{
     [self loadTableViewThumbnailImages];
}

-(void)loadTableViewThumbnailImages
{
    //if (!isAddingPhotosInCollectionView)
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
            }
            else
            {
                /*
                if (isOSX_14_AndAbove) {
                     imgThumbnail = [[Utils sharedUtils] getThumbnailImageAtFilePathForSmallThumbnails:photoFile.fileURL WithSize:NSMakeSize(35, 24)];
                }
                else
                {
                     imgThumbnail = [[Utils sharedUtils] getThumbnailImageAtFilePath:photoFile.fileURL WithSize:NSMakeSize(35, 24)];
                }
                 */
            }
            
            if (imgThumbnail)
            {
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    [cell.imageView setImage:imgThumbnail];
                });
            }
            else
            {
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    cell.imageView.image = [NSImage imageNamed:@"not_av_small.png"];
                });
            }
        }
    }
}

#pragma mark - Window Resize

- (void)windowDidResized
{
  
}

-(void)windowEndResizing
{
   
}



#pragma mark - load images
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
        
        //NSURL *photoSourcePage = [flickrContext photoWebPageURLFromDictionary:photoDict];
        //NSDictionary *linkAttr = [NSDictionary dictionaryWithObjectsAndKeys:photoSourcePage, NSLinkAttributeName, nil];
        //NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title attributes:linkAttr];
        
        NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
        
        PhotoFile *photoObj = [[PhotoFile alloc] initWithFileUrl:photoURL.absoluteString];
        [arraySelectedImagesToProcess addObject:photoObj];
    }
    
    [self.customCollectionView reloadData];
    [self downloadImages:arPhotos];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
}



-(void)downloadImages:(NSArray *)arPhotos
{
    for (NSDictionary *photoDict in arPhotos)
    {
         NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
         AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
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
         } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
         {
             NSLog(@"File downloaded to: %@", filePath);
         }];
         [downloadTask resume];
    }
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
}

@end
