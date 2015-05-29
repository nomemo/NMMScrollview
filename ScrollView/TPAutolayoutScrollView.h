//
//  TPAutolayoutScrollView.h
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPAutolayoutScrollView : UIScrollView

@property (nonatomic, strong, readonly) NSMutableArray *subViews;

@property (nonatomic, assign) BOOL vertical;

- (void)insertSubView:(UIView *)subview withDistanceFromLastView:(CGFloat)distance;

- (void)removeSubViewAtIndex:(NSInteger)index;

- (void)reArrangeSubViews;

@end
