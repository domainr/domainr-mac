//
//  DMRTableRowView.h
//  Domai.nr
//
//  Created by Connor Montgomery on 09/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMRTableRowView : NSTableRowView {
@private
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
}

@end

// Used by the HoverTableRowView and the HoverTableView
void DrawSeparatorInRect(NSRect rect);
