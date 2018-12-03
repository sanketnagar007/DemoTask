/*
 Copyright (c) 2013, Jonathan Willing. All rights reserved.
 Licensed under the MIT license <http://opensource.org/licenses/MIT>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions
 of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "JNWCollectionViewCell.h"
#import "JNWCollectionViewCell+Private.h"
#import "JNWCollectionView+Private.h"
#import <QuartzCore/QuartzCore.h>
//#import "Globals.h"

@interface JNWCollectionViewCellBackgroundView : NSView
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, weak) JNWCollectionView *collectionView;
@end

@implementation JNWCollectionViewCellBackgroundView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self == nil) return nil;
	self.wantsLayer = YES;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    
    
    //if (isOSX_13_AndAbove)
    {
        if (!self.imageView) {
            self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
            
            [self.imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
            [self addSubview:_imageView];
        }
    }
  
    
	return self;
}

- (void)setImage:(NSImage *)image {
	_image = image;
	[self setNeedsDisplay:YES];
}

- (void)setColor:(NSColor *)color {
	_color = color;
	[self setNeedsDisplay:YES];
}

- (void)setFrame:(NSRect)frameRect {
	if (CGRectEqualToRect(self.frame, frameRect))
		return;

	[super setFrame:frameRect];
	[self setNeedsDisplay:YES];
}

- (BOOL)wantsUpdateLayer {
	return YES;
}

- (void)updateLayer {
	//self.layer.contents = self.image;
    
    /*
    if (isOSX_13_AndAbove)
        self.imageView.image = self.image;
    else
        self.layer.contents = self.image;
     */
    
    self.imageView.image = self.image;
    
	self.layer.backgroundColor = self.color.CGColor;
}

@end

@interface JNWCollectionViewCell()
@property (nonatomic, strong) JNWCollectionViewCellBackgroundView *backgroundView;
@property (nonatomic, strong) NSTrackingArea *trackingArea;


@property (nonatomic, strong) NSTextField *lblTitle;
@property (nonatomic, strong) NSTextField *lblDimension;
@property (nonatomic, strong) NSTextField *lblSize;
@property (nonatomic, strong) NSTextField *bottomBox;
@property (nonatomic, strong) NSTextField *vwSelectedState;
@property (nonatomic, strong) NSTextField *vwLineSelected;
@property (nonatomic,retain)  NSImageView *checkBox;
@property (nonatomic,retain)  NSButton *btnInfo;

@end

@implementation JNWCollectionViewCell
@synthesize contentView = _contentView;

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self == nil) return nil;
	
	[self _commonInit];
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self == nil) return nil;

	[self _commonInit];
	
	return self;
}

