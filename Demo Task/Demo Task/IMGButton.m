//
//  IMGButton.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "IMGButton.h"


@implementation IMGButton

@synthesize isMultiLine, multiLineStr, mTitle, enableImmediately,
			marginLeft, marginRight, marginTop, marginBottom, marginTopML, marginBottomML,
			imgOffState_Md, imgOffState_St, imgOffState_En, 
			colorOnState, colorOnStateDis, colorOffState, colorOffStateDis,
			imgOffStateDwn_Md, imgOffStateDwn_St, imgOffStateDwn_En,
			imgOffStateDis_Md, imgOffStateDis_St, imgOffStateDis_En,
			imgOnState_Md, imgOnState_St, imgOnState_En, 
			imgOnStateDwn_Md, imgOnStateDwn_St, imgOnStateDwn_En,
			imgOnStateDis_Md, imgOnStateDis_St, imgOnStateDis_En,
            makeBoldFont,imgMouseHover;

-(id)initWithCoder:(NSCoder *)decoder
{
	[super initWithCoder:decoder];
	marginLeft = 5;
	marginRight = 5;
	marginTop = 5;
	marginBottom = 5;
	marginTopML = 2;
	marginBottomML = 2;
	enableImmediately = YES;
	isMultiLine = NO;
    makeBoldFont = NO;
	[self setMultiLineStr:@" "];
	
	colorOnState = [[NSColor whiteColor] retain];
//	colorOnStateDis = [[NSColor darkGrayColor] retain];
	colorOnStateDis = [[NSColor colorWithCalibratedRed:96.0f/255 green:96.0f/255 blue:96.0f/255 alpha:1.0] retain];
	colorOffState = [[NSColor whiteColor] retain];
//	colorOffStateDis = [[NSColor darkGrayColor] retain];
	colorOffStateDis = [[NSColor colorWithCalibratedRed:96.0f/255 green:96.0f/255 blue:96.0f/255 alpha:1.0] retain];
	return self;
}

-(void)dealloc
{
	[mTitle release];
	[multiLineStr release];
	
	[colorOnState release];
	[colorOnStateDis release];
	[colorOffState release];
	[colorOffStateDis release];
	
	[imgOffState_Md release];
	[imgOffState_St release];
	[imgOffState_En release];

	[imgOffStateDwn_Md release];
	[imgOffStateDwn_St release];
	[imgOffStateDwn_En release];
	
	[imgOffStateDis_Md release];
	[imgOffStateDis_St release];
	[imgOffStateDis_En release];
	
	[imgOnState_Md release];
	[imgOnState_St release];
	[imgOnState_En release];
	
	[imgOnStateDwn_Md release];
	[imgOnStateDwn_St release];
	[imgOnStateDwn_En release];
	
	[imgOnStateDis_Md release];
	[imgOnStateDis_St release];
	[imgOnStateDis_En release];
	
	[super dealloc];
}

