//
//  ViewController.h
//
//  Copyright (c) 2013 Evgeny Aleksandrov. License: MIT.

#import "PageSubclass.h"

@implementation PageSubclass

- (void)pageDidLoad {
    NSLog(@"Page loaded");
}

- (void)pageDidAppear {
    NSLog(@"Page appeared");
}

- (void)pageDidDisappear {
    NSLog(@"Page disappeared");
}

@end
