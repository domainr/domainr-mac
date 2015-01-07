//
//  DMRResultsTableView.h
//  Domainr
//
//  Created by Connor Montgomery on 09/04/2014.
//  Copyright (c) 2014 Domainr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ExtendedTableViewDelegate <NSObject>

- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row;
- (void)tableView:(NSTableView *)tableView didPressEnter:(NSEvent *)theEvent;

@end

@interface DMRResultsTableView : NSTableView

@property (nonatomic, weak) id<ExtendedTableViewDelegate> extendedDelegate;

@end
