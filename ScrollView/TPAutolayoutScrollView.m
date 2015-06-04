
//  TPAutolayoutScrollView.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPAutolayoutScrollView.h"

/*
 constraint in array:
 con1, con2 stable side to scrollview
 con3, equal to scrollview height or width.
 con4, define the size of subview.
 con5, define distance from the insertView to the priorView.
 */
@interface TPAutolayoutScrollView ()

@property (nonatomic, strong) UILabel *zeroView;
@property (nonatomic, strong) NSMutableArray *autoLayoutViews;
@property (nonatomic, strong) NSMutableArray *horizonConstraintArray;
@property (nonatomic, strong) NSMutableArray *verticalConstraintArray;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) CGFloat verticalContentLength;
@property (nonatomic, assign) CGFloat horizonContentLength;

@end

@implementation TPAutolayoutScrollView

#pragma mark - Basic Setup

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
  
  [self setupZeroView];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setupScrollView];
}


- (void)reArrangeSubViews {
  NSInteger count = self.autoLayoutViews.count;
  for (int i = 0; i< count; i++) {
    NSArray *verticalCons = self.verticalConstraintArray[i];
    NSArray *horizonalCnos = self.horizonConstraintArray[i];
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


#pragma mark - API


- (void)changeDistance:(CGFloat)height toIndex:(NSInteger)index {
  //Not finish.
}

-(void)changeViewHeightTo:(CGFloat)height atIndex:(NSInteger)index {
  if (![self checkIndexInBounds:index]) {
    return;
  };
  NSInteger opIndex = [self getRealIndex:index] - 1;
  
  NSArray *cons1 = self.verticalConstraintArray[opIndex];
  NSArray *cons2 = self.horizonConstraintArray[opIndex];
  if (cons1.count == 5) {
    NSLayoutConstraint *con5 = cons1[3];
    con5.constant = height;
  }
  if (cons2.count == 5) {
    NSLayoutConstraint *con5 = cons2[3];
    con5.constant = height;
  }
  [self needsUpdateConstraints];
  [self setNeedsDisplay];
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

-(void)removeSubViewAtIndex:(NSInteger)index {
  
  NSInteger opIndex = [self getRealIndex:index]-1;
  [self removeConstraintsAtIndex:opIndex];
  UIView *removeView =   self.autoLayoutViews[opIndex];
  [removeView removeFromSuperview];
  [self.autoLayoutViews removeObjectAtIndex:opIndex];
  [self needsUpdateConstraints];
  [self setNeedsDisplay];
}


- (void)addSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance {
  [self insertSubview:view withDistanceFromLastViews:distance atIndex:self.autoLayoutViews.count];
}


- (void)insertSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance atIndex:(NSInteger)index {
  NSInteger insertIndex = 1;
  UIView *subview;
  CGFloat padding = distance;
  
  if (!view) {
    return;
  } else {
    subview = view;
  }
  
  insertIndex = [self getRealIndex:index];
  
  [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:subview];
  
  [self addSubViewHorizonalMoveConstraint:subview withPadding:padding atIndex:insertIndex];
  [self addSubViewVerticalMoveConstraint:subview withPadding:padding atIndex:insertIndex];
  
  [self.autoLayoutViews insertObject:subview atIndex:insertIndex];
  [self needsUpdateConstraints];
  [self setNeedsDisplay];
}


#pragma mark - Build Constraint


- (void)removeConstraintsAtIndex:(NSInteger)index {
  if (![self checkIndexInBounds:index]) {
    return;
  };
  
  if (index < self.autoLayoutViews.count-1) {
    UIView *priorView = self.autoLayoutViews[index-1];
    UIView *followView = self.autoLayoutViews[index+1];
    
    
    NSLayoutConstraint *newHorizonalCon5 = nil;

    NSMutableArray *followCons1 = self.horizonConstraintArray[index+1];
    NSLayoutConstraint *oldHorizonalCon5 = followCons1[4];
    newHorizonalCon5 = [NSLayoutConstraint constraintWithItem:priorView
                                                    attribute:NSLayoutAttributeTrailing
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:followView
                                                    attribute:NSLayoutAttributeLeading
                                                   multiplier:1
                                                     constant:oldHorizonalCon5.constant];
    newHorizonalCon5.active = oldHorizonalCon5.active;
    [followCons1 removeLastObject];
    [followCons1 addObject:newHorizonalCon5];
    NSLayoutConstraint *newVerticalCon5 = nil;

    
    NSMutableArray *followCons2 = self.verticalConstraintArray[index+1];
    NSLayoutConstraint *oldVerticalCon5 = followCons2[4];
    newVerticalCon5 = [NSLayoutConstraint constraintWithItem:priorView
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:followView
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1
                                                    constant:oldVerticalCon5.constant];
    newVerticalCon5.active = oldVerticalCon5.active;
    [followCons2 removeLastObject];
    [followCons2 addObject:newVerticalCon5];
    [NSLayoutConstraint deactivateConstraints:@[oldHorizonalCon5, oldVerticalCon5]];
  }
  
  NSArray *verticalCons = self.verticalConstraintArray[index];
  NSArray *horizonalCons = self.horizonConstraintArray[index];
  CGFloat verticalLength = ((NSLayoutConstraint *)[verticalCons lastObject]).constant;
  CGFloat horizonalLength = ((NSLayoutConstraint *)[horizonalCons lastObject]).constant;
  [NSLayoutConstraint deactivateConstraints:verticalCons];
  [NSLayoutConstraint deactivateConstraints:horizonalCons];
  [self.horizonConstraintArray removeObjectAtIndex:index];
  [self.verticalConstraintArray removeObjectAtIndex:index];
  
  
  self.verticalContentLength = self.verticalContentLength - verticalLength;
  self.horizonContentLength = self.horizonContentLength - horizonalLength;

}

- (void)addSubViewHorizonalMoveConstraint:(UIView *)subview withPadding:(CGFloat)distance atIndex:(NSInteger)index{
  
  if (![self checkIndexInBounds:index]) {
    return;
  };
  
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
  //The size of the subview.
  NSLayoutConstraint *con4= [NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:subview.frame.size.width];
  
  UIView *priorView = self.autoLayoutViews[index-1];
  NSLayoutConstraint *con5 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:priorView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:distance];
  //  NSLog(@"priorView is %@", priorView);
  
  if (index < self.horizonConstraintArray.count) {
    NSMutableArray *followViewConstraint = self.horizonConstraintArray[index];
    NSLayoutConstraint *followViewCon5 = [followViewConstraint lastObject];
    UIView *followView = followViewCon5.firstItem;
    //    NSLog(@"followView is %@,\n followViewCon5 %@",followView, followViewCon5);
    NSLayoutConstraint *newfollowCon5 = [NSLayoutConstraint constraintWithItem:followViewCon5.firstItem
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:subview
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:followViewCon5.constant];
    newfollowCon5.active = followViewCon5.active;
    followViewCon5.active = false;
    [followView removeConstraint:followViewCon5];
    [followViewConstraint removeObject:followViewCon5];
    [followViewConstraint addObject:newfollowCon5];
  }
  
  BOOL activeForTest = !self.vertical;
  con1.active = activeForTest;
  con2.active = activeForTest;
  con3.active = activeForTest;
  con4.active = activeForTest;
  con5.active = activeForTest;
  
  NSMutableArray *cons = [NSMutableArray arrayWithObjects:con1, con2, con3, con4, con5, nil];
  [self.horizonConstraintArray insertObject:cons atIndex:index];
  self.horizonContentLength = subview.frame.size.width + self.horizonContentLength + distance;
}

- (void)addSubViewVerticalMoveConstraint:(UIView *)subview withPadding:(CGFloat)distance atIndex:(NSInteger)index{
  
  if (![self checkIndexInBounds:index]) {
    return;
  };
  
  
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
  
  NSLayoutConstraint *con3 =  [NSLayoutConstraint constraintWithItem:subview
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0];
  
  //The size of the subview.
  NSLayoutConstraint *con4 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:subview.frame.size.height];
  
  
  
  
  UIView *priorView = self.autoLayoutViews[index-1];
  NSLayoutConstraint *con5 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:priorView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:distance];
  
  if (index < self.verticalConstraintArray.count) {
    NSMutableArray *followViewConstraint = self.verticalConstraintArray[index];
    NSLayoutConstraint *followViewCon5 = [followViewConstraint lastObject];
    UIView *followView = followViewCon5.firstItem;
    NSLayoutConstraint *newfollowCon5 = [NSLayoutConstraint constraintWithItem:followViewCon5.firstItem
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:subview
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:followViewCon5.constant];
    newfollowCon5.active = followViewCon5.active;
    followViewCon5.active = false;
    [followView removeConstraint:followViewCon5];
    [followViewConstraint removeObject:followViewCon5];
    [followViewConstraint addObject:newfollowCon5];
  }
  
  BOOL activeForTest = self.vertical;
  con1.active = activeForTest;
  con2.active = activeForTest;
  con3.active = activeForTest;
  con4.active = activeForTest;
  con5.active = activeForTest;
  
  NSMutableArray *cons = [NSMutableArray arrayWithObjects:con1, con2, con3, con4, con5, nil];
  [self.verticalConstraintArray insertObject:cons atIndex:index];
  self.verticalContentLength = subview.frame.size.height + self.verticalContentLength + distance;
}


