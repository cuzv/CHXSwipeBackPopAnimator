//
//  PageThreeViewController.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 5/26/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "PageThreeViewController.h"

@interface PageThreeViewController ()

@end

@implementation PageThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

@end
