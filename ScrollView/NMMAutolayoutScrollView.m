
//  TPAutolayoutScrollView.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "NMMAutolayoutScrollView.h"
#import "NMMLayoutConstraintColletion.h"

/*
 constraint in array:
 con1, con2 stable side to scrollview
 con3, equal to scrollview height or width.
 con4, define the size of subview.
 con5, define distance from the insertView to the priorView.
 */
@interface NMMAutolayoutScrollView ()

@property (nonatomic, strong) UILabel *zeroView;
@property (nonatomic, strong) NSMutableArray *autoLayoutViews;
@property (nonatomic, strong) NSMutableArray *layoutConstraintCollections;

@end

@implementation NMMAutolayoutScrollView {
    CGFloat verticalContentLength;
    CGFloat horizonalContentLength;
}

#pragma mark - Basic Setup

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureScrollView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureScrollView];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    NSLog(@"%@", self);

    if (self.vertical) {
        self.contentSize = CGSizeMake(self.contentSize.width, verticalContentLength);
    } else {
        self.contentSize = CGSizeMake(horizonalContentLength , self.contentSize.height);
    }
}

- (void)configureScrollView {
    
    NSLog(@"%@", self);
    
    self.backgroundColor = [UIColor clearColor];
    self.bounces = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    verticalContentLength = 0;
    horizonalContentLength = 0;
    self.autoLayoutViews = [NSMutableArray array];
    
    self.backgroundColor = [UIColor blackColor];
    
    [self setupZeroView];
}

//instead of - (void) addSubview:(UIView *)view;
- (void)addSubviewToScroll:(UIView *)view atIndex:(NSInteger)index{
    [self addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    view.translatesAutoresizingMaskIntoConstraints = false;
    [self.autoLayoutViews insertObject:view atIndex:index];
}

#pragma mark Setup Zero View

- (void)setupZeroView {
    self.zeroView = [[UILabel alloc]initWithFrame:CGRectZero];
    self.zeroView.text = @"ZeroView";
    self.zeroView.backgroundColor = [UIColor yellowColor];
    [self.zeroView sizeToFit];
    [self addSubviewToScroll:_zeroView atIndex:0];
    [self addZeroViewConstraint];
    
}

- (void) addZeroViewConstraint {

    CGFloat sizeForView = 100;
    [_zeroView invalidateIntrinsicContentSize];
    
    NSLayoutConstraint *leadingToSuperView = [NSLayoutConstraint constraintWithItem:_zeroView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0];
    
    //Trailing.
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:_zeroView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0];
    
    
    NSLayoutConstraint *topToSuperView = [NSLayoutConstraint constraintWithItem:_zeroView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_zeroView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    
    //New subView Height & Width.
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_zeroView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:sizeForView];
    
    NSLayoutConstraint *width =  [NSLayoutConstraint constraintWithItem:_zeroView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:sizeForView];
    
    NMMLayoutConstraintColletion *colletion = [[NMMLayoutConstraintColletion alloc]init];
    colletion.leadingToSuperView = leadingToSuperView;
    colletion.trailing = trailing;
    colletion.topToSuperView = topToSuperView;
    colletion.bottom = bottom;
    colletion.height = height;
    colletion.width = width;
    
    [self.layoutConstraintCollections addObject:colletion];
    
//    if (self.vertical) {
//        [NSLayoutConstraint activateConstraints:[colletion verticalConstraintArray]];
//    } else {
//        [NSLayoutConstraint activateConstraints:[colletion horizonalConstraintArray]];
//    }
    leadingToSuperView.active = true;
    topToSuperView.active = true;
    trailing.active = true;
    height.active = true;
    
    
}


#pragma mark - Action


