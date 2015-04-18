//
//  CHXPopAnimator.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 4/18/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "CHXPopAnimator.h"

NSString * const kShadowOpacityKey = @"shadowOpacity";
CGFloat const kShadowOpacityStart = 0.2f;
CGFloat const kShadowOpacityEnd = 0.05f;

NSString * const kOpacityKey = @"opacity";
CGFloat const kOpacityStart = 0.2f;
CGFloat const kOpacityEnd = 0.0f;

#pragma mark -

@implementation UIView (CHXLeftEdgeShadow)

- (void)addLeftEdgeShadowShadow
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = kShadowOpacityStart;
}

@end

#pragma mark -

@implementation CHXPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext
{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [fromViewController.view addLeftEdgeShadowShadow];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    // Add mask layer to toViewController's view
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = toViewController.view.bounds;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.opacity = kOpacityStart;
    [toViewController.view.layer addSublayer:maskLayer];
    
    // Fix hidesBottomBarWhenPushed not animated properly
    UITabBarController *tabBarController = toViewController.tabBarController;
    UINavigationController *navController = toViewController.navigationController;
    UITabBar *tabBar = tabBarController.tabBar;
    BOOL shouldAddTabBarBackToTabBarController = NO;
    
    BOOL tabBarControllerContainsToViewController = [tabBarController.viewControllers containsObject:toViewController];
    BOOL tabBarControllerContainsNavController = [tabBarController.viewControllers containsObject:navController];
    BOOL isToViewControllerFirstInNavController = [navController.viewControllers firstObject] == toViewController;
    if (tabBar && (tabBarControllerContainsToViewController || (isToViewControllerFirstInNavController && tabBarControllerContainsNavController))) {
        [tabBar.layer removeAllAnimations];
        
        CGRect tabBarRect = tabBar.frame;
        tabBarRect.origin.x = toViewController.view.bounds.origin.x;
        tabBar.frame = tabBarRect;
        
        [toViewController.view addSubview:tabBar];
        shouldAddTabBarBackToTabBarController = YES;
    }
    
    CGFloat width = CGRectGetWidth(fromViewController.view.frame);
    CGPoint fromViewCenter = fromViewController.view.center;
    CGPoint toViewCenter = toViewController.view.center;
    toViewCenter.x = width * 0.2f;
    toViewController.view.center = toViewCenter;
    fromViewCenter.x = width + width / 2.0f;
    toViewCenter.x = width / 2.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear animations: ^{
        fromViewController.view.center = fromViewCenter;
        toViewController.view.center = toViewCenter;
    } completion: ^(BOOL finished) {
        if (shouldAddTabBarBackToTabBarController) {
            [tabBarController.view addSubview:tabBar];
            
            CGRect tabBarRect = tabBar.frame;
            tabBarRect.origin.x = tabBarController.view.bounds.origin.x;
            tabBar.frame = tabBarRect;
        }
        
        [maskLayer removeFromSuperlayer];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:[self transitionDuration:transitionContext]];
    
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:kShadowOpacityKey];
    shadowOpacityAnimation.fromValue = [NSNumber numberWithFloat:kShadowOpacityStart];
    [fromViewController.view.layer addAnimation:shadowOpacityAnimation forKey:kShadowOpacityKey];
    fromViewController.view.layer.shadowOpacity = kShadowOpacityEnd;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:kOpacityKey];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:kOpacityStart];
    opacityAnimation.duration = [self transitionDuration:transitionContext];
    [maskLayer addAnimation:opacityAnimation forKey:kOpacityKey];
    maskLayer.opacity = kOpacityEnd;
    
    [CATransaction commit];
}

@end