#pragma mark Zero

- (void)setupZeroView {
  self.zeroView = [[UILabel alloc]initWithFrame:CGRectZero];
  self.zeroView.translatesAutoresizingMaskIntoConstraints = false;
  [self addSubview:self.zeroView];
  self.zeroView.text = @"ZeroView";
  
  [self addZeroViewHorizonalMoveConstraint];
  [self addZeroViewVerticalMoveConstraint];
  
  [self.autoLayoutViews addObject:self.zeroView];
}

- (void)addZeroViewVerticalMoveConstraint{
  
  UIView *subview = self.zeroView;
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
  
  NSLayoutConstraint *con5 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0];
  
  BOOL activeForTest = self.vertical;
  con1.active = activeForTest;
  con2.active = activeForTest;
  con3.active = activeForTest;
  con4.active = activeForTest;
  con5.active = activeForTest;
  
  NSMutableArray *cons = [NSMutableArray arrayWithObjects:con1, con2, con3, con4, con5, nil];
  [self.verticalConstraintArray addObject:cons];
}

- (void)addZeroViewHorizonalMoveConstraint{
  UIView *subview = self.zeroView;
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
  
  NSLayoutConstraint *con5 = [NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0];
  
  BOOL activeForTest = !self.vertical;
  con1.active = activeForTest;
  con2.active = activeForTest;
  con3.active = activeForTest;
  con4.active = activeForTest;
  con5.active = activeForTest;
  
  NSMutableArray *cons = [NSMutableArray arrayWithObjects:con1, con2, con3, con4, con5, nil];
  [self.horizonConstraintArray addObject:cons];
  
}


#pragma mark - Index check.

- (BOOL)checkIndexInBounds:(NSInteger)index {
  if (index < 1 || index > self.autoLayoutViews.count) {
    NSLog(@"Not in range");
    return false;
  }
  return true;
}

- (NSInteger)getRealIndex:(NSInteger)index {
  NSInteger insertIndex;
  if (index <= 0) {
    insertIndex = 1;
  } else if(index >= self.autoLayoutViews.count) {
    insertIndex = self.autoLayoutViews.count;
  } else {
    insertIndex = index+1;
  }
  return insertIndex;
}


@end