-(void)setButtonImages:(NSString *)imageName imgOnState_Md:(NSString *)middleImage imgOnState_En:(NSString *)lastImage
	  imgOnStateDwn_St:(NSString *)imageName2 imgOnStateDwn_Md:(NSString *)middleImage2 imgOnStateDwn_En:(NSString *)lastImage2 
	  imgOnStateDis_St:(NSString *)imageName3 imgOnStateDis_Md:(NSString *)middleImage3 imgOnStateDis_En:(NSString *)lastImage3 
		imgOffState_St:(NSString *)imageName4 imgOffState_Md:(NSString *)middleImage4 imgOffState_En:(NSString *)lastImage4 
	 imgOffStateDwn_St:(NSString *)imageName5 imgOffStateDwn_Md:(NSString *)middleImage5 imgOffStateDwn_En:(NSString *)lastImage5 
	 imgOffStateDis_St:(NSString *)imageName6 imgOffStateDis_Md:(NSString *)middleImage6 imgOffStateDis_En:(NSString *)lastImage6
{
	isMouseDown = NO;

	[self setImgOnState_Md:[NSString stringWithFormat:@"%@",middleImage]];
	[self setImgOnState_St:[NSString stringWithFormat:@"%@",imageName]];
	[self setImgOnState_En:[NSString stringWithFormat:@"%@",lastImage]];
	
	[self setImgOnStateDwn_Md:[NSString stringWithFormat:@"%@",middleImage2]];
	[self setImgOnStateDwn_St:[NSString stringWithFormat:@"%@",imageName2]];
	[self setImgOnStateDwn_En:[NSString stringWithFormat:@"%@",lastImage2]];
	
	[self setImgOnStateDis_Md:[NSString stringWithFormat:@"%@",middleImage3]];
	[self setImgOnStateDis_St:[NSString stringWithFormat:@"%@",imageName3]];
	[self setImgOnStateDis_En:[NSString stringWithFormat:@"%@",lastImage3]];

	[self setImgOffState_Md:[NSString stringWithFormat:@"%@",middleImage4]];
	[self setImgOffState_St:[NSString stringWithFormat:@"%@",imageName4]];
	[self setImgOffState_En:[NSString stringWithFormat:@"%@",lastImage4]];
	
	[self setImgOffStateDwn_Md:[NSString stringWithFormat:@"%@",middleImage5]];
	[self setImgOffStateDwn_St:[NSString stringWithFormat:@"%@",imageName5]];
	[self setImgOffStateDwn_En:[NSString stringWithFormat:@"%@",lastImage5]];
	
	[self setImgOffStateDis_Md:[NSString stringWithFormat:@"%@",middleImage6]];
	[self setImgOffStateDis_St:[NSString stringWithFormat:@"%@",imageName6]];
	[self setImgOffStateDis_En:[NSString stringWithFormat:@"%@",lastImage6]];
}

-(void)setButtonsImages:(NSString *)imageName imgState_Md:(NSString *)middleImage imgState_En:(NSString *)lastImage
        imgStateDwn_St:(NSString *)imageName2 imgStateDwn_Md:(NSString *)middleImage2 imgStateDwn_En:(NSString *)lastImage2
        imgStateDis_St:(NSString *)imageName3 imgStateDis_Md:(NSString *)middleImage3 imgStateDis_En:(NSString *)lastImage3
{
    [self setButtonImages:imageName imgOnState_Md:middleImage imgOnState_En:lastImage
			   imgOnStateDwn_St:imageName2 imgOnStateDwn_Md:middleImage2 imgOnStateDwn_En:lastImage2
			   imgOnStateDis_St:imageName3 imgOnStateDis_Md:middleImage3 imgOnStateDis_En:lastImage3
				 imgOffState_St:imageName imgOffState_Md:middleImage imgOffState_En:lastImage
			  imgOffStateDwn_St:imageName2 imgOffStateDwn_Md:middleImage2 imgOffStateDwn_En:lastImage2
			  imgOffStateDis_St:imageName3 imgOffStateDis_Md:middleImage3 imgOffStateDis_En:lastImage3];
}

