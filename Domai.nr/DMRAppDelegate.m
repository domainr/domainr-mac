//
//  DMRAppDelegate.m
//  Domai.nr
//
//  Created by Connor Montgomery on 31/03/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import "DMRAppDelegate.h"
#import "DMRViewController.h"
#import "AXStatusItemPopup.h"
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>
#import "GAJavaScriptTracker.h"

@interface DMRAppDelegate () {
    AXStatusItemPopup *_statusItemPopup;
    DMRViewController *_viewController;
    GAJavaScriptTracker *_tracker;
}
@end

@implementation DMRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _viewController = [[DMRViewController alloc] initWithNibName:@"DMRViewController" bundle:nil];

    [self startTrackingEvents];
    _viewController.tracker = _tracker;
    
    NSImage *image = [NSImage imageNamed:@"icon"];
    NSImage *alternateImage = [NSImage imageNamed:@"icon_active"];
    
    _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:_viewController image:image alternateImage:alternateImage];

    _statusItemPopup.tracker = _tracker;
    _viewController.statusItemPopup = _statusItemPopup;
    
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    [c registerHotKeyWithKeyCode:kVK_ANSI_D modifierFlags:(NSCommandKeyMask + NSShiftKeyMask) target:self action:@selector(openWindowShortcut) object:nil];
}

- (void)startTrackingEvents {
    NSString *googleAnalyticsId = @""; // coming soon from @case
    NSInteger batchSize = 0;
    NSInteger batchInterval = 1;
    _tracker = [GAJavaScriptTracker trackerWithAccountID:googleAnalyticsId];
    _tracker.batchSize = batchSize;
    _tracker.batchInterval = batchInterval;
    [_tracker start];
}

- (void)openWindowShortcut {
    [_tracker trackEvent:@"openMacAppWindow"
                  action:@"click"
                   label:nil
                   value:-1
               withError:nil];
    [self openWindow];
}

- (void)openWindow {
    [_statusItemPopup showPopover];
}

- (void)closeWindow {
    [_statusItemPopup hidePopover];
}

@end
