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
    BOOL _isUsingGreyscaleIcon;
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NSUserDefaultsDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];

    NSString *greyscaleIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"greyscaleIcon"];
    if ([greyscaleIcon isEqualToString:@"YES"]) {
        _isUsingGreyscaleIcon = YES;
    }

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


- (void)NSUserDefaultsDidChange:(NSNotification *)notification {

    NSDictionary *keyboardShortcut = [[notification object] objectForKey:@"keyboardShortcut"];
    NSString *greyscaleIcon = [[notification object] objectForKey:@"greyscaleIcon"];

    if (greyscaleIcon == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"greyscaleIcon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _isUsingGreyscaleIcon = YES;
    }

    if ([greyscaleIcon isEqualToString:@"YES"] && !_isUsingGreyscaleIcon) {
        NSLog(@"switch to greyscale icon");
        _isUsingGreyscaleIcon = YES;
    } else if ([greyscaleIcon isEqualToString:@"NO"] && _isUsingGreyscaleIcon) {
        NSLog(@"switch to COLOR icon");
        _isUsingGreyscaleIcon = NO;
    }

    NSNumber *ksModFlags = keyboardShortcut[@"modifierFlags"];
    long hkModFlags = (long)_hotKey.modifierFlags;

    NSNumber *ksKeyCode = keyboardShortcut[@"keyCode"];
    long hkKeyCode = (long)_hotKey.keyCode;

    NSNumber *ksKeyCodeNum = [NSNumber numberWithUnsignedLong:ksKeyCode];
    NSNumber *ksModFlagNum = [NSNumber numberWithLong:ksModFlags];
    NSNumber *hkKeyCodeNum = [NSNumber numberWithLong:hkKeyCode];
    NSNumber *hkModFlagNum = [NSNumber numberWithLong:hkModFlags];


    if (_hotKey != nil && (![hkModFlagNum isEqualTo:ksModFlags] || ![hkKeyCodeNum isEqualTo:ksKeyCode])) {
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
