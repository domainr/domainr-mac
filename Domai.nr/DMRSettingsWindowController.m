//
//  DMRSettingsWindowController.m
//  Domainr
//
//  Created by Connor Montgomery on 05/01/2015.
//  Copyright (c) 2015 Domai.nr. All rights reserved.
//

#import "DMRSettingsWindowController.h"

@interface DMRSettingsWindowController ()

@end

@implementation DMRSettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.recorderControl.delegate = self;
}

- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)aRecorder {
    NSDictionary *recordedVal = aRecorder.objectValue;

    [[NSUserDefaults standardUserDefaults] setObject:recordedVal forKey:@"keyboardShortcut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)didClickClose:(id)sender {
    [self.window close];
}

- (IBAction)didToggleBlackWhiteIcon:(id)sender {
}

@end
