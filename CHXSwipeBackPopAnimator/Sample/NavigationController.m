//
//  NavigationController.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 4/18/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "NavigationController.h"
#import "CHXPopAnimatorPayload.h"

@interface NavigationController ()
@property (nonatomic, strong) CHXPopAnimatorPayload *payload;
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.payload = [[CHXPopAnimatorPayload alloc] initWithNavigationController:self];
    self.delegate = self.payload;
}


@end
