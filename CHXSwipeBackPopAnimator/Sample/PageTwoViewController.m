//
//  PageTwoViewController.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 5/26/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "PageTwoViewController.h"
#import "CHXSwipeBackPopAnimator.h"

@interface PageTwoViewController ()

@end

@implementation PageTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController chx_disableInteractivePopGestureRecognizerButPreventScreenEdge:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController chx_enableInteractivePopGestureRecognizer];
}

@end
