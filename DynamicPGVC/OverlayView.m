//
//  OverlayView.m
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import "OverlayView.h"

@interface OverlayView ()
{
	UIButton *closeButton;
	
	UIView *framingView;
	UILabel *titleLabel;
	UIView *carouselWrapper;
	UIButton *bottomButton;
	UIStackView *stack;
}
@end

@implementation OverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	
	self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

	UIButton *closeButton = [UIButton new];

	framingView = [UIView new];
	titleLabel = [UILabel new];
	carouselWrapper = [UIView new];
	bottomButton = [UIButton new];
	stack = [UIStackView new];
	
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	framingView.translatesAutoresizingMaskIntoConstraints = NO;
	stack.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self addSubview:framingView];
	[framingView addSubview:stack];
	[framingView addSubview:closeButton];
	
	[NSLayoutConstraint activateConstraints:@[
		
		// framingView inset 12-pts leading / trailing
		[framingView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12.0],
		[framingView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12.0],
		// centered vertically
		[framingView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
		
		// stack view inset 16-pts top/bottom 32-pts leading/trailing
		[stack.topAnchor constraintEqualToAnchor:framingView.topAnchor constant:16.0],
		[stack.bottomAnchor constraintEqualToAnchor:framingView.bottomAnchor constant:-16.0],
		[stack.leadingAnchor constraintEqualToAnchor:framingView.leadingAnchor constant:32.0],
		[stack.trailingAnchor constraintEqualToAnchor:framingView.trailingAnchor constant:-32.0],

		// bottom button height
		[bottomButton.heightAnchor constraintEqualToConstant:44.0],
		
		// close button at top-right
		[closeButton.topAnchor constraintEqualToAnchor:framingView.topAnchor constant:8.0],
		[closeButton.trailingAnchor constraintEqualToAnchor:framingView.trailingAnchor constant:-8.0],
		
	]];
	
	[stack addArrangedSubview:titleLabel];
	[stack addArrangedSubview:carouselWrapper];
	[stack addArrangedSubview:bottomButton];
	
	stack.axis = UILayoutConstraintAxisVertical;
	stack.alignment = UIStackViewAlignmentFill;
	stack.distribution = UIStackViewAlignmentFill;
	stack.spacing = 12.0;
	
	// element properties
	
	carouselWrapper.layer.borderColor = [[UIColor colorWithRed:0.4 green:0.1 blue:0.9 alpha:1.0] CGColor];
	carouselWrapper.layer.borderWidth = 1;
	
	framingView.backgroundColor = [UIColor whiteColor];
	framingView.layer.cornerRadius = 16.0;
	
	[closeButton setTitle:@"X" forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];

	titleLabel.numberOfLines = 0;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.9 alpha:1.0];
	titleLabel.font = [UIFont systemFontOfSize:19.0 weight:UIFontWeightBold];
	
	bottomButton.backgroundColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.9 alpha:1.0];
	[bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[bottomButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
	
	[closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[bottomButton addTarget:self action:@selector(bottomButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonTapped {
	_closeButtonBlock();
}
- (void)bottomButtonTapped {
	_bottomButtonBlock();
}

#ifdef DEBUG
// during dev / debugging, verify we haven't created a retain cycle
- (void)dealloc
{
	NSLog(@"Overlay view is being dealloc'd");
}
#endif

// MARK: setups
- (void)addLabel:(NSString *)str {
	
	UILabel *v = [UILabel new];
	v.numberOfLines = 0;
	v.textAlignment = NSTextAlignmentCenter;
	v.text = str;
	v.translatesAutoresizingMaskIntoConstraints = NO;

	[carouselWrapper addSubview:v];
	[NSLayoutConstraint activateConstraints:@[
		// constrain label with 12-pts padding on all sides
		[v.topAnchor constraintEqualToAnchor:carouselWrapper.topAnchor constant:12.0],
		[v.leadingAnchor constraintEqualToAnchor:carouselWrapper.leadingAnchor constant:12.0],
		[v.trailingAnchor constraintEqualToAnchor:carouselWrapper.trailingAnchor constant:-12.0],
		[v.bottomAnchor constraintEqualToAnchor:carouselWrapper.bottomAnchor constant:-12.0],
	]];

	carouselWrapper.backgroundColor = [UIColor whiteColor];
	
}

- (void)addImageNamed:(NSString *)str {
	
	UIImageView *v = [UIImageView new];
	v.contentMode = UIViewContentModeScaleAspectFit;
	v.backgroundColor = [UIColor redColor];
	UIImage *img = [UIImage imageNamed:str];
	CGFloat factor = 1.0;
	if (img) {
		v.image = img;
		factor = img.size.height / img.size.width;
	}
	v.translatesAutoresizingMaskIntoConstraints = NO;
	
	[carouselWrapper addSubview:v];
	[NSLayoutConstraint activateConstraints:@[
		// constrain image to all sides
		[v.topAnchor constraintEqualToAnchor:carouselWrapper.topAnchor constant:0.0],
		[v.leadingAnchor constraintEqualToAnchor:carouselWrapper.leadingAnchor constant:0.0],
		[v.trailingAnchor constraintEqualToAnchor:carouselWrapper.trailingAnchor constant:0.0],
		[v.bottomAnchor constraintEqualToAnchor:carouselWrapper.bottomAnchor constant:0.0],
		
		// use loaded image aspect ratio for height
		[v.heightAnchor constraintEqualToAnchor:v.widthAnchor multiplier:factor],
	]];

	carouselWrapper.backgroundColor = [UIColor whiteColor];
	
}

- (void)addPageViewController:(UIPageViewController *)pgVC withPages:(NSMutableArray *)pages {
	
	CGFloat maxHeight = 0;
	
	CGSize fitSize = CGSizeMake(carouselWrapper.frame.size.width, UILayoutFittingCompressedSize.height);

	for (UIViewController *vc in pages) {
		// get size of page view
		CGSize sz = [vc.view systemLayoutSizeFittingSize:fitSize withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultLow];
		maxHeight = MAX(sz.height, maxHeight);
	}
	
	// if using the built-in PageControl
	//	add height of PageControl + 1.5 (control is shown 1.5-pts below the view)
	UIPageControl *c = [UIPageControl new];
	maxHeight += [c sizeForNumberOfPages:1].height + 1.5;

	// loaded as YES, so we need to set it to NO
	pgVC.view.translatesAutoresizingMaskIntoConstraints = NO;

	// add view to _carouselWrapper
	[carouselWrapper addSubview:pgVC.view];

	// constrain to all 4 sides
	[NSLayoutConstraint activateConstraints:@[
		[pgVC.view.topAnchor constraintEqualToAnchor:carouselWrapper.topAnchor],
		[pgVC.view.leadingAnchor constraintEqualToAnchor:carouselWrapper.leadingAnchor],
		[pgVC.view.trailingAnchor constraintEqualToAnchor:carouselWrapper.trailingAnchor],
		[pgVC.view.bottomAnchor constraintEqualToAnchor:carouselWrapper.bottomAnchor],

		// height as determined above
		[pgVC.view.heightAnchor constraintEqualToConstant:maxHeight],
	]];

	carouselWrapper.backgroundColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.9 alpha:1.0];

}

- (void)setTitle:(NSString *)str {
	titleLabel.text = str;
}

- (void)setButtonTitle:(NSString *)str {
	[bottomButton setTitle:str forState:UIControlStateNormal];
}

@end
