//
//  NMMLayoutConstraintColletion.m
//  ScrollView
//
//  Created by 张珏 on 15/7/19.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "NMMLayoutConstraintColletion.h"

@implementation NMMLayoutConstraintColletion

- (NSArray *)verticalConstraintArray {
    
    NSLayoutConstraint *top = self.topToPriorView ?: self.topToSuperView;
    NSLayoutConstraint *leading = self.leadingToSuperView ?: self.leadingToPriorView;
    
    return @[top,
             leading,
             self.trailing,
             self.height];
}
- (NSArray *)horizonalConstraintArray {
    NSLayoutConstraint *top = self.topToSuperView ?:self.topToPriorView;
    NSLayoutConstraint *leading = self.leadingToPriorView ?: self.leadingToSuperView;

    return @[top,
             leading,
             self.bottom,
             self.width];
}
@end
