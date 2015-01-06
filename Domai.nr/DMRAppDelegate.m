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
#import <Carbon/Carbon.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "DDHotKeyCenter.h"
#import <PTHotKey/PTHotKeyCenter.h>
#import <PTHotKey/PTHotKey.h>
#import "GAJavaScriptTracker.h"

@interface DMRAppDelegate () {
    AXStatusItemPopup *_statusItemPopup;
    DMRViewController *_viewController;
    GAJavaScriptTracker *_tracker;
    DDHotKey *_hotKey;
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

    id recordedValue = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"keyboardShortcut"];

    if (recordedValue != nil) {
        [self addKeyboardShortcut];
    } else {
        [self addDefaultKeyboardShortcut];
    }
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                                              forKeyPath:@"keyboardShortcut"
                                                                 options:NSKeyValueObservingOptionNew
                                                                 context:NULL];
}

- (void)addKeyboardShortcut {
    NSDictionary *shortcutDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyboardShortcut"];

    unsigned int keyCode = [[shortcutDict objectForKey:@"keyCode"] intValue];
    NSUInteger modFlags = [[shortcutDict objectForKey:@"modifierFlags"] longValue];


    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    _hotKey = [c registerHotKeyWithKeyCode:keyCode
                             modifierFlags:modFlags
                                    target:self
                                    action:@selector(openWindowShortcut)
                                    object:nil];
}

- (void)addDefaultKeyboardShortcut {
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    _hotKey = [c registerHotKeyWithKeyCode:kVK_ANSI_D modifierFlags:(NSCommandKeyMask + NSShiftKeyMask) target:self action:@selector(openWindowShortcut) object:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (_hotKey != nil) {
        DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
        [c unregisterHotKey:_hotKey];
    }
    [self addKeyboardShortcut];
}

- (void)startTrackingEvents {
    NSString *googleAnalyticsId = @"UA-27167671-1";
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
