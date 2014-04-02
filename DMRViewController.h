//
//  DMRViewController.h
//  Domai.nr
//
//  Created by Connor Montgomery on 02/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AXStatusItemPopup.h"
#import "DMRResultsTableView.h"

@interface DMRViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, ExtendedTableViewDelegate>

@property(weak, nonatomic) AXStatusItemPopup *statusItemPopup;

@end
