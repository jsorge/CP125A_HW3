//
//  JMSViewController.m
//  CP125A_HW3
//
//  Created by Jared Sorge on 1/29/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSViewController.h"

@interface JMSViewController ()

@property (weak, nonatomic) IBOutlet UIView *redBox;
@property (weak, nonatomic) IBOutlet UIView *blueBox;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (strong, nonatomic)NSDictionary *viewDictionary;
@property (nonatomic, copy)NSMutableArray *horizontalConstraints;
@property (nonatomic, copy)NSMutableArray *verticalConstraints;
@property (nonatomic)CGFloat padding;

//Red Constraints//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paddingBetweenBoxes;

//Slider//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paddingBetweenSliderAndBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderTrailing;

//Blue Box//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bluBoxTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueBoxLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueBoxVertical;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingBlueAndRedBox;


@end

@implementation JMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.redBox.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueBox.translatesAutoresizingMaskIntoConstraints = NO;
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.padding = 8;
    
    DLog(@"%@", self.view.constraints);
    
    [self.view removeConstraints:@[self.redTop, self.redRight, self.redLeft, self.paddingBetweenBoxes, self.sliderBottom, self.paddingBetweenSliderAndBox, self.sliderTrailing, self.bluBoxTrailing, self.blueBoxLeading, self.blueBoxVertical, self.leadingBlueAndRedBox]];
    
    DLog(@"%@", self.view.constraints);
}

#pragma mark - Properties
- (NSDictionary *)viewDictionary
{
    if (!_viewDictionary) {
        _viewDictionary = @{@"redBox": self.redBox,
                            @"blueBox": self.blueBox,
                            @"slider": self.slider};
    }
    return _viewDictionary;
}

#pragma mark - View Controller Rotation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Constraints
- (void)updateViewConstraints
{
    LogMethod();
    
    [super updateViewConstraints];
    
    if (self.verticalConstraints) {
        [self.view removeConstraints:self.verticalConstraints];
        self.verticalConstraints = nil;
    }
    if (self.horizontalConstraints) {
        [self.view removeConstraints:self.horizontalConstraints];
        self.horizontalConstraints = nil;
    }
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self buildConstraintsForVerticalLayout];
    } else {
        [self buildConstraintsForHorizontalLayout];
    }
    
    [self.view addConstraints:self.horizontalConstraints];
    [self.view addConstraints:self.verticalConstraints];
}

#pragma mark - Private
- (void)buildConstraintsForHorizontalLayout
{
    LogMethod();
    NSMutableArray *newVerticalConstraints = [NSMutableArray array];
    NSMutableArray *newHorizontalConstraints = [NSMutableArray array];
    
    //Horizontal Constraints
    [newHorizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[redBox]-[blueBox]-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:self.viewDictionary]];
    [newHorizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:self.viewDictionary]];
    
    //Vertical Constraints
    [newVerticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[redBox]-[slider]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:self.viewDictionary]];
    [newVerticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[blueBox]-[slider]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:self.viewDictionary]];
    
    DLog(@"%@", newVerticalConstraints);
    DLog(@"%@", newHorizontalConstraints);
    self.horizontalConstraints = newHorizontalConstraints;
    self.verticalConstraints = newVerticalConstraints;
}

- (void)buildConstraintsForVerticalLayout
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider
                                                          attribute:NSLayoutAttributeBaseline
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:0.0f
                                                           constant:0.0f]];
    
    CGFloat boxTotalHeight = self.slider.frame.origin.y - self.redBox.frame.origin.y - (self.padding * 2);
    CGFloat redHeight = boxTotalHeight * self.slider.value;
    CGFloat blueHeight = boxTotalHeight - redHeight;
 
    NSMutableArray *newVerticalConstraints = [NSMutableArray array];
    NSMutableArray *newHorizontalConstraints = [NSMutableArray array];
    
    NSDictionary *metrics = @{@"padding": @(self.padding),
                              @"redHeight": @(redHeight),
                              @"blueHeight": @(blueHeight)};
    
    //Vertical Constraints
    [newVerticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[redBox(redHeight)]-(padding)-[blueBox(blueHeight)]-(padding)-[slider]-|"
                                                                                        options:0
                                                                                        metrics:metrics
                                                                                          views:self.viewDictionary]];
    
    //Horizontal Constraints
    [newHorizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[redBox]-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:self.viewDictionary]];
    [newHorizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[blueBox]-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:self.viewDictionary]];
    [newHorizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[slider]-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:self.viewDictionary]];
    
    DLog(@"%@", newHorizontalConstraints);
    DLog(@"%@", newVerticalConstraints);
    self.horizontalConstraints = newHorizontalConstraints;
    self.verticalConstraints = newVerticalConstraints;
}

- (CGFloat)totalSizeForBoxes
{
    CGFloat totalSize = 0;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        totalSize = self.redBox.bounds.size.width + self.blueBox.bounds.size.width;
    } else {
        totalSize = self.redBox.bounds.size.height + self.blueBox.bounds.size.height;
    }
    
    return totalSize;
}

#pragma mark - IBActions
- (IBAction)changeBoxSize:(id)sender
{
    [self.view setNeedsUpdateConstraints];
}


@end