- (void)reArrangeSubViews {
    NSInteger count = self.autoLayoutViews.count;
    for (int i = 0; i< count; i++) {
        NMMLayoutConstraintColletion *collection = self.layoutConstraintCollections[i];
        if (self.vertical) {
            [NSLayoutConstraint deactivateConstraints:[collection horizonalConstraintArray]];
            [NSLayoutConstraint activateConstraints:[collection verticalConstraintArray]];
        } else {
            [NSLayoutConstraint activateConstraints:[collection verticalConstraintArray]];
            [NSLayoutConstraint deactivateConstraints:[collection horizonalConstraintArray]];
        }
    }
    [self needsUpdateConstraints];
    [self setNeedsDisplay];
}


#pragma mark - API


- (void)changeDistance:(CGFloat)height toIndex:(NSInteger)index {
    //Not finish.
}

- (void)changeViewHeightTo:(CGFloat)height atIndex:(NSInteger)index {
    //    if (![self checkIndexInBounds:index]) {
    //        return;
    //    };
    //    NSInteger opIndex = [self getRealIndex:index] - 1;
    //
    //    NSArray *cons1 = self.verticalConstraintArray[opIndex];
    //    NSArray *cons2 = self.horizonConstraintArray[opIndex];
    //    if (cons1.count == 5) {
    //        NSLayoutConstraint *con5 = cons1[3];
    //        con5.constant = height;
    //    }
    //    if (cons2.count == 5) {
    //        NSLayoutConstraint *con5 = cons2[3];
    //        con5.constant = height;
    //    }
    //    [self needsUpdateConstraints];
    //    [self setNeedsDisplay];
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

- (void)removeSubViewAtIndex:(NSInteger)index {
    
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
    
    
    NSLog(@"%@", view);
    NSParameterAssert(CGSizeEqualToSize(view.frame.size, CGSizeZero));

    UIView *subview;
    CGFloat padding = distance;
    
    if (!view) {
        return;
    } else {
        subview = view;
    }
    
    NSInteger insertIndex = -1;
    insertIndex = [self getRealIndex:index];
    NMMLayoutConstraintColletion *collection = [self buildSubViewConstraintCollecion:view withPadding:padding atIndex:insertIndex];
    [self.layoutConstraintCollections insertObject:collection atIndex:insertIndex];
    
    [self addSubviewToScroll:view atIndex:index];

    if (self.vertical) {
        [NSLayoutConstraint deactivateConstraints:[collection horizonalConstraintArray]];
        [NSLayoutConstraint activateConstraints:[collection verticalConstraintArray]];
    } else {
        [NSLayoutConstraint deactivateConstraints:[collection verticalConstraintArray]];
        [NSLayoutConstraint activateConstraints:[collection horizonalConstraintArray]];
    }
    
    [self needsUpdateConstraints];
    [self setNeedsDisplay];
}


#pragma mark - Build Constraint


- (NMMLayoutConstraintColletion *) buildSubViewConstraintCollecion:(UIView *)subview
                                                       withPadding:(CGFloat)distance
                                                           atIndex:(NSInteger)index {
    NMMLayoutConstraintColletion *collection = [[NMMLayoutConstraintColletion alloc]init];
    UIView *priorView = self.autoLayoutViews[index-1];
    
    //Size
    NSLayoutConstraint *width= [NSLayoutConstraint constraintWithItem:subview
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:CGRectGetWidth(subview.frame)];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:subview
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:CGRectGetHeight(subview.frame)];
    //Top
    NSLayoutConstraint *topToSuperView = [NSLayoutConstraint constraintWithItem:subview
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:0];
    
    NSLayoutConstraint *topToPriorView = [NSLayoutConstraint constraintWithItem:subview
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:priorView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:distance];
    //Bottom
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:subview
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    //Leading
    NSLayoutConstraint *leadingToPriorView = [NSLayoutConstraint constraintWithItem:subview
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:priorView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0
                                                                       constant:distance];
    
    NSLayoutConstraint *leadingToSuperView = [NSLayoutConstraint constraintWithItem:subview
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    //Trailing.
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:subview
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0 constant:0];
    
    collection.width = width;
    collection.height = height;
    
    collection.topToSuperView = topToSuperView;
    collection.topToPriorView = topToPriorView;
    
    collection.bottom = bottom;
    
    collection.leadingToSuperView = leadingToSuperView;
    collection.leadingToPriorView = leadingToPriorView;
    
    collection.trailing = trailing;
    
    
    
    if (index < self.layoutConstraintCollections.count) {
        NMMLayoutConstraintColletion *trailingConstraint = self.layoutConstraintCollections[index];
        UIView *followView = self.autoLayoutViews[index];
        NSLayoutConstraint *leadingToPrior = [NSLayoutConstraint constraintWithItem:followView
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:subview
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:trailingConstraint.leadingToPriorView.constant];
        
        NSLayoutConstraint *topToPrior = [NSLayoutConstraint constraintWithItem:followView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:subview
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:trailingConstraint.topToPriorView.constant];
        
        trailingConstraint.leadingToPriorView = leadingToPrior;
        trailingConstraint.topToPriorView = topToPrior;
    }
    return collection;
}