- (void)mouseDown:(NSEvent *)theEvent 
{
	if (![self isEnabled]) 
		return;
	isMouseDown = YES;
//	NSPoint pos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [self setEnabled:NO];
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent 
{
//	if (![self isEnabled]) 
//		return;
    if(!isMouseDown)
        return;
	isMouseDown = NO;
	NSPoint pos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSSize size = [self frame].size;
	[self setNeedsDisplay:YES];
	if((pos.x < 0) || (pos.x > size.width) || (pos.y < 0) || (pos.y > size.height))
    {
        [self setEnabled:YES];
		return;
    }
    [NSApp sendAction:[self action] to:[self target] from:self];
	[self setState:![self state]];
    if(enableImmediately)
        [self setEnabled:YES];
	[self setNeedsDisplay:YES];
}

-(NSDictionary *)getAttributesForRect:(NSSize)rectBounds
{
	if(isMultiLine)
	{
		NSString *str = @"";
		NSArray *arr = [[self title] componentsSeparatedByString:multiLineStr];
		switch ([arr count]) {
			case 1:
				break;
			case 2:
				[self setTitle:[NSString stringWithFormat:@"%@\n%@",[arr objectAtIndex:0],[arr objectAtIndex:1]]];
				break;
			default:
				for(int i = 1; i<[arr count];i++)
				{
					if(i == ([arr count]-1))
						str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]];
					else
						str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@",[arr objectAtIndex:i],multiLineStr]];
				}
				[self setTitle:[NSString stringWithFormat:@"%@\n%@",[arr objectAtIndex:0],str]];
				break;
		}
	}

	NSDictionary *att = nil;
	int fontSize = 5;
	for(;fontSize<=50;fontSize++)
	{
		NSFont *myFont = [NSFont systemFontOfSize:fontSize];
		NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		if(isMultiLine)
			[style setLineBreakMode:NSLineBreakByWordWrapping];
		[style setAlignment:NSLeftTextAlignment];
		att = [[NSDictionary alloc] initWithObjectsAndKeys:
			   style, NSParagraphStyleAttributeName, 
			   colorText,NSForegroundColorAttributeName, 
			   myFont,NSFontAttributeName,
			   nil];
		NSSize size = [[self title] sizeWithAttributes:att];
		if(rectBounds.width < size.width || rectBounds.height < size.height)
		{
			[style release];
			[att release];
			myFont = [NSFont systemFontOfSize:fontSize-1];
			style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			if(isMultiLine)
				[style setLineBreakMode:NSLineBreakByWordWrapping];
//			[style setAlignment:NSLeftTextAlignment];
			[style setAlignment:NSCenterTextAlignment];
			att = [[NSDictionary alloc] initWithObjectsAndKeys:
				   style, NSParagraphStyleAttributeName, 
				   colorText,NSForegroundColorAttributeName, 
				   myFont,NSFontAttributeName,
				   nil];

			size = [[self title] sizeWithAttributes:att];
			if(rectBounds.height > size.height)
			{
				rectText.size.height = size.height;
				rectText.origin.y += (rectBounds.height - size.height)/2;
			}

			[style release];
			return [att autorelease];
		}
		[style release];
		[att release];
	}
	return [[[NSDictionary alloc] initWithObjectsAndKeys:
					   [NSParagraphStyle defaultParagraphStyle], NSParagraphStyleAttributeName, 
					   [NSColor blackColor],NSForegroundColorAttributeName, 
					   nil] autorelease];
}

-(void)getAttributesForRect:(NSRect)rect multi:(BOOL)isMulti
{
//	NSLog(@"w=%f",rect.size.width);
//	NSLog(@"h=%f",rect.size.height);
//	NSLog(@"x=%f",rect.origin.x);
//	NSLog(@"y=%f",rect.origin.y);

	NSSize rectBounds;
	if(isMulti)
	{
		int mid;
		NSArray *arr = [mTitle componentsSeparatedByString:multiLineStr];
		switch ([arr count]) {
			case 1:
				break;
			case 2:
				[self setMTitle:[NSString stringWithFormat:@"%@\n%@",[arr objectAtIndex:0],[arr objectAtIndex:1]]];
				break;
			default:
				mid = (int)[arr count]/2;
				NSString *str1 = [NSString stringWithFormat:@""];
				NSString *str2 = [NSString stringWithFormat:@""];
				
				for(int i = 0; i<=mid-1;i++)
				{
					if(i == (mid-1))
						str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]];
					else
						str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@"%@%@",[arr objectAtIndex:i],multiLineStr]];
				}
				for(int i = mid; i<=[arr count]-1;i++)
				{
					if(i == ([arr count]-1))
						str2 = [str2 stringByAppendingString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]];
					else
						str2 = [str2 stringByAppendingString:[NSString stringWithFormat:@"%@%@",[arr objectAtIndex:i],multiLineStr]];
				}
				
				[self setMTitle:[NSString stringWithFormat:@"%@\n%@",str1,str2]];
				
				break;
		}
		rect.origin.x += marginLeft;
		rect.origin.y += marginTopML;
		rect.size.width -= (marginLeft + marginRight);
		rect.size.height -= (marginTopML + marginBottomML);
	}
	else 
	{
		rect.origin.x += marginLeft;
		rect.origin.y += marginTop;
		rect.size.width -= (marginLeft + marginRight);
		rect.size.height -= (marginTop + marginBottom);
	}

