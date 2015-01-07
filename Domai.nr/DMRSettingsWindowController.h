//
//  DMRSettingsWindowController.h
//  Domainr
//
//  Created by Connor Montgomery on 05/01/2015.
//  Copyright (c) 2015 Domainr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface DMRSettingsWindowController : NSWindowController <SRRecorderControlDelegate>

@property (weak) IBOutlet SRRecorderControl *recorderControl;
@property (nonatomic) NSViewController *opener;
@property (weak) IBOutlet NSButton *iconCheckbox;

- (IBAction)didClickClose:(id)sender;
- (IBAction)didToggleBlackWhiteIcon:(id)sender;

@end
