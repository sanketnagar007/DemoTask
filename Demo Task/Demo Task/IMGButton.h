//
//  IMGButton.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@interface IMGButton : NSButton {
	NSString *imgOffState_Md;
	NSString *imgOffState_St;
	NSString *imgOffState_En;

	NSString *imgOffStateDwn_Md;
	NSString *imgOffStateDwn_St;
	NSString *imgOffStateDwn_En;
	
	NSString *imgOffStateDis_Md;
	NSString *imgOffStateDis_St;
	NSString *imgOffStateDis_En;
	
	NSString *imgOnState_Md;
	NSString *imgOnState_St;
	NSString *imgOnState_En;

	NSString *imgOnStateDwn_Md;
	NSString *imgOnStateDwn_St;
	NSString *imgOnStateDwn_En;
	
	NSString *imgOnStateDis_Md;
	NSString *imgOnStateDis_St;
	NSString *imgOnStateDis_En;
	
    NSString *imgMouseHover;
    NSString *imgMouseOut;
    
    NSImage *pattern_St;
    NSImage *pattern_Mdl;
    NSImage *pattern_En;
	
	NSColor *colorOnState;
	NSColor *colorOnStateDis;
	NSColor *colorOffState;
	NSColor *colorOffStateDis;

	NSColor *colorText;

	BOOL isMouseDown;

	int marginLeft;
	int marginRight;
	int marginTop;
	int marginBottom;
	int marginTopML;
	int marginBottomML;
	
	NSDictionary *dictM;
	NSDictionary *dictNoM;
	NSSize sizeM;
	NSSize sizeNoM;
	NSRect rectTextM;
	NSRect rectTextNoM;

	NSString *oTitle;
	NSString *mTitle;
	BOOL isMultiLine;
	NSString *multiLineStr;
	NSRect rectText;
    BOOL enableImmediately;
    BOOL makeBoldFont;
    
    BOOL isMouseHover;
}

@property (readwrite, assign) BOOL enableImmediately;
@property (readwrite, assign) BOOL makeBoldFont;

@property (readwrite, assign) BOOL isMultiLine;
@property (readwrite, retain) NSString *multiLineStr;
@property (readwrite, retain) NSString *mTitle;

@property (readwrite, assign) int marginLeft;
@property (readwrite, assign) int marginRight;
@property (readwrite, assign) int marginTop;
@property (readwrite, assign) int marginBottom;
@property (readwrite, assign) int marginTopML;
@property (readwrite, assign) int marginBottomML;

@property (readwrite, retain) NSColor *colorOnState;
@property (readwrite, retain) NSColor *colorOnStateDis;
@property (readwrite, retain) NSColor *colorOffState;
@property (readwrite, retain) NSColor *colorOffStateDis;

@property (readwrite, retain) NSString *imgOffState_Md;
@property (readwrite, retain) NSString *imgOffState_St;
@property (readwrite, retain) NSString *imgOffState_En;

@property (readwrite, retain) NSString *imgOffStateDwn_Md;
@property (readwrite, retain) NSString *imgOffStateDwn_St;
@property (readwrite, retain) NSString *imgOffStateDwn_En;

@property (readwrite, retain) NSString *imgOffStateDis_Md;
@property (readwrite, retain) NSString *imgOffStateDis_St;
@property (readwrite, retain) NSString *imgOffStateDis_En;

@property (readwrite, retain) NSString *imgOnState_Md;
@property (readwrite, retain) NSString *imgOnState_St;
@property (readwrite, retain) NSString *imgOnState_En;

@property (readwrite, retain) NSString *imgOnStateDwn_Md;
@property (readwrite, retain) NSString *imgOnStateDwn_St;
@property (readwrite, retain) NSString *imgOnStateDwn_En;

@property (readwrite, retain) NSString *imgOnStateDis_Md;
@property (readwrite, retain) NSString *imgOnStateDis_St;
@property (readwrite, retain) NSString *imgOnStateDis_En;

@property (readwrite, retain) NSString *imgMouseHover;
@property (readwrite, retain) NSString *imgMouseOut;

-(void)setButtonImages:(NSString *)imageName imgOnState_Md:(NSString *)middleImage imgOnState_En:(NSString *)lastImage
	 imgOnStateDwn_St:(NSString *)imageName2 imgOnStateDwn_Md:(NSString *)middleImage2 imgOnStateDwn_En:(NSString *)lastImage2 
	 imgOnStateDis_St:(NSString *)imageName3 imgOnStateDis_Md:(NSString *)middleImage3 imgOnStateDis_En:(NSString *)lastImage3 
		imgOffState_St:(NSString *)imageName4 imgOffState_Md:(NSString *)middleImage4 imgOffState_En:(NSString *)lastImage4 
	 imgOffStateDwn_St:(NSString *)imageName5 imgOffStateDwn_Md:(NSString *)middleImage5 imgOffStateDwn_En:(NSString *)lastImage5 
	 imgOffStateDis_St:(NSString *)imageName6 imgOffStateDis_Md:(NSString *)middleImage6 imgOffStateDis_En:(NSString *)lastImage6;

-(void)setButtonsImages:(NSString *)imageName imgState_Md:(NSString *)middleImage imgState_En:(NSString *)lastImage
      imgStateDwn_St:(NSString *)imageName2 imgStateDwn_Md:(NSString *)middleImage2 imgStateDwn_En:(NSString *)lastImage2
        imgStateDis_St:(NSString *)imageName3 imgStateDis_Md:(NSString *)middleImage3 imgStateDis_En:(NSString *)lastImage3;

@end
