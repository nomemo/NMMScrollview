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
    SubviewAlignType_OriAlign,
} NMMSubviewAlignType;

typedef enum : NSUInteger {
    SubViewSizeType_Full,
    SubViewSizeType_Quarter,
    SubViewSizeType_Half,
    SubViewSizeType_ThreeQuarter,
    SubViewSizeType_OriSize,
} NMMSubViewSizeType;

@class NMMAutolayoutScrollView;
@protocol NMMAutolayoutScrollViewDelegate <NSObject>

- (void)scrollView:(NMMAutolayoutScrollView *)scrollView touchSubviewAtIndex:(NSInteger)index;

@end

@interface NMMAutolayoutScrollView : UIScrollView

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) BOOL portraitArrange;

@property (nonatomic, assign) BOOL viewAnimation;

@property (nonatomic, assign) CGFloat defautlPadding;

@property (weak, nonatomic) id<NMMAutolayoutScrollViewDelegate> nmmDelegate;

@property (assign, nonatomic) BOOL showZeroView;

- (UIView *)subViewAtIndex:(NSInteger)index;

#pragma mark - Action

- (void)changeArrangeOrientation;

- (void)insertSubView:(UIView *)newView
              atIndex:(NSInteger)index
            alignType:(NMMSubviewAlignType)alignType
             SizeType:(NMMSubViewSizeType)sizeType
         priorPadding:(CGFloat)distance;

- (void)removeSubViewAtIndex:(NSInteger)index;

- (void)removeAllSubViews;

#pragma mark - Change SubView

- (void)changeDistance:(CGFloat)padding atIndex:(NSInteger)index;

- (void)changeAlign:(NMMSubviewAlignType)algin atIndex:(NSInteger)index;

- (void)changeSize:(NMMSubViewSizeType)sizeType atIndex:(NSInteger)index;

- (void)changeSubViewAlignTo:(NMMSubviewAlignType)alignType;

- (void)changeAllSubViewSize:(NMMSubViewSizeType)sizeType;

#pragma mark - Class method

+ (CGFloat)convertSizeTypeToMultiplier:(NMMSubViewSizeType)sizeType;

+ (NSLayoutAttribute)convertAlignTypeToLayoutAttribute:(NMMSubviewAlignType)alignType portrait:(BOOL)portrait;

@end
