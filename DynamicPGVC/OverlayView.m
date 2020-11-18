//
//  OverlayView.m
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import "OverlayView.h"

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

	UIView *framingView = [UIView new];
	UILabel *titleLabel = [UILabel new];
	UIView *carouselWrapper = [UIView new];
	UIButton *bottomButton = [UIButton new];
	UIStackView *stack = [UIStackView new];
	
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
	
	framingView.backgroundColor = [UIColor whiteColor];
	framingView.layer.cornerRadius = 16.0;
	
	[closeButton setTitle:@"X" forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];

	titleLabel.numberOfLines = 0;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.9 alpha:1.0];
	titleLabel.font = [UIFont systemFontOfSize:19.0 weight:UIFontWeightBold];
	
	carouselWrapper.backgroundColor = [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0];

	bottomButton.backgroundColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.9 alpha:1.0];
	[bottomButton setTitle:@"Eu quero!" forState:UIControlStateNormal];
	[bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[bottomButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
	
	//[carouselWrapper.heightAnchor constraintEqualToConstant:150.0].active = YES;
	
	titleLabel.text = @"Testing";
	
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
@end