- (void)_commonInit {
	self.wantsLayer = YES;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

    /*
	_backgroundView = [[JNWCollectionViewCellBackgroundView alloc] initWithFrame:self.bounds];
	_backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

	_crossfadeDuration = 0.25;
     */
    
    CGRect FrameImg = self.bounds;
    
    
    if (!_isForSmallThubnails) {
        
        FrameImg.origin.x = 10;
        FrameImg.origin.y = 80;
        FrameImg.size.width = FrameImg.size.width - 2*10;
        FrameImg.size.height = FrameImg.size.height - 90;
        
        _backgroundView = [[JNWCollectionViewCellBackgroundView alloc] initWithFrame:FrameImg];
        _backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        
        [_btnInfo setBezelStyle:NSRegularSquareBezelStyle];
        [_btnInfo setButtonType:NSMomentaryChangeButton];
        _btnInfo = [[NSButton alloc] initWithFrame:CGRectMake(173, 13, 33, 33)];
        _btnInfo.autoresizingMask = NSViewNotSizable ;
        _btnInfo.font = [NSFont systemFontOfSize:10];
        _btnInfo.bordered = NO;
        _btnInfo.image = [NSImage imageNamed:@"info_active_icon.png"];
        _btnInfo.alternateImage = [NSImage imageNamed:@"info_active_icon.png"];
        _btnInfo.title = @"";
        [_btnInfo setAction:@selector(btnInfoTapped:)];
        [_btnInfo setTarget:self];
        
        [_btnInfo setToolTip:@"Click here to Get Photo Info"];
        [self addSubview:_btnInfo positioned:NSWindowBelow relativeTo:_contentView];
        
        
        
        
        _lblTitle = [[NSTextField alloc] initWithFrame:CGRectMake(21, 45, FrameImg.size.width - 20, 27)];
        _lblTitle.autoresizingMask = NSViewWidthSizable ;
        _lblTitle.backgroundColor = [NSColor clearColor];
        _lblTitle.textColor = [NSColor whiteColor];
        _lblTitle.font = [NSFont systemFontOfSize:12.0f];
        _lblTitle.bordered = NO;
        _lblTitle.editable = NO;
        [_lblTitle setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:_lblTitle positioned:NSWindowBelow relativeTo:_contentView];
        
        
        _lblDimension = [[NSTextField alloc] initWithFrame:CGRectMake(21, 33, FrameImg.size.width - 20, 15)];
        _lblDimension.autoresizingMask = NSViewWidthSizable ;
        _lblDimension.backgroundColor = [NSColor clearColor];
        _lblDimension.textColor = [NSColor colorWithCalibratedRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0f];
        _lblDimension.font = [NSFont systemFontOfSize:10];
        _lblDimension.bordered = NO;
        _lblDimension.editable = NO;
        [_lblDimension setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:_lblDimension positioned:NSWindowBelow relativeTo:_contentView];
        
        
        _lblSize = [[NSTextField alloc] initWithFrame:CGRectMake(21, 18, FrameImg.size.width - 20, 15)];
        _lblSize.autoresizingMask = NSViewWidthSizable ;
        _lblSize.backgroundColor = [NSColor clearColor];
        _lblSize.textColor = [NSColor colorWithCalibratedRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0f];
        _lblSize.font = [NSFont systemFontOfSize:10];
        _lblSize.bordered = NO;
        _lblSize.editable = NO;
        [_lblSize setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:_lblSize positioned:NSWindowBelow relativeTo:_contentView];
        
        
        _checkBox = [[NSImageView alloc] initWithFrame:CGRectMake(176, 259, 30, 30)];
        _checkBox.autoresizingMask = NSViewNotSizable ;
        _checkBox.font = [NSFont systemFontOfSize:10];
        //_checkBox.bordered = NO;
        _checkBox.image = [NSImage imageNamed:@"checked_icon_2.png"];
        [_checkBox setHidden:NO];
        [self addSubview:_checkBox positioned:NSWindowBelow relativeTo:_contentView];
        
        
        _bottomBox = [[NSTextField alloc] initWithFrame:CGRectMake(10, 9, FrameImg.size.width, 70)];
        _bottomBox.autoresizingMask = NSViewWidthSizable ;
        _bottomBox.backgroundColor = [NSColor colorWithCalibratedRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0f];
        _bottomBox.bordered = NO;
        _bottomBox.editable = NO;
        [self addSubview:_bottomBox positioned:NSWindowBelow relativeTo:_contentView];
        
        
        _crossfadeDuration = 0.25;
        [self addSubview:_backgroundView positioned:NSWindowBelow relativeTo:_contentView];
        
        _vwSelectedState = [[NSTextField alloc] initWithFrame:CGRectMake(7, 6, FrameImg.size.width + 6, self.bounds.size.height - 12)];
        _vwSelectedState.backgroundColor = [NSColor colorWithCalibratedRed:27/255.0 green:172/255.0 blue:143/255.0 alpha:0.53f];
        _vwSelectedState.bordered = NO;
        _vwSelectedState.editable = NO;
        _vwSelectedState.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [_vwSelectedState setHidden:NO];
        [self addSubview:_vwSelectedState positioned:NSWindowBelow relativeTo:_contentView];
        
        
        _vwLineSelected = [[NSTextField alloc] initWithFrame:CGRectMake(8, 8, FrameImg.size.width - 2*8, 3)];
        _vwLineSelected.backgroundColor = [NSColor colorWithCalibratedRed:27/255.0 green:172/255.0 blue:143/255.0 alpha:0.53f];
        _vwLineSelected.bordered = NO;
        _vwLineSelected.editable = NO;
        _vwLineSelected.autoresizingMask = NSViewWidthSizable;
        [_vwLineSelected setHidden:YES];
        [self addSubview:_vwLineSelected positioned:NSWindowBelow relativeTo:_contentView];
        
        
        
    }
    else
    {
        
        FrameImg.origin.x = 4;
        FrameImg.origin.y = 4;
        FrameImg.size.width = FrameImg.size.width - 2*4;
        FrameImg.size.height = FrameImg.size.height - 10;
        
        _backgroundView = [[JNWCollectionViewCellBackgroundView alloc] initWithFrame:FrameImg];
        _backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        _crossfadeDuration = 0.25;
        [self addSubview:_backgroundView positioned:NSWindowBelow relativeTo:_contentView];
        
        _vwSelectedState = [[NSTextField alloc] initWithFrame:CGRectMake(7, 7, FrameImg.size.width + 6, self.bounds.size.height - 12)];
        _vwSelectedState.backgroundColor = [NSColor colorWithCalibratedRed:27/255.0 green:172/255.0 blue:143/255.0 alpha:0.53f];
        _vwSelectedState.bordered = NO;
        _vwSelectedState.editable = NO;
        _vwSelectedState.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [_vwSelectedState setHidden:NO];
        [self addSubview:_vwSelectedState positioned:NSWindowBelow relativeTo:_contentView];
    }
    

	[self addSubview:_backgroundView positioned:NSWindowBelow relativeTo:nil];
}


