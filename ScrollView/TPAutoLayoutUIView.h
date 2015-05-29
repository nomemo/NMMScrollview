//
//  TPAutoLayoutUIView.h
//  ScrollView
//
//  Created by 张珏 on 15/5/26.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPAutoLayoutUIView : UIView

@property (strong, nonatomic, readonly) NSMutableArray *autoLayoutSubViews;
@property (assign, nonatomic, readonly) UIEdgeInsets *paddingForSubView;

- (void)insertSubview:(UIView *)view withPadding:(UIEdgeInsets)padding;

@end
