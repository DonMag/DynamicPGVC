//
//  ViewController.m
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import "ViewController.h"
#import "MyPageViewController.h"
#import "SampleContentViewController.h"

#import "OverlayView.h"

@interface ViewController ()
{
	BOOL firstLook;
}

@property (strong, nonatomic) MyPageViewController *pageViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	firstLook = YES;
	
}

- (OverlayView *)addOverlayView {

	OverlayView *v = [OverlayView new];
	v.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:v];
	[NSLayoutConstraint activateConstraints:@[
		// constrain image to all sides
		[v.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0.0],
		[v.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0.0],
		[v.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0],
		[v.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0.0],
	]];

	// by default, close button will remove the OverlayView
	typeof(self) __weak weakSelf = self;
	__weak OverlayView *ov = v;
	v.closeButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			[strongSelf fadeOverlayView:ov];
		}
	};

	// force layout so OverlayView knows its width
	//	when we add content to its carouselView
	[v layoutIfNeeded];
	
	v.alpha = 0;
	
	return v;
	
}

- (void)fadeOverlayView:(UIView *)v {
	CGFloat target = v.alpha == 0 ? 1 : 0;
	[UIView animateWithDuration:0.3 animations:^{
		v.alpha = target;
	} completion:^(BOOL finished) {
		if (target == 0) {
			[v removeFromSuperview];
		}
	}];
}

// MARK: setting a UILabel as carouselWrapper content
- (IBAction)showWithLabel:(id)sender {

	OverlayView *v = [self addOverlayView];
	
	[v addLabel:@"This is sample text for a plain UILable embedded in the carouselWrapper view."];
	
	[v setTitle:@"Overlay view Title"];
	[v setButtonTitle:@"Tap Me!"];
	
	typeof(self) __weak weakSelf = self;
	v.bottomButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			NSLog(@"Bottom button was tapped!");
			// do something
		}
	};
	
	[self fadeOverlayView:v];

}

// MARK: setting a UIImageView as carouselWrapper content
- (IBAction)showWithImage:(id)sender {
	
	OverlayView *v = [self addOverlayView];
	
	[v addImageNamed:@"sampleImage"];
	
	[v setTitle:@"Using an image view\nas the carousel content."];
	[v setButtonTitle:@"Bottom Button!"];

	typeof(self) __weak weakSelf = self;
	v.bottomButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			NSLog(@"Bottom button was tapped!");
			// do something
		}
	};

	[self fadeOverlayView:v];
	
}


// MARK: setting a UIPageViewController as carouselWrapper content
- (IBAction)showWithPageViewController:(id)sender {
	
	NSArray *dynamicContent = @[
		@[@"Page View Controller", @"View height will be set to the max height of the pages."],
		@[@"UILabel", @"A label can contain an arbitrary amount of text, but UILabel may shrink, wrap, or truncate the text, depending on the size of the bounding rectangle and properties you set. You can control the font, text color, alignment, highlighting, and shadowing of the text in the label."],
		@[@"UIButton", @"You can set the title, image, and other appearance properties of a button. In addition, you can specify a different appearance for each button state."],
		@[@"UISegmentedControl", @"The segments can represent single or multiple selection, or a list of commands.\n\nEach segment can display text or an image, but not both."],
		@[@"UITextView", @"When a user taps a text view, a keyboard appears; when a user taps Return in the keyboard, the keyboard disappears and the text view can handle the input in an application-specific way. You can specify attributes, such as font, color, and alignment, that apply to all text in a text view."],
		@[@"UIScrollView", @"UIScrollView provides a mechanism to display content that is larger than the size of the application’s window and enables users to scroll within that content by making swiping gestures."],
	];
	
	NSMutableArray *pages = [NSMutableArray new];

	// instantiate view controllers for the "pages"
	//	using dynamic content (the strings array)
	for (NSArray *a in dynamicContent) {
		SampleContentViewController *vc = [SampleContentViewController new];
		vc.titleString = a[0];
		vc.contentString = a[1];
		// add to pages array
		[pages addObject:vc];
	}
	
	// instantiate page view controller
	MyPageViewController *pgVC = [[MyPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

	// set array of page controllers
	[pgVC setOrderedPages:pages];

	// add as child
	[self addChildViewController:pgVC];

	OverlayView *v = [self addOverlayView];
	
	[v addPageViewController:pgVC withPages:pages];
	
	[v setTitle:@"Está gostando do app? Assine já nosso pacote premium e desfrute ainda mais!"];
	[v setButtonTitle:@"Eu quero!"];

	[pgVC didMoveToParentViewController:self];
	
	// different closeButton closure
	//	because we need to remove the
	//	child PageViewController
	
	typeof(self) __weak weakSelf = self;
	__weak OverlayView *ov = v;
	__weak MyPageViewController *vc = pgVC;
	
	v.closeButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			[vc willMoveToParentViewController:nil];
			[self fadeOverlayView:ov];
			[vc removeFromParentViewController];
		}
	};

	v.bottomButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			NSLog(@"Bottom button was tapped!");
			// do something
		}
	};
	
	[self fadeOverlayView:v];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (firstLook) {
		firstLook = NO;
		UIAlertController *ac = [UIAlertController
								 alertControllerWithTitle:@"Please Note"
								 message:@"This is Example Code Only and should not be considered \"Production Ready\""
								 preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *a = [UIAlertAction actionWithTitle:@"Got It!" style:UIAlertActionStyleDefault handler:nil];
		[ac addAction:a];
		[self presentViewController:ac animated:YES completion:nil];
	}
}

@end
