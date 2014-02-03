//
//  IntroPage.m
//  EAIntroView
//
//  Created by Jonas Schmid on 23/01/14.
//  Copyright (c) 2014 SampleCorp. All rights reserved.
//

#import "IntroPage.h"

@implementation IntroPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)toggleChanged:(id)sender {
    
    if(!self.introView) {
        return;
    }
    
    UISwitch *toggle = (UISwitch *)sender;
    
    self.introView.scrollEnabled = toggle.on;
}

@end
