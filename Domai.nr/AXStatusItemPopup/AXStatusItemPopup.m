//
//  StatusItemPopup.m
//  StatusItemPopup
//
//  Created by Alexander Schuch on 06/03/13.
//  Copyright (c) 2013 Alexander Schuch. All rights reserved.
//

#import "AXStatusItemPopup.h"
#import "INPopoverWindow.h"
#import "INPopoverController.h"
#import "DMRViewController.h"

#define kMinViewWidth 22

//
// Private variables
//
@interface AXStatusItemPopup () {
    DMRViewController *_viewController;
    BOOL _active;
    NSImageView *_imageView;
    NSStatusItem *_statusItem;
    INPopoverController *_popover;
    id _popoverTransiencyMonitor;
}
@end

///////////////////////////////////

//
// Implementation
//
@implementation AXStatusItemPopup

- (id)initWithViewController:(NSViewController *)controller
{
    return [self initWithViewController:controller image:nil];
}

- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image
{
    return [self initWithViewController:controller image:image alternateImage:nil];
}

- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage
{
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    self = [super initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
    if (self) {
        _viewController = controller;
        
        self.image = image;
        self.alternateImage = alternateImage;
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
        [self addSubview:_imageView];
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusItem.view = self;
        
        _active = NO;
        _animated = YES;
    }
    return self;
}


////////////////////////////////////
#pragma mark - Drawing
////////////////////////////////////

- (void)drawRect:(NSRect)dirtyRect
{
    // set view background color
    if (_active) {
        [[NSColor selectedMenuItemColor] setFill];
    } else {
        [[NSColor clearColor] setFill];
    }
    NSRectFill(dirtyRect);
    
    // set image
    NSImage *image = (_active ? _alternateImage : _image);
    _imageView.image = image;
}

////////////////////////////////////
#pragma mark - Mouse Actions
////////////////////////////////////

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_popover.popoverIsVisible) {
        [self hidePopover];
    } else {
        [self showPopover];
    }    
}

////////////////////////////////////
#pragma mark - Setter
////////////////////////////////////

- (void)setActive:(BOOL)active
{
    _active = active;
    [self setNeedsDisplay:YES];
}

- (void)setImage:(NSImage *)image
{
    _image = image;
    [self updateViewFrame];
}

- (void)setAlternateImage:(NSImage *)image
{
    _alternateImage = image;
    if (!image && _image) {
        _alternateImage = _image;
    }
    [self updateViewFrame];
}

////////////////////////////////////
#pragma mark - Helper
////////////////////////////////////

- (void)updateViewFrame
{
    CGFloat width = MAX(MAX(kMinViewWidth, self.alternateImage.size.width), self.image.size.width);
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    NSRect frame = NSMakeRect(0, 0, width, height);
    self.frame = frame;
    _imageView.frame = frame;
    
    [self setNeedsDisplay:YES];
}


////////////////////////////////////
#pragma mark - Show / Hide Popover
////////////////////////////////////

- (void)showPopover
{
    [_tracker trackPageview:@"foobar" withError:nil];
    [self showPopoverAnimated:_animated];
}

- (void)showPopoverAnimated:(BOOL)animated
{
    self.active = YES;
    
    if (!_popover) {
        _popover = [[INPopoverController alloc] init];
        _popover.animationType = INPopoverAnimationTypeFadeIn;
        _popover.contentViewController = _viewController;
        _popover.animates = YES;
        [_popover setColor:[NSColor whiteColor]];
//        [_popover setColor:[NSColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0]];
        [_popover setBorderColor:[NSColor clearColor]];
    }
    
    if (!_popover.popoverIsVisible) {
        _popover.animates = animated;
        [_viewController.searchBox becomeFirstResponder];
        [_popover presentPopoverFromRect:self.frame inView:self preferredArrowDirection:INPopoverArrowDirectionUp anchorsToPositionView:YES];
        _popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask handler:^(NSEvent* event) {
            [self hidePopover];
        }];
    }
}

- (void)hidePopover
{
    self.active = NO;
    
    if (_popover && _popover.popoverIsVisible) {
        [_popover.popoverWindow close];
        [NSEvent removeMonitor:_popoverTransiencyMonitor];
    }
}

@end

