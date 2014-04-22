//
//  DMRTextFieldView.m
//  Domai.nr
//
//  Created by Connor Montgomery on 10/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import "DMRTextFieldView.h"

@interface DMRTextFieldView () {
    NSArray *keycodeBlacklist;
}
@end

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
    [_timer invalidate];
    int keycode = theEvent.keyCode;
    if (keycode == 126 || keycode == 125) {
        [self.extendedDelegate didKeyUp:theEvent];
    } else {
        [super keyUp:theEvent];
        if ([keycodeBlacklist count] == 0) {
            keycodeBlacklist = @[@36, @123, @124];
        }
        
        BOOL found = NO;
        for (int i = 0; i < [keycodeBlacklist count]; i++) {
            if ([keycodeBlacklist[i] intValue] == keycode) {
                found = YES;
            }
        }
        if (!found) { // if it's not in our blacklist, start the timer.
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.7f
                                                      target:self
                                                    selector:@selector(didExpire:)
                                                    userInfo:nil
                                                     repeats:NO];

        }
    }
}

- (void)didExpire:(NSTimer *)timer {
    [self.extendedDelegate timerDidExpire:timer];
}

@end
