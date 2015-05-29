//
//  TPAutoLayoutUIView.m
//  ScrollView
//
//  Created by 张珏 on 15/5/26.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPAutoLayoutUIView.h"
#define kDistance 20.0


@implementation UIView(AA)

- (void)pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute
{
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                   attribute:attribute
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:subview
                                                   attribute:attribute
                                                  multiplier:1.0f
                                                    constant:0.0f]];
}

- (void)pinAllEdgesOfSubview:(UIView *)subview
{
  [self pinSubview:subview toEdge:NSLayoutAttributeBottom];
  [self pinSubview:subview toEdge:NSLayoutAttributeTop];
  [self pinSubview:subview toEdge:NSLayoutAttributeLeading];
  [self pinSubview:subview toEdge:NSLayoutAttributeTrailing];
}


@end

@interface TPAutoLayoutUIView ()

@property (strong, nonatomic) NSMutableArray *autoLayoutSubViews;
@property (assign, nonatomic) UIEdgeInsets *paddingForSubView;
@property (weak, nonatomic) UIView *lastInsertView;


//@property (strong, nonatomic) UIView *containerView;

@end

@implementation TPAutoLayoutUIView

- (instancetype)init {
  if (self = [super init]) {
    [self setupBaiscProperty];
  }
  return self;
}

-(void)awakeFromNib {
  [super awakeFromNib];
  [self setupBaiscProperty];
}

- (void)setupBaiscProperty {
  self.backgroundColor = [UIColor yellowColor];
  self.lastInsertView = nil;
  self.autoLayoutSubViews = [NSMutableArray array];
  self.translatesAutoresizingMaskIntoConstraints = false;
  
}


- (void)insertSubview:(UIView *)view withPadding:(UIEdgeInsets)padding {
  if (view == nil) {
    return;
  }
  
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:view];
  
//  [NSLayoutConstraint constraintWithItem:view
//                               attribute:NSLayoutAttributeLeading
//                               relatedBy:NSLayoutRelationEqual
//                                  toItem:self
//                               attribute:NSLayoutAttributeLeading
//                              multiplier:1.0
//                                constant:10].active = true;
//  
//  [NSLayoutConstraint constraintWithItem:self
//                               attribute:NSLayoutAttributeTrailing
//                               relatedBy:NSLayoutRelationEqual
//                                  toItem:view
//                               attribute:NSLayoutAttributeTrailing
//                              multiplier:1.0
//                                constant:10].active = true;
  
  [NSLayoutConstraint constraintWithItem:view
                               attribute:NSLayoutAttributeHeight
                               relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                               attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                                constant:view.frame.size.height].active = true;

  [NSLayoutConstraint constraintWithItem:view
                               attribute:NSLayoutAttributeWidth
                               relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                               attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                                constant:150].active = true;

  
  
  if (self.autoLayoutSubViews.count == 0) {
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:10].active = true;
  } else {
    UIView *lastView = [self.autoLayoutSubViews lastObject];
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:lastView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:10].active = true;
  }
  [self.autoLayoutSubViews addObject:view];
  [self needsUpdateConstraints];
}




@end
