//
//  DMRSettingsWindowController.h
//  Domainr
//
//  Created by Connor Montgomery on 05/01/2015.
//  Copyright (c) 2015 Domai.nr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface DMRSettingsWindowController : NSWindowController <SRRecorderControlDelegate>

@property (weak) IBOutlet SRRecorderControl *recorderControl;
@property (nonatomic) NSViewController *opener;

- (IBAction)didClickClose:(id)sender;
- (IBAction)didToggleBlackWhiteIcon:(id)sender;

@end
