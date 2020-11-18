//
//  SampleContentViewController.m
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import "SampleContentViewController.h"

@interface SampleContentViewController ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation SampleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor greenColor];
	
	_label = [UILabel new];
	
	_label.numberOfLines = 0;
	_label.backgroundColor = [UIColor yellowColor];
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	
	_label.text = _contentString;
	
	[self.view addSubview:_label];
	
	// respect safe area
	UILayoutGuide *g = [self.view safeAreaLayoutGuide];
	
	[NSLayoutConstraint activateConstraints:@[
		
		// inset label 12-pts on all sides
		[_label.topAnchor constraintEqualToAnchor:g.topAnchor constant:12.0],
		[_label.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:12.0],
		[_label.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-12.0],
		[_label.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:-12.0],

	]];
	

}

@end
