//
//  AppDelegate.m
//  NSOpenGLViewDemo
//
//  Created by tyler on 12/31/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "AppDelegate.h"
#import "WTRootVC.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self changeWindowToRoot];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark change window
-(void)changeWindowToRoot {
    
    WTRootVC *vc = [[WTRootVC alloc]init];
    [self.window setContentViewController:vc];
}


@end
