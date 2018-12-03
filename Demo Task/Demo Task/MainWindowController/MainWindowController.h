//
//  MainWindowController.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AddPhotosVC.h"

enum
{
    kAddPhotosView = 0,
};

@class AddPhotosVC;

@interface MainWindowController : NSWindowController<NSWindowDelegate>
{
    IBOutlet NSView             *mainScreenView;

    IBOutlet NSTextField        *mainBG;
}

@property (nonatomic, retain) IBOutlet NSWindow *windowMain;
@property (nonatomic, assign) NSViewController *myCurrentViewController;
@property (nonatomic, strong) AddPhotosVC *addPhotosViewController;

- (NSViewController *)viewController;

@end
