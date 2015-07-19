//
//  NMMLayoutConstraintColletion.h
//  ScrollView
//
//  Created by 张珏 on 15/7/19.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMMLayoutConstraintColletion : NSObject

@property (strong, nonatomic) NSLayoutConstraint *topToSuperView;
@property (strong, nonatomic) NSLayoutConstraint *topToPriorView;

@property (strong, nonatomic) NSLayoutConstraint *leadingToSuperView;
@property (strong, nonatomic) NSLayoutConstraint *leadingToPriorView;

@property (strong, nonatomic) NSLayoutConstraint *bottom;

@property (strong, nonatomic) NSLayoutConstraint *trailing;

@property (strong, nonatomic) NSLayoutConstraint *height;
@property (strong, nonatomic) NSLayoutConstraint *width;



//@property (strong, nonatomic) NSLayoutConstraint *heightToSelf;
//@property (strong, nonatomic) NSLayoutConstraint *heightToSuperView;
//@property (strong, nonatomic) NSLayoutConstraint *widthToSelf;
//@property (strong, nonatomic) NSLayoutConstraint *widthToSuperView;

- (NSArray *)verticalConstraintArray;
- (NSArray *)horizonalConstraintArray;

@end