//	NSLog(@"w=%f",rect.size.width);
//	NSLog(@"h=%f",rect.size.height);
//	NSLog(@"x=%f",rect.origin.x);
//	NSLog(@"y=%f",rect.origin.y);
	
	rectBounds = rect.size;
	
	NSDictionary *att = nil;
	int fontSize = 5;
	for(;fontSize<=50;fontSize++)
	{
//		NSFont *myFont = [NSFont systemFontOfSize:fontSize];
        NSFont *myFont = [NSFont fontWithName:@"Lucida Grande" size:fontSize];
		NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		if(isMulti)
			[style setLineBreakMode:NSLineBreakByWordWrapping];
		[style setAlignment:NSLeftTextAlignment];
		att = [[NSDictionary alloc] initWithObjectsAndKeys:
			   style, NSParagraphStyleAttributeName, 
			   colorText,NSForegroundColorAttributeName, 
			   myFont,NSFontAttributeName,
			   nil];
		NSSize size = [mTitle sizeWithAttributes:att];
		if(rectBounds.width < size.width || rectBounds.height < size.height)
		{
			[style release];
			[att release];
			myFont = [NSFont systemFontOfSize:fontSize-1];
            // ADDED JUST TO CHECK BUTTONS
            if(size.width >200 && size.width <245)
            {
                if(makeBoldFont)
                {
                NSFontManager *fManager = [NSFontManager sharedFontManager];
                myFont = [fManager fontWithFamily:@"Lucida Grande" traits:NSBoldFontMask weight:0 size:20];
                }
//                myFont = [NSFont boldSystemFontOfSize:20];
                //myFont = [NSFont fontWithName:@"Lucida Grande" size:20];
            }
			style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			if(isMulti)
				[style setLineBreakMode:NSLineBreakByWordWrapping];
			//			[style setAlignment:NSLeftTextAlignment];
			[style setAlignment:NSCenterTextAlignment];
			att = [[NSDictionary alloc] initWithObjectsAndKeys:
				   style, NSParagraphStyleAttributeName, 
				   colorText,NSForegroundColorAttributeName, 
				   myFont,NSFontAttributeName,
				   nil];
			
			size = [mTitle sizeWithAttributes:att];
			if(isMulti)
			{
				sizeM = size;
				dictM = [att retain];
				rectTextM = rect;
				rectTextM.origin.y += (rectTextM.size.height - size.height)/2;
			}
			else 
			{
				sizeNoM = size;
				dictNoM = [att retain];
				rectTextNoM = rect;
				rectTextNoM.origin.y += (rectTextNoM.size.height - size.height)/2;
			}
			[style release];
			[att release];
			break;
		}
		[style release];
		[att release];
	}
}