-(void)setIsForSmallThubnails:(BOOL)isForSmallThubnails
{
    CGRect FrameImg = self.bounds;
    FrameImg.origin.x = 4;
    FrameImg.origin.y = 4;
    FrameImg.size.width = FrameImg.size.width - 2*4;
    FrameImg.size.height = FrameImg.size.height - 10;
    
    [_backgroundView setFrame:FrameImg];
    [_vwSelectedState setFrame:CGRectMake(4, 4, FrameImg.size.width + 4, FrameImg.size.height + 2)];
    [_vwLineSelected setFrame:CGRectMake(2, 0, FrameImg.size.width + 4, 3)];
    [_vwLineSelected setHidden:NO];
    
    [_bottomBox setHidden:YES];
    [_checkBox setHidden:YES];
    [_lblTitle setHidden:YES];
    [_vwSelectedState setHidden:YES];
}

/*-(void)setCellIndex:(int)cellIndex
 {
 self.cellIndex = cellIndex;
 }*/


-(void)setNameValue:(NSString *)nameValue
{
    self.lblTitle.stringValue =  nameValue;
    self.lblTitle.toolTip =  nameValue;
}

-(void)setDimensionValue:(NSString *)dimensionValue
{
    self.lblDimension.stringValue =  dimensionValue;
}

-(void)setSizeValue:(NSString *)sizeValue
{
    self.lblSize.stringValue =  sizeValue;
}


-(void)btnInfoTapped:(NSButton *)sender
{
    CGPoint location = [self.collectionView.superview.superview convertPoint:sender.frame.origin fromView:self];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    [self.collectionView btnInfoTappedAtLocationInCollectionView:location andIndex:indexPath];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animate {
    
    if (animate && self.selected != selected) {
        CATransition *transition = [CATransition animation];
        transition.duration = self.crossfadeDuration;
        [self.backgroundView.layer addAnimation:transition forKey:@"fade"];
    }
    
    self.selected = selected;
    
    //[_checkBox setHidden:!selected];
    // [_vwSelectedState setHidden:!selected];
}




-(void)selectCell:(BOOL)selected
{
}






-(void)setBgselectedColor:(NSColor *)bgselectedColor
{
    [self.vwSelectedState setBackgroundColor:bgselectedColor];
    [self.vwLineSelected setBackgroundColor:bgselectedColor];
}


-(void)setCheckImage:(NSImage *)checkImage
{
    [self.checkBox setImage:checkImage];
}


- (void)prepareForReuse {
	[self.backgroundView.layer removeAllAnimations];
	
	// for subclasses
}

- (void)willLayoutWithFrame:(CGRect)frame {
	// for subclasses
}

- (void)didLayoutWithFrame:(CGRect)frame {
	// for subclasses
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (self.trackingArea) {
		[self removeTrackingArea:self.trackingArea];
		self.trackingArea = nil;
	}

	NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
	self.trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:self.trackingArea];
}

- (NSView *)contentView {
	if (_contentView == nil) {
		_contentView = [[NSView alloc] initWithFrame:self.bounds];
		[self configureContentView:_contentView];
	}
	
	return _contentView;
}

- (void)setContentView:(NSView *)contentView {
	if (_contentView) {
		[_contentView removeFromSuperview];
	}
	
	_contentView = contentView;
	[self configureContentView:contentView];
}

- (void)configureContentView:(NSView *)contentView {
	contentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	contentView.wantsLayer = YES;
	
	[self addSubview:contentView];
}

- (void)setCollectionView:(JNWCollectionView *)collectionView {
	_collectionView = collectionView;
	self.backgroundView.collectionView = collectionView;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.backgroundView.color = backgroundColor;
}

- (NSColor *)backgroundColor {
	return self.backgroundView.color;
}

- (void)setBackgroundImage:(NSImage *)backgroundImage {
	self.backgroundView.image = backgroundImage;
}

- (NSImage *)backgroundImage {
	return self.backgroundView.image;
}

- (void)mouseDown:(NSEvent *)theEvent {
	[self.collectionView mouseDownInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
	[self.collectionView mouseUpInCollectionViewCell:self withEvent:theEvent];
	
	if (theEvent.clickCount == 2) {
		[self.collectionView doubleClickInCollectionViewCell:self withEvent:theEvent];
	}
}

- (void)mouseMoved:(NSEvent *)theEvent {
	[super mouseMoved:theEvent];

	[self.collectionView mouseMovedInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[super mouseEntered:theEvent];

	[self.collectionView mouseEnteredInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[super mouseExited:theEvent];

	[self.collectionView mouseExitedInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	[super mouseDragged:theEvent];

	[self.collectionView mouseDraggedInCollectionViewCell:self withEvent:theEvent];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
	[super rightMouseDown:theEvent];

	[self.collectionView rightClickInCollectionViewCell:self withEvent:theEvent];
}

- (void)rightMouseUp:(NSEvent *)theEvent {
}

#pragma mark NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; frame = %@; layer = <%@: %p>>", self.class, self, NSStringFromRect(self.frame), self.layer.class, self.layer];
}

@end
