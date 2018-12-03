//
//  Constants.h
//  Demo Task
//
//  Created by Sanket Nagar on 03/12/18.
//  Copyright © 2018 Sanket Nagar. All rights reserved.
//

#import "AppDelegate.h"
#ifndef Constants_h
#define Constants_h

typedef NS_ENUM(NSInteger, K_IMAGE_VIEW_MODE)
{
    grid_VIEW = 0,
    list_VIEW
};



#define FLICKR_SAMPLE_API_KEY @"aff6d851fd7a8e47cdd3a68cf85ac8cf"
#define FLICKR_SAMPLE_API_SHARED_SECRET @"aa88728f23e3c786"


#define MAX_PHOTOS_TO_ADD 1000000

#define imgPlaceHolder  [NSImage imageNamed:@"place_holder.png"]

#define APPDELEGATE  (AppDelegate *)[[NSApplication sharedApplication] delegate]
#define USER_DEFAULT        [NSUserDefaults standardUserDefaults]
#define USER_DEFAULT_SYNC   [[NSUserDefaults standardUserDefaults] synchronize]

#define defaultImageFormats @[@"Keep original format",@"tif",@"bmp",@"gif",@"jpg",@"jpeg",@"png",@"jp2"]

#endif
