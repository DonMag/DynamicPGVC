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

@property (strong, nonatomic) IBOutlet UIView *parentView;
@property (strong, nonatomic) IBOutlet UIView *framingView;
@property (strong, nonatomic) IBOutlet UILabel *parentViewTitle;

@property (strong, nonatomic) IBOutlet UIView *carouselWrapper;

@property (strong, nonatomic) MyPageViewController *pageViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	firstLook = NO;
	
	// round the corners of the "framing" view
	_framingView.layer.cornerRadius = 16.0;
	
	// _parentView starts hidden
	_parentView.hidden = YES;
	
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
	
	typeof(self) __weak weakSelf = self;
	__weak OverlayView *cv = v;
	v.closeButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			[cv removeFromSuperview];
		}
	};
	v.bottomButtonBlock = ^{
		typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf) {
			NSLog(@"Bottom button was tapped!");
			// do something
		}
	};

}

- (IBAction)hideOverlayView:(id)sender {
	_parentView.hidden = YES;
	if (_pageViewController) {
		[_pageViewController willMoveToParentViewController:nil];
		[_pageViewController.view removeFromSuperview];
		[_pageViewController removeFromParentViewController];
		_pageViewController = nil;
	} else {
		[[[_carouselWrapper subviews] firstObject] removeFromSuperview];
	}
}

// MARK: setting a UILabel as carouselWrapper content
- (IBAction)showWithLabel:(id)sender {
	UILabel *v = [UILabel new];
	v.numberOfLines = 0;
	v.textAlignment = NSTextAlignmentCenter;
	v.text = @"This is sample text for a plain UILable embedded in the carouselWrapper view.";
	v.translatesAutoresizingMaskIntoConstraints = NO;
	[_carouselWrapper addSubview:v];
	[NSLayoutConstraint activateConstraints:@[
		// constrain label with 8-pts padding on all sides
		[v.topAnchor constraintEqualToAnchor:_carouselWrapper.topAnchor constant:12.0],
		[v.leadingAnchor constraintEqualToAnchor:_carouselWrapper.leadingAnchor constant:12.0],
		[v.trailingAnchor constraintEqualToAnchor:_carouselWrapper.trailingAnchor constant:-12.0],
		[v.bottomAnchor constraintEqualToAnchor:_carouselWrapper.bottomAnchor constant:-12.0],
	]];

	_parentViewTitle.text = @"ParentView Title";
	
	[self.view bringSubviewToFront:_parentView];
	_parentView.hidden = NO;
}

// MARK: setting a UIImageView as carouselWrapper content
- (IBAction)showWithImage:(id)sender {
	UIImageView *v = [UIImageView new];
	v.contentMode = UIViewContentModeScaleAspectFit;
	v.backgroundColor = [UIColor redColor];
	UIImage *img = [UIImage imageNamed:@"sampleImage"];
	CGFloat factor = 1.0;
	if (img) {
		v.image = img;
		factor = img.size.height / img.size.width;
	}
	v.translatesAutoresizingMaskIntoConstraints = NO;
	[_carouselWrapper addSubview:v];
	[NSLayoutConstraint activateConstraints:@[
		// constrain image to all sides
		[v.topAnchor constraintEqualToAnchor:_carouselWrapper.topAnchor constant:0.0],
		[v.leadingAnchor constraintEqualToAnchor:_carouselWrapper.leadingAnchor constant:0.0],
		[v.trailingAnchor constraintEqualToAnchor:_carouselWrapper.trailingAnchor constant:0.0],
		[v.bottomAnchor constraintEqualToAnchor:_carouselWrapper.bottomAnchor constant:0.0],
		
		// use loaded image aspect ratio for height
		[v.heightAnchor constraintEqualToAnchor:v.widthAnchor multiplier:factor],
	]];
	
	_parentViewTitle.text = @"Using an image view\nas the carousel content.";
	
	[self.view bringSubviewToFront:_parentView];
	_parentView.hidden = NO;
}


// MARK: setting a UIPageViewController as carouselWrapper content
- (IBAction)showWithPageViewController:(id)sender {
	
	NSArray *dynamicContent = @[
		@"Page View Controller\n\nView height will be set to the \"max height\" of the pages.",
		@"UILabel\n\nA label can contain an arbitrary amount of text, but UILabel may shrink, wrap, or truncate the text, depending on the size of the bounding rectangle and properties you set. You can control the font, text color, alignment, highlighting, and shadowing of the text in the label.",
		@"UIButton\n\nYou can set the title, image, and other appearance properties of a button. In addition, you can specify a different appearance for each button state.",
		@"UISegmentedControl\n\nThe segments can represent single or multiple selection, or a list of commands.\n\nEach segment can display text or an image, but not both.",
		@"UITextView\n\nWhen a user taps a text view, a keyboard appears; when a user taps Return in the keyboard, the keyboard disappears and the text view can handle the input in an application-specific way. You can specify attributes, such as font, color, and alignment, that apply to all text in a text view.",
		@"UIScrollView\n\nUIScrollView provides a mechanism to display content that is larger than the size of the application’s window and enables users to scroll within that content by making swiping gestures.",
	];
	
	NSMutableArray *pages = [NSMutableArray new];
	CGFloat maxHeight = 0;
	
	CGSize fitSize = CGSizeMake(_carouselWrapper.frame.size.width, UILayoutFittingCompressedSize.height);
	
	// instantiate view controllers for the "pages"
	//	using dynamic content (the strings array)
	for (NSString *str in dynamicContent) {
		SampleContentViewController *vc = [SampleContentViewController new];
		vc.contentString = str;
		// add to pages array
		[pages addObject:vc];
		// get size of page view
		CGSize sz = [vc.view systemLayoutSizeFittingSize:fitSize withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultLow];
		maxHeight = MAX(sz.height, maxHeight);
	}
	
	// if using the built-in PageControl
	//	add height of PageControl + 1.5 (control is shown 1.5-pts below the view)
	UIPageControl *c = [UIPageControl new];
	maxHeight += [c sizeForNumberOfPages:1].height + 1.5;
	
	// instantiate page view controller
	MyPageViewController *vc = [[MyPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	
	// set array of page controllers
	[vc setOrderedPages:pages];
	
	// add as child
	[self addChildViewController:vc];
	
	// loaded as YES, so we need to set it to NO
	vc.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	// add view to _carouselWrapper
	[_carouselWrapper addSubview:vc.view];
	
	// constrain to all 4 sides
	[NSLayoutConstraint activateConstraints:@[
		[vc.view.topAnchor constraintEqualToAnchor:_carouselWrapper.topAnchor],
		[vc.view.leadingAnchor constraintEqualToAnchor:_carouselWrapper.leadingAnchor],
		[vc.view.trailingAnchor constraintEqualToAnchor:_carouselWrapper.trailingAnchor],
		[vc.view.bottomAnchor constraintEqualToAnchor:_carouselWrapper.bottomAnchor],
		
		// height as determined above
		[vc.view.heightAnchor constraintEqualToConstant:maxHeight],
	]];
	
	[vc didMoveToParentViewController:self];
	_pageViewController = vc;

	_parentViewTitle.text = @"Está gostando do app? Assine já nosso pacote premium e desfrute ainda mais!";
	
	[self.view bringSubviewToFront:_parentView];
	_parentView.hidden = NO;
	
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
