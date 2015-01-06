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

    NSDictionary *shortcutDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyboardShortcut"];

    [self.recorderControl bind:NSValueBinding
                      toObject:[NSUserDefaultsController sharedUserDefaultsController]
                   withKeyPath:@"values.keyboardShortcut"
                       options:nil];

    NSString *greyscaleIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"greyscaleIcon"];

    if ([greyscaleIcon isEqualToString:@"YES"]) {
        [_iconCheckbox setState:NSOnState];
    } else {
        [_iconCheckbox setState:NSOffState];
    }

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
    NSString *useGreyScaleIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"greyscaleIcon"];
    if ([(NSButton *)sender state] == NSOnState) {
        useGreyScaleIcon = @"YES";
    } else {
        useGreyScaleIcon = @"NO";
    }

    [[NSUserDefaults standardUserDefaults] setObject:useGreyScaleIcon forKey:@"greyscaleIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
