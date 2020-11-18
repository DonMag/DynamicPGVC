//
//  SampleContentViewController.m
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import "SampleContentViewController.h"

@interface SampleContentViewController ()
{
	UILabel *titleLabel;
	UILabel *contentLabel;
	UIStackView *stack;
}
@end

@implementation SampleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor whiteColor];
	
	titleLabel = [UILabel new];
	titleLabel.numberOfLines = 0;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	
	contentLabel = [UILabel new];
	contentLabel.numberOfLines = 0;
	
	titleLabel.text = _titleString;
	contentLabel.text = _contentString;

	stack = [UIStackView new];
	stack.translatesAutoresizingMaskIntoConstraints = NO;
	stack.axis = UILayoutConstraintAxisVertical;
	stack.spacing = 12;
	
	[stack addArrangedSubview:titleLabel];
	[stack addArrangedSubview:contentLabel];
	
	[titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	
	[self.view addSubview:stack];
	
	// respect safe area
	UILayoutGuide *g = [self.view safeAreaLayoutGuide];
	
	[NSLayoutConstraint activateConstraints:@[
		
		// inset label 12-pts on all sides
		[stack.topAnchor constraintEqualToAnchor:g.topAnchor constant:12.0],
		[stack.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:12.0],
		[stack.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-12.0],
		[stack.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:-12.0],

	]];

}

@end
