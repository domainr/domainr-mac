//
//  DMRTextFieldView.h
//  Domainr
//
//  Created by Connor Montgomery on 10/04/2014.
//  Copyright (c) 2014 Domainr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DMRTextFieldViewDelegate <NSObject>

- (void)didKeyUp:(NSEvent *)theEvent;
- (void)timerDidExpire:(NSTimer *)timer;

@end

@interface DMRTextFieldView : NSTextField

@property (nonatomic, weak) id<DMRTextFieldViewDelegate> extendedDelegate;
@property (nonatomic, weak) NSTimer *timer;

@end
