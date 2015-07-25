# CHXSwipeBackPopAnimator
Swipe back pop animation, not just trigger screen edge!

# How does it look like?

<p align="left">
	<img src="./images/1.gif" width=24%">&nbsp;
	<img src="./images/2.gif" width=24%">&nbsp;
	<img src="./images/3.gif" width=24%">&nbsp;
</p>


## How to use

- add `pod CHXSwipeBackPopAnimator` your pod file
- run `pod update --no-repo-update --verbose`
- Edit you `UINavigationController` file
	
	```Objective-c
	#import <CHXSwipeBackPopAnimator/CHXSwipeBackPopAnimator.h>
	...
	@property (nonatomic, strong) CHXPopAnimatorCarrier *carrier;
	...
	self.carrier = [[CHXPopAnimatorCarrier alloc] initWithNavigationController:self];
    self.delegate = self.carrier;
	```
	
- Temporary	shield

	```
	- (void)viewWillAppear:(BOOL)animated {
	    [super viewWillAppear:animated];
    
    	[self.navigationController chx_disableInteractivePopGestureRecognizerButPreventScreenEdge:NO];
}

	- (void)viewWillDisappear:(BOOL)animated {
	    [super viewWillDisappear:animated];
	    
	    [self.navigationController chx_enableInteractivePopGestureRecognizer];
	}

	```

## Requirements

- iOS 7
- ARC

# Refrence
	
- [onevcat's blog](http://onevcat.com/2013/10/vc-transition-in-ios7/)
- [nonamelive](https://github.com/nonamelive/SloppySwiper/blob/master/Classes/SSWAnimator.m#L67)
