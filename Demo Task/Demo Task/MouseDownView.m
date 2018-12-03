//
//  MouseDownView.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "MouseDownView.h"
#import "Constants.h"

@implementation MouseDownView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - MOUSE DOWN EVENT

- (void)mouseDown:(NSEvent *) event {
    
    
    if([event clickCount] == 1 )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDown: View:)]) {
            [self.delegate mouseDown:event View:self];
            
           // NSCursor *aCursor = [NSCursor openHandCursor];
           // [self addCursorRect:self.frame cursor:aCursor];
        }

    }
    else if([event clickCount] > 1)
    {
        if ([self.delegate respondsToSelector:@selector(mouseDoubbleClicked: View:)])
        {
            [self.delegate mouseDoubbleClicked:event View:self];
        }
    }
}


- (void)mouseDragged:(NSEvent *)event
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDragged: View:)]) {
        [self.delegate mouseDragged:event View:self];
    }
}


-(void)mouseUp:(NSEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseUp: View:)]) {
        [self.delegate mouseUp:event View:self];
    }
}


-(void)mouseExited:(NSEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseExited: View:)]) {
        [self.delegate mouseExited:event View:self];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollWheel: View:)]) {
        [self.delegate scrollWheel:theEvent View:self];
    }
}



-(void)rightMouseDown:(NSEvent *)theEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightMouseDown:)]) {
        [self.delegate rightMouseDown:theEvent];
    }
}



- (void)keyDown: (NSEvent *) event {
    
    if ([event keyCode] == 13){ //For return key
        
    }
    if ([event keyCode] == 9){ //For tab key
        
    }
    
}

@end