- (void)removeConstraintsAtIndex:(NSInteger)index {
    //    if (![self checkIndexInBounds:index]) {
    //        return;
    //    };
    //
    //    if (index < self.autoLayoutViews.count-1) {
    //        UIView *priorView = self.autoLayoutViews[index-1];
    //        UIView *followView = self.autoLayoutViews[index+1];
    //
    //
    //        NSLayoutConstraint *newHorizonalCon5 = nil;
    //
    //        NSMutableArray *followCons1 = self.horizonConstraintArray[index+1];
    //        NSLayoutConstraint *oldHorizonalCon5 = followCons1[4];
    //        newHorizonalCon5 = [NSLayoutConstraint constraintWithItem:priorView
    //                                                        attribute:NSLayoutAttributeTrailing
    //                                                        relatedBy:NSLayoutRelationEqual
    //                                                           toItem:followView
    //                                                        attribute:NSLayoutAttributeLeading
    //                                                       multiplier:1
    //                                                         constant:oldHorizonalCon5.constant];
    //        newHorizonalCon5.active = oldHorizonalCon5.active;
    //        [followCons1 removeLastObject];
    //        [followCons1 addObject:newHorizonalCon5];
    //        NSLayoutConstraint *newVerticalCon5 = nil;
    //
    //
    //        NSMutableArray *followCons2 = self.verticalConstraintArray[index+1];
    //        NSLayoutConstraint *oldVerticalCon5 = followCons2[4];
    //        newVerticalCon5 = [NSLayoutConstraint constraintWithItem:priorView
    //                                                       attribute:NSLayoutAttributeBottom
    //                                                       relatedBy:NSLayoutRelationEqual
    //                                                          toItem:followView
    //                                                       attribute:NSLayoutAttributeTop
    //                                                      multiplier:1
    //                                                        constant:oldVerticalCon5.constant];
    //        newVerticalCon5.active = oldVerticalCon5.active;
    //        [followCons2 removeLastObject];
    //        [followCons2 addObject:newVerticalCon5];
    //        [NSLayoutConstraint deactivateConstraints:@[oldHorizonalCon5, oldVerticalCon5]];
    //    }
    //
    //    NSArray *verticalCons = self.verticalConstraintArray[index];
    //    NSArray *horizonalCons = self.horizonConstraintArray[index];
    //    CGFloat verticalLength = ((NSLayoutConstraint *)[verticalCons lastObject]).constant;
    //    CGFloat horizonalLength = ((NSLayoutConstraint *)[horizonalCons lastObject]).constant;
    //    [NSLayoutConstraint deactivateConstraints:verticalCons];
    //    [NSLayoutConstraint deactivateConstraints:horizonalCons];
    //    [self.horizonConstraintArray removeObjectAtIndex:index];
    //    [self.verticalConstraintArray removeObjectAtIndex:index];
    //
    //
    //    verticalContentLength = verticalContentLength - verticalLength;
    //    horizonalContentLength = horizonalContentLength - horizonalLength;
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


