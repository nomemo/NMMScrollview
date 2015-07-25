//
//  TPAutolayoutScrollView.h
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SubviewAlignType_Center,
    SubviewAlignType_Left,
    SubviewAlignType_Right,
    SubviewAlignType_Custom,
} NMSubviewAlignType;

typedef enum : NSUInteger {
    SubViewSizeType_FULL,
    SubViewSizeType_QUARTER,
    SubViewSizeType_HALF,
    SubViewSizeType_THREEQUARTER,
    SubViewSizeType_SELF,
} NMSubViewSizeType;


@interface NMMAutolayoutScrollView : UIScrollView

@property (nonatomic, assign) NMSubviewAlignType alignType;

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) BOOL portraitArrange;

@property (nonatomic, assign) BOOL viewAnimation;

@property (nonatomic, assign) CGFloat defautlPadding;


#pragma mark - Action

- (void)changeArrangeOrientation;

- (void)insertSubView:(UIView *)newView
              atIndex:(NSInteger)index
            ailgnType:(NMSubviewAlignType)ailgnType
             SizeType:(NMSubViewSizeType)sizeType
         priorPadding:(CGFloat)distance;

- (void)removeSubViewAtIndex:(NSInteger)index;

#pragma mark - Change SubView

- (void)changeSize:(CGSize)size atIndex:(NSInteger)index;

- (void)changeDistance:(CGFloat)padding atIndex:(NSInteger)index;

@end