- (void)drawRect:(NSRect)dirtyRect 
{
	[self setMTitle:[NSString stringWithFormat:@"%@",[self title]]];
	[super drawRect:dirtyRect];

	oTitle = [[NSString alloc] initWithString:[self title]];
	switch ([self isEnabled]) {
		case YES:
			switch ([self state]) {
                    
				case NSOnState:
                    
					colorText = colorOnState;
					switch (isMouseDown) {
						case YES:
							pattern_St = [NSImage imageNamed:imgOnStateDwn_St];
							pattern_Mdl = [NSImage imageNamed:imgOnStateDwn_Md];
							pattern_En = [NSImage imageNamed:imgOnStateDwn_En];
							break;
						case NO:
							pattern_St = [NSImage imageNamed:imgOnState_St];
							pattern_Mdl = [NSImage imageNamed:imgOnState_Md];
							pattern_En = [NSImage imageNamed:imgOnState_En];
							break;
					}
					break;
				case NSOffState:
                    
					colorText = colorOffState;
					switch (isMouseDown) {
						case YES:
                            
							pattern_St = [NSImage imageNamed:imgOffStateDwn_St];
							pattern_Mdl = [NSImage imageNamed:imgOffStateDwn_Md];
							pattern_En = [NSImage imageNamed:imgOffStateDwn_En];
							break;
						case NO:
                            pattern_St = [NSImage imageNamed:imgOffState_St];
							pattern_Mdl = [NSImage imageNamed:imgOffState_Md];
							pattern_En = [NSImage imageNamed:imgOffState_En];
							break;
					}
					break;
			}
			break;
		case NO:
           
			switch ([self state]) {
				case NSOnState:
					colorText = colorOnStateDis;
					pattern_St = [NSImage imageNamed:imgOnStateDis_St];
					pattern_Mdl = [NSImage imageNamed:imgOnStateDis_Md];
					pattern_En = [NSImage imageNamed:imgOnStateDis_En];
					break;
				case NSOffState:
					colorText = colorOffStateDis;
					pattern_St = [NSImage imageNamed:imgOffStateDis_St];
					pattern_Mdl = [NSImage imageNamed:imgOffStateDis_Md];
					pattern_En = [NSImage imageNamed:imgOffStateDis_En];
					break;
			}
			break;
	}

    NSDrawThreePartImage([self bounds], pattern_St, pattern_Mdl, pattern_En, NO,
						 NSCompositeSourceOver, 1, YES);
	
	NSDictionary *att = nil;
	NSRect rect;
	rect = [self bounds];
	rectText = rect;
	rectTextM = rect;
	rectTextNoM = rect;
	[self getAttributesForRect:rect multi:NO];

	BOOL flagRelease = NO;
	if(([[oTitle componentsSeparatedByString:multiLineStr] count] > 1) ||
	   ([[oTitle componentsSeparatedByString:@"\n"] count] > 1))
	{
		[self getAttributesForRect:rect multi:YES];
		if(sizeM.width*sizeM.height > sizeNoM.width*sizeNoM.height)
		{
			att = dictM;
			rectText = rectTextM;
			if(isMouseDown)
			{
				rectText.origin.x += 1;
				rectText.origin.y += 1;
			}
			[mTitle drawInRect:rectText withAttributes:att];
		}
		else 
		{
			att = dictNoM;
			rectText = rectTextNoM;
			if(isMouseDown)
			{
				rectText.origin.x += 1;
				rectText.origin.y += 1;
			}
			[oTitle drawInRect:rectText withAttributes:att];

		}
		flagRelease = YES;
	}
	else
	{
		att = dictNoM;
		rectText = rectTextNoM;
		if(isMouseDown)
		{
			//rectText.origin.x += 1;
			//rectText.origin.y += 1;
		}
		[oTitle drawInRect:rectText withAttributes:att];
	}

	if(flagRelease) 
		if(dictM) 
			[dictM release];
	if(dictNoM) 
		[dictNoM release];
	[oTitle release];
    
    if(isMouseHover)
    {
        switch ([self state]) {
            case NSOnState:
                
                break;
            case NSOffState:

                pattern_St = [NSImage imageNamed:imgOnState_St];
                pattern_Mdl = [NSImage imageNamed:imgOnState_Md];
                pattern_En = [NSImage imageNamed:imgMouseHover];
                
                NSDrawThreePartImage([self bounds], pattern_St, pattern_Mdl, pattern_En, NO,
                                     NSCompositeSourceOver, 1, YES);
                break;
        }
    }
    
}

- (void)resetCursorRects
{
    NSCursor *aCursor = [NSCursor pointingHandCursor];
    [self addCursorRect:[self visibleRect] cursor:aCursor];
    [aCursor setOnMouseEntered:YES];
}

//To Track Mouse Hover n Out

- (void)awakeFromNib
{
    [self createTrackingArea];
}

- (void)createTrackingArea
{
    NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
    focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
    focusTrackingAreaOptions |= NSTrackingAssumeInside;
    focusTrackingAreaOptions |= NSTrackingInVisibleRect;
    
    NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                                     options:focusTrackingAreaOptions owner:self userInfo:nil];
    [self addTrackingArea:focusTrackingArea];
}


-(void)mouseEntered:(NSEvent *)theEvent
{
    if (self.isEnabled) {
        isMouseHover = YES;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseExited:(NSEvent *)theEvent
{
    isMouseHover = NO;
    [self setNeedsDisplay:YES];
}




@end

