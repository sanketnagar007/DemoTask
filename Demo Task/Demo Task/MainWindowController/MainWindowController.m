//
//  MainWindowController.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "MainWindowController.h"
#import "Constants.h"

NSString *const kAddPhotosViewTitle        = @"AddPhotosVC";

@interface MainWindowController ()
{
   
}

@end

@implementation MainWindowController

@synthesize windowMain;

- (void)windowDidLoad {
    
    [super windowDidLoad];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSetup];
}

-(void)initSetup
{
    [self setupView];
    [self changeViewController:kAddPhotosView];
    
    [windowMain makeKeyAndOrderFront:self];

}

-(void)setupView
{
    //setting window initially
    CGRect fullScreenSize = [NSScreen mainScreen].frame;
    CGRect visibleScreenSize = [[NSScreen mainScreen] visibleFrame];
    float padd_x = visibleScreenSize.size.width / 15;
    float padd_y = visibleScreenSize.size.height / 20;
    
    CGRect frameMainWin;
    frameMainWin.origin.x = visibleScreenSize.origin.x + padd_x;
    frameMainWin.origin.y = visibleScreenSize.origin.y + padd_y;
    frameMainWin.size.width = visibleScreenSize.size.width - 2 *padd_x;
    frameMainWin.size.height = visibleScreenSize.size.height - 2 *padd_y;
    
    if (frameMainWin.size.width < 1300)
    {
        frameMainWin.size.width = 1300;
    }
    
    [self.windowMain setFrame:frameMainWin display:YES];
    [self.windowMain setMaxSize:fullScreenSize.size];
    
    [windowMain setOpaque:NO];
    [windowMain setBackgroundColor:[NSColor clearColor]];
    [windowMain setMovableByWindowBackground:NO];
    [windowMain setHasShadow:YES];
    
    [mainScreenView setWantsLayer:YES];
    [mainBG setHidden:NO];
    [mainBG setWantsLayer:YES];
    [mainBG.layer setCornerRadius:5.0f];
    [mainBG setBackgroundColor:[NSColor colorWithCalibratedRed:22/255.0 green:22/255.0 blue:22/255.0 alpha:.994f]];
}

- (void)changeViewController:(NSInteger)whichViewTag
{
    if ([self.myCurrentViewController view] != nil)
    {
        [[self.myCurrentViewController view] removeFromSuperview];
    }
    
    switch (whichViewTag)
    {
        case kAddPhotosView:
        {
            if (self.addPhotosViewController == nil)
            {
                _addPhotosViewController = [[AddPhotosVC alloc] initWithNibName:kAddPhotosViewTitle bundle:nil];
            }
            self.myCurrentViewController = self.addPhotosViewController;
            [self.myCurrentViewController setTitle:kAddPhotosViewTitle];
            
            break;
        }
    }
    
    [mainScreenView addSubview:[self.myCurrentViewController view]];
    
    [[self.myCurrentViewController view] setFrame:[mainScreenView bounds]];
    [self.myCurrentViewController setRepresentedObject:[NSNumber numberWithUnsignedInteger:[[[self.myCurrentViewController view] subviews] count]]];
    [self didChangeValueForKey:@"viewController"];
}

- (NSViewController *)viewController
{
    return self.myCurrentViewController;
}


#pragma mark - WINDOW RESIZE

- (void)windowDidResize:(NSNotification *)notification
{

}

-(void)windowDidEndLiveResize:(NSNotification *)notification
{

}

-(void)windowDidEnterFullScreen:(NSNotification *)notification
{

}

-(void)windowDidExitFullScreen:(NSNotification *)notification
{

}


@end
