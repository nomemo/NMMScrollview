//
//  TPAutolayoutScrollView.h
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPAutolayoutScrollView : UIScrollView

@property (nonatomic, strong, readonly) NSMutableArray *autoLayoutViews;

@property (nonatomic, assign) BOOL vertical;

- (void)insertSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance atIndex:(NSInteger)index;

- (void)addSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance;


- (void)removeSubViewAtIndex:(NSInteger)index;

- (void)reArrangeSubViews;

- (void)changeViewHeightTo:(CGFloat)height atIndex:(NSInteger)index;

- (void)changeDistance:(CGFloat)height toIndex:(NSInteger)index;


@end
