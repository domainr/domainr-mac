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

@interface DMRAppDelegate () {
    AXStatusItemPopup *_statusItemPopup;
    DMRViewController *_viewController;
}
@end

@implementation DMRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _viewController = [[DMRViewController alloc] initWithNibName:@"DMRViewController" bundle:nil];
    
    NSImage *image = [NSImage imageNamed:@"icon"];
    NSImage *alternateImage = [NSImage imageNamed:@"icon_active"];
    
    _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:_viewController image:image alternateImage:alternateImage];
    
    _viewController.statusItemPopup = _statusItemPopup;
    
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    [c registerHotKeyWithKeyCode:kVK_ANSI_D modifierFlags:(NSCommandKeyMask + NSShiftKeyMask) target:self action:@selector(openWindow) object:nil];
    [c registerHotKeyWithKeyCode:kVK_Escape modifierFlags:nil target:self action:@selector(closeWindow) object:nil];
}

- (void)openWindow {
    [_statusItemPopup showPopover];
}

- (void)closeWindow {
    [_statusItemPopup hidePopover];
}

@end
