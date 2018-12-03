//
//  AppDelegate.m
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    MainWindowController *myWindowController;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self openMainWindow];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)openMainWindow
{
    
    if (myWindowController == nil)
    {
        myWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    }
    [myWindowController showWindow:self];
    
}

@end
