
//  TPAutolayoutScrollView.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPAutolayoutScrollView.h"

@interface TPAutolayoutScrollView ()

@property (nonatomic, strong) NSMutableArray *autoLayoutViews;
@property (nonatomic, strong) NSMutableArray *paddings;
@property (nonatomic, strong) NSMutableArray *horizonConstraintArray;
@property (nonatomic, strong) NSMutableArray *verticalConstraintArray;

@property (nonatomic, assign) UIEdgeInsets subViewInset;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) CGFloat verticalContentLength;
@property (nonatomic, assign) CGFloat horizonContentLength;

@end

@implementation TPAutolayoutScrollView


-(void)removeSubViewAtIndex:(NSInteger)index {
  if (index > self.autoLayoutViews.count || index < 0) {
    return;
  }
}

- (void)insertSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance atIndex:(NSInteger)index {
  
  NSInteger insertIndex = 0;
  UIView *subview;
  CGFloat padding = distance;
  
  if (!view) {
    return;
  } else {
    subview = view;
  }
  
  if (index < 0) {
    insertIndex = 0;
  } else if(index > self.autoLayoutViews.count) {
    insertIndex = self.autoLayoutViews.count;
  } else {
    insertIndex = index;
  }
  
  
  [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:subview];

  
  //  [self addSubViewVerticalMoveConstraint:subview withPadding:padding];
  [self addSubViewHorizonalMoveConstraint:subview withPadding:padding withIndex:index];
  
  
  [self.paddings insertObject:@(padding) atIndex:index];
  [self.autoLayoutViews insertObject:subview atIndex:index];
  
  
  [self needsUpdateConstraints];
  [self setNeedsDisplay];

  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupScrollView];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.vertical) {
    self.contentSize = CGSizeMake(self.contentSize.width, self.verticalContentLength);
  } else {
    self.contentSize = CGSizeMake(self.horizonContentLength , self.contentSize.height);
  }
}

- (void)setupScrollView {
  self.backgroundColor = [UIColor clearColor];
  self.bounces = YES;
  self.showsVerticalScrollIndicator = NO;
  self.showsHorizontalScrollIndicator = NO;
  
  
  self.verticalContentLength = 0;
  self.horizonContentLength = 0;
  self.autoLayoutViews = [NSMutableArray array];
  self.verticalConstraintArray = [NSMutableArray array];
  self.horizonConstraintArray = [NSMutableArray array];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setupScrollView];
}


- (void)insertSubView:(UIView *)subview withDistanceFromLastView:(CGFloat)padding{
  
//  if (subview == nil) {
//    return;
//  }
//
//  [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
//  [self addSubview:subview];
//  if (self.vertical) {
//  } else {
//  }
//  [self addSubViewVerticalMoveConstraint:subview withPadding:padding];
//  [self addSubViewHorizonalMoveConstraint:subview withPadding:padding];
//
//  
//  [self.paddings addObject:@(padding)];
//  [self.autoLayoutViews addObject:subview];
//  
//  [self needsUpdateConstraints];
//  [self setNeedsDisplay];
  
  
}

- (void)setVertical:(BOOL)vertical {
  if (_vertical == vertical) {
    return;
  }
  
  _vertical = vertical;
  self.alwaysBounceVertical = vertical;
  self.alwaysBounceHorizontal = !vertical;
  
  if (self.autoLayoutViews.count) {
    //FIXME: Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
    [self reArrangeSubViews];
  }
}

- (void)reArrangeSubViews {
  
  int count = self.autoLayoutViews.count;
  
  for (int i = 0; i< count; i++) {
    NSArray *verticalCons = self.verticalConstraintArray[i];
    NSArray *horizonalCnos = self.horizonConstraintArray[i];
//    UIView *subView = self.autoLayoutSubViews[i];
    if (self.vertical) {
      [NSLayoutConstraint deactivateConstraints:horizonalCnos];
      [NSLayoutConstraint activateConstraints:verticalCons];
    } else {
      [NSLayoutConstraint activateConstraints:horizonalCnos];
      [NSLayoutConstraint deactivateConstraints:verticalCons];
    }
  }

  
  [self needsUpdateConstraints];
  [self setNeedsDisplay];
  
}


- (void)addSubViewHorizonalMoveConstraint:(UIView *)subview withPadding:(CGFloat)distance withIndex:(NSInteger)index{
  
  //Top.
  NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0];
  
  //Bottom.
  NSLayoutConstraint *con2 = [NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:subview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0];
  
  
  //New subView Height & Width.
  NSLayoutConstraint *con3 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0];
  
  NSLayoutConstraint *con4= [NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:subview.frame.size.width];
  
  
  
  NSLayoutConstraint *con5 = nil;
//  UIView *lastView = [self.autoLayoutViews lastObject];
  
  
  UIView *priorView = nil;
  UIView *followView = nil;
  if (index == 0) {
    priorView = self;
    followView = [self.autoLayoutViews firstObject];
  
  
  } else if (index == self.autoLayoutViews.count) {
    
    priorView = [self.autoLayoutViews lastObject];
    
    
    
    
  } else {
  
    priorView = self.autoLayoutViews[index -1];
    followView = self.autoLayoutViews[index];
  
  }
  
  //Fisrt One
  if (followView == nil) {
    
    con5 = [NSLayoutConstraint constraintWithItem:subview
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1.0
                                         constant:distance];
  //Last One
  } else {
    
    con5 = [NSLayoutConstraint constraintWithItem:subview
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:followView
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1.0
                                         constant:distance];
  }
  
  
  
  
  
  
  
  
  BOOL activeForTest = !self.vertical;
  con1.active = activeForTest;
  con2.active = activeForTest;
  con3.active = activeForTest;
  con4.active = activeForTest;
  con5.active = activeForTest;
  
  NSArray *cons = @[con1, con2, con3, con4, con5];
  [self.horizonConstraintArray addObject:cons];
  self.horizonContentLength = subview.frame.size.width + self.horizonContentLength + distance;

}

- (void)addSubViewVerticalMoveConstraint:(UIView *)subview withPadding:(CGFloat)distance{
  
  //Leading.
  NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:subview
                               attribute:NSLayoutAttributeLeading
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self
                               attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                                constant:0];
  
  //Trailing.
  NSLayoutConstraint *con2 = [NSLayoutConstraint constraintWithItem:self
                               attribute:NSLayoutAttributeTrailing
                               relatedBy:NSLayoutRelationEqual
                                  toItem:subview
                               attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                                constant:0];
  
  //New subView Height & Width.
  NSLayoutConstraint *con3 = [NSLayoutConstraint constraintWithItem:subview
                               attribute:NSLayoutAttributeHeight
                               relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                               attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                                constant:subview.frame.size.height];
  

  
  NSLayoutConstraint *con4 =  [NSLayoutConstraint constraintWithItem:subview
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1
                                                                constant:0];
  
  UIView *lastView = [self.autoLayoutViews lastObject];
  
  
  NSLayoutConstraint *con5 = nil;
  if (lastView == nil) {
    con5 = [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:distance];
  } else {
    con5 = [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:lastView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:distance];
  }
  
  BOOL activeForTest = self.vertical;
  con1.active = activeForTest;
  con2.active = activeForTest;
  con3.active = activeForTest;
  con4.active = activeForTest;
  con5.active = activeForTest;

  NSArray *cons = @[con1, con2, con3, con4, con5];
  [self.verticalConstraintArray addObject:cons];
  self.verticalContentLength = subview.frame.size.height + self.verticalContentLength + distance;
}


@end


