//
//  MouseDownView.h
//  Demo Task
//
//  Created by Sanket Nagar on 04/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MouseDownViewDelegate <NSObject>

- (void)mouseDown:(NSEvent *) event View:(NSView *)view;
- (void)mouseDragged:(NSEvent *)event View:(NSView *)view;
- (void)mouseUp:(NSEvent *)event View:(NSView *)view;
- (void)mouseExited:(NSEvent *)event View:(NSView *)view;
- (void)scrollWheel:(NSEvent *)theEvent View:(NSView *)view;
- (void)mouseDoubbleClicked:(NSEvent *)event View:(NSView *)view;
-(void)rightMouseDown:(NSEvent *)theEvent;

-(void)swipeWithDirection:(int)direction;

@end

@interface MouseDownView : NSView<NSTextFieldDelegate>

@property (readwrite, weak) id <MouseDownViewDelegate> delegate;

@end
