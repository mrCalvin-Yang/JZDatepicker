//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "JZDatepickerDateView.h"
#import "JZDatepickerCircleView.h"


const CGFloat kJZDatepickerItemWidth = 70.;
const CGFloat kJZDatepickerBackgroundCircleWidth = 35.;


@interface JZDatepickerCell ()

@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *topLabel;
@property (nonatomic, strong) JZDatepickerCircleView *circleView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSLayoutConstraint *circleViewWidthConstraint;

@end


@implementation JZDatepickerCell

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTintColor:[UIColor redColor]];
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    // topLabel
    self.topLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:8.0]];
    
    // dayLabel
    self.dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:10]];
    
    // circleView
    self.circleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.circleViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.circleView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:kJZDatepickerBackgroundCircleWidth];
    [self addConstraint:self.circleViewWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.circleView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.dayLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.dayLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    
}

- (void)prepareForReuse
{
    [self setSelected:NO];
    self.circleView.alpha = 0.0f;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    [self.dateFormatter setDateFormat:@"d"];
    NSString *dayFormattedString = [self.dateFormatter stringFromDate:date];
    
    [self.dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [self.dateFormatter stringFromDate:date];
    
    self.dayLabel.text = dayFormattedString;
    if ( [self isToday:date]) {
        self.topLabel.text = NSLocalizedString(@"today", nil);
        self.topLabel.textColor = self.tintColor;
    } else {
        self.topLabel.text = [dayInWeekFormattedString uppercaseString];
        self.topLabel.textColor = [UIColor colorWithRed:153./255. green:153./255. blue:153./255. alpha:1.];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.circleView.hidden = NO;
    if (highlighted) {
        self.circleView.alpha = self.isSelected ? 1 : .5;
    } else {
        self.circleView.alpha = self.isSelected ? 1 : 0;
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    self.circleViewWidthConstraint.constant = (selected) ? 35 : 0;
//    [UIView animateWithDuration:0.3
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         [self layoutIfNeeded];
//                     } completion:nil];
    self.circleView.alpha = (selected)?1.0f:0.0f;
    self.dayLabel.textColor = (selected)? [UIColor whiteColor] : [UIColor blackColor];
}

#pragma mark - Getters

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        _dayLabel.textColor = [UIColor blackColor];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
    }
    return _topLabel;
}

- (UIView *)circleView
{
    if (!_circleView) {
        _circleView = [[JZDatepickerCircleView alloc] init];
        _circleView.alpha = 0.0f;
        _circleView.backgroundColor = self.tintColor;
        _circleView.opaque = NO;
        [self addSubview:_circleView];
        [self sendSubviewToBack:_circleView];
    }
    
    return _circleView;
}

- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

#pragma mark - Helper Methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
    
    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;
    
    BOOL isWeekdayResult = day == kSunday || day == kSaturday;
    
    return isWeekdayResult;
}

- (BOOL)isToday:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    } else {
        return NO;
    }
}

@end