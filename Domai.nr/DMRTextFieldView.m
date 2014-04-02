//
//  DMRTextFieldView.m
//  Domai.nr
//
//  Created by Connor Montgomery on 10/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import "DMRTextFieldView.h"

@implementation DMRTextFieldView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)keyUp:(NSEvent *)theEvent {
    int keycode = theEvent.keyCode;
    if (keycode == 126 || keycode == 125) {
        [self.extendedDelegate didKeyUp:theEvent];
    } else {
        [super keyUp:theEvent];
    }
}

@end
