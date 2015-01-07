//
//  DMRViewController.h
//  Domainr
//
//  Created by Connor Montgomery on 02/04/2014.
//  Copyright (c) 2014 Domainr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AXStatusItemPopup.h"
#import "DMRTextFieldView.h"
#import "DMRResultsTableView.h"
#import "GAJavaScriptTracker.h"

@interface DMRViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, ExtendedTableViewDelegate>

@property(weak, nonatomic) AXStatusItemPopup *statusItemPopup;
@property(nonatomic) DMRTextFieldView *searchBox;
@property (nonatomic) GAJavaScriptTracker *tracker;

@end
