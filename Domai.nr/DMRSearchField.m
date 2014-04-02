//
//  DMRSearchField.m
//  Domai.nr
//
//  Created by Connor Montgomery on 09/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import "DMRSearchField.h"

@implementation DMRSearchField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSPoint origin = { 0.0,0.0 };
    NSRect rect;
    rect.origin = origin;
    rect.size.width  = [self bounds].size.width;
    rect.size.height = [self bounds].size.height;
    
    NSBezierPath *path;
    path = [NSBezierPath bezierPathWithRect:rect];
    [path setLineWidth:4];
    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.394] set];
    [path fill];
    [[NSColor colorWithRed:169/255.0f green:173/255.0f blue:168/255.0f alpha:1.0] set];
    [path stroke];
}

@end
