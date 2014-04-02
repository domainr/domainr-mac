//
//  DMRResultsTableView.m
//  Domai.nr
//
//  Created by Connor Montgomery on 09/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import "DMRResultsTableView.h"
#import "DMRTableRowView.h"

@implementation DMRResultsTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    NSPoint globalLocation = [theEvent locationInWindow];
    NSPoint localLocation = [self convertPoint:globalLocation fromView:nil];
    NSInteger clickedRow = [self rowAtPoint:localLocation];
    
    [super mouseDown:theEvent];
    
    if (clickedRow != -1) {
        [self.extendedDelegate tableView:self didClickedRow:clickedRow];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (CGFloat)yPositionPastLastRow {
    // Only draw the grid past the last visible row
    NSInteger numberOfRows = self.numberOfRows;
    CGFloat yStart = 0;
    if (numberOfRows > 0) {
        yStart = NSMaxY([self rectOfRow:numberOfRows - 1]);
    }
    return yStart;
}

- (void)drawGridInClipRect:(NSRect)clipRect {
    // Only draw the grid past the last visible row
    CGFloat yStart = [self yPositionPastLastRow];
    // Draw the first separator one row past the last row
    yStart += self.rowHeight;
    
    // One thing to do is smarter clip testing to see if we actually need to draw!
    NSRect boundsToDraw = self.bounds;
    NSRect separatorRect = boundsToDraw;
    separatorRect.size.height = 1;
    while (yStart < NSMaxY(boundsToDraw)) {
        separatorRect.origin.y = yStart;
        DrawSeparatorInRect(separatorRect);
        yStart += self.rowHeight;
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    int keycode = theEvent.keyCode;
    if (keycode == 36) {
        
    } else {
        [super keyDown:theEvent];
    }
}

-(void)mouseMoved:(NSEvent *)theEvent {
    [super mouseMoved:theEvent];
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    long column = [self columnAtPoint:p];
    long row = [self rowAtPoint:p];
    id cell = [[self.tableColumns objectAtIndex:column] dataCellForRow:row];
    NSLog(@"cell: %@", cell);
}

- (void)setFrameSize:(NSSize)size {
    [super setFrameSize:size];
    // We need to invalidate more things when live-resizing since we fill with a gradient and stroke
    if ([self inLiveResize]) {
        CGFloat yStart = [self yPositionPastLastRow];
        if (NSHeight(self.bounds) > yStart) {
            // Redraw our horizontal grid lines
            NSRect boundsPastY = self.bounds;
            boundsPastY.size.height -= yStart;
            boundsPastY.origin.y = yStart;
            [self setNeedsDisplayInRect:boundsPastY];
        }
    }
}

@end
