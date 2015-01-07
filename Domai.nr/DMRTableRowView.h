//
//  DMRTableRowView.h
//  Domainr
//
//  Created by Connor Montgomery on 09/04/2014.
//  Copyright (c) 2014 Domainr. All rights reserved.
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
