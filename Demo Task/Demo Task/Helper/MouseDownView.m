//
//  MouseDownView.m
//  Demo Task
//
//  Created by Sanket Nagar on 04/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "MouseDownView.h"
#import "Constants.h"

@implementation MouseDownView
{
    BOOL enableSwipeFlag;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    enableSwipeFlag = YES;
    // Drawing code here.
}

#pragma mark - MOUSE DOWN EVENT

- (void)mouseDown:(NSEvent *) event {
    
    if([event clickCount] == 1 )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDown: View:)]) {
            [self.delegate mouseDown:event View:self];
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
    NSLog(@"swipe delta =%f",theEvent.deltaX);
    
    int direction;
    if (theEvent.deltaX != 0 && enableSwipeFlag)
    {
        enableSwipeFlag = NO;
        
         if (theEvent.deltaX < 0)
             direction = LEFT_SWIPE;
         else
             direction = RIGHT_SWIPE;
        
         if (self.delegate && [self.delegate respondsToSelector:@selector(swipeWithDirection:)])
         {
             [self.delegate swipeWithDirection:direction];
         }
        
        [self performSelector:@selector(enableSwipe) withObject:nil afterDelay:0.5];
    }
}

-(void)enableSwipe
{
    enableSwipeFlag = YES;
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightMouseDown:)]) {
        [self.delegate rightMouseDown:theEvent];
    }
}

- (void)swipeWithEvent:(NSEvent *)event
{
}

@end
