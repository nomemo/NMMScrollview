
//  TPAutolayoutScrollView.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "NMMAutolayoutScrollView.h"

@interface NMMSubViewConfiguration : NSObject


@property (strong, nonatomic) UIView *loadView;


@property (assign, nonatomic) CGSize inputSize;
@property (assign, nonatomic) CGFloat padding;

@property (strong, nonatomic) NSLayoutConstraint *landscapeTop;
@property (strong, nonatomic) NSLayoutConstraint *landscapeLeading;
@property (strong, nonatomic) NSLayoutConstraint *landscapeWidth;
@property (strong, nonatomic) NSLayoutConstraint *landscapeHeight;


@property (strong, nonatomic) NSLayoutConstraint *portraitTop;
@property (strong, nonatomic) NSLayoutConstraint *portraitLeading;
@property (strong, nonatomic) NSLayoutConstraint *portraitWidth;
@property (strong, nonatomic) NSLayoutConstraint *portraitHeight;


- (NSArray *)landscapeConstraints;
- (NSArray *)portraitConstraints;

@end


@implementation NMMSubViewConfiguration

- (NSString *)description {
    return [NSString stringWithFormat:@"LoadView %@, ptTop %@, ldLeading %@" , self.loadView, self.portraitTop, self.landscapeLeading];
}

- (NSArray *)landscapeConstraints {
    return @[_landscapeHeight, _landscapeLeading, _landscapeTop , _landscapeWidth];
}
- (NSArray *)portraitConstraints {
    return @[_portraitHeight, _portraitLeading, _portraitTop, _portraitWidth];
}
@end


@interface NMMAutolayoutScrollView ()

@property (nonatomic, strong) NSMutableArray *configurations;

@end

@implementation NMMAutolayoutScrollView {
    CGFloat verticalContentLength;
    CGFloat horizonalContentLength;
    UILabel *zeroView;
    BOOL showZeroView;
}

#pragma mark - Initialize

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

- (void)dealloc {
    zeroView = nil;
    [self.configurations removeAllObjects];
}

- (void)configureScrollView {
    NSLog(@"%@", self);
    self.backgroundColor = [UIColor clearColor];
    self.bounces = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.translatesAutoresizingMaskIntoConstraints = false;
    
    verticalContentLength = 0;
    horizonalContentLength = 0;
    self.configurations = [NSMutableArray array];
    
    self.backgroundColor = [UIColor blackColor];
    
    //NEW.
    self.portraitArrange = true;
    self.viewAnimation = true;
    showZeroView = false;
}


- (void)layoutSubviews {
    if (self.portraitArrange) {
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), verticalContentLength);
    } else {
        self.contentSize = CGSizeMake(horizonalContentLength , CGRectGetHeight(self.frame));
    }
    [super layoutSubviews];
}


- (void)drawRect:(CGRect)rect {
    if (!zeroView) {
        [self setupZeroView];
    }
}

#pragma mark Setup Zero View

- (void)setupZeroView {
    zeroView = [[UILabel alloc]initWithFrame:CGRectZero];
    zeroView.text = @"ZeroView";
    zeroView.backgroundColor = [UIColor yellowColor];
    [zeroView sizeToFit];
    NSLog(@"scorll view frame %@", NSStringFromCGRect(self.frame));
    
    [self addSubview:zeroView];
    [self addZeroViewConstraint];
    
}

- (void) addZeroViewConstraint {
    zeroView.translatesAutoresizingMaskIntoConstraints = false;
    [zeroView invalidateIntrinsicContentSize];
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), NSStringFromCGRect(zeroView.frame));
    
    CGFloat height = CGRectGetHeight(zeroView.frame);
    CGFloat widht = CGRectGetWidth(zeroView.frame);
    if (!showZeroView) {
        height = 0;
        widht = 0;
    }
    
    //Landscape
    NSLayoutConstraint *landscapeTop = [NSLayoutConstraint constraintWithItem:zeroView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0];
    NSLayoutConstraint *landscapeLeading = [NSLayoutConstraint constraintWithItem:zeroView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0
                                                                         constant:0];
    NSLayoutConstraint *landscapeWidth = [NSLayoutConstraint constraintWithItem:zeroView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:widht];
    NSLayoutConstraint *landscapeHeight = [NSLayoutConstraint constraintWithItem:zeroView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:0];

    
    //Portrait
    NSLayoutConstraint *portraitTop = [NSLayoutConstraint constraintWithItem:zeroView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0];
    NSLayoutConstraint *portraitLeading = [NSLayoutConstraint constraintWithItem:zeroView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:0];
    NSLayoutConstraint *portraitWidth = [NSLayoutConstraint constraintWithItem:zeroView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *portraitHeight = [NSLayoutConstraint constraintWithItem:zeroView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:height];
    
    
    NMMSubViewConfiguration *configuration = [[NMMSubViewConfiguration alloc]init];
    configuration.landscapeHeight = landscapeHeight;
    configuration.landscapeLeading = landscapeLeading;
    configuration.landscapeTop = landscapeTop;
    configuration.landscapeWidth = landscapeWidth;
    
    configuration.portraitHeight = portraitHeight;
    configuration.portraitLeading = portraitLeading;
    configuration.portraitTop = portraitTop;
    configuration.portraitWidth = portraitWidth;
    
    configuration.loadView = zeroView;
    
    [self.configurations addObject:configuration];
    
    if (self.portraitArrange) {
        [NSLayoutConstraint activateConstraints:[configuration portraitConstraints]];
    } else {
        [NSLayoutConstraint activateConstraints:[configuration landscapeConstraints]];
    }
}


#pragma mark - Action

- (void)changeSize:(CGSize)size atIndex:(NSInteger)index {
    
}

- (void)changeDistance:(CGFloat)padding atIndex:(NSInteger)index {
    
}

#pragma mark - SrollView Action

- (void)changeArrangeOrientation {
    self.portraitArrange = !self.portraitArrange;
}

- (void)setPortraitArrange:(BOOL)portraitArrange {
    if (_portraitArrange == portraitArrange) {
        return;
    }
    _portraitArrange = portraitArrange;
    self.alwaysBounceVertical = portraitArrange;
    self.alwaysBounceHorizontal = !portraitArrange;
    [self reArrangeSubViews];

}


- (void)reArrangeSubViews {
    NSInteger count = self.configurations.count;
    for (int i = 0; i< count; i++) {
        NMMSubViewConfiguration *collection = self.configurations[i];
        if (self.portraitArrange) {
            [NSLayoutConstraint deactivateConstraints:[collection landscapeConstraints]];
            [NSLayoutConstraint activateConstraints:[collection portraitConstraints]];
        } else {
            [NSLayoutConstraint deactivateConstraints:[collection portraitConstraints]];
            [NSLayoutConstraint activateConstraints:[collection landscapeConstraints]];
        }
    }
    
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    }];
}


- (void)insertSubView:(UIView *)newView
              atIndex:(NSInteger)index
            ailgnType:(NMSubviewAlignType)ailgnType
             SizeType:(NMSubViewSizeType)sizeType
         priorPadding:(CGFloat)distance {

    //Data prepare
    CGFloat height = CGRectGetHeight(newView.frame);
    CGFloat widht = CGRectGetWidth(newView.frame);
    
    NSInteger insertIndex = [self getRealIndex:index];
    [self addSubview:newView];

    NSLog(@"%@: %@ , insertIndex %@", NSStringFromSelector(_cmd), NSStringFromCGRect(newView.frame), @(insertIndex));

    [newView invalidateIntrinsicContentSize];
    [newView setTranslatesAutoresizingMaskIntoConstraints:false];
    NMMSubViewConfiguration *priorConfiguration = self.configurations[insertIndex-1];
    UIView *priorView = priorConfiguration.loadView;
    
    
    
    //Portrait
    NSLayoutConstraint *portraitTop = [NSLayoutConstraint constraintWithItem:newView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:priorView
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:distance];
    NSLayoutConstraint *portraitLeading = [NSLayoutConstraint constraintWithItem:newView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:0];
    NSLayoutConstraint *portraitWidth = [NSLayoutConstraint constraintWithItem:newView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *portraitHeight = [NSLayoutConstraint constraintWithItem:newView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:height];
//    //Landscape
//    NSLayoutConstraint *landscapeTop = [NSLayoutConstraint constraintWithItem:newView
//                                                                    attribute:NSLayoutAttributeTop
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:self
//                                                                    attribute:NSLayoutAttributeTop
//                                                                   multiplier:1.0
//                                                                     constant:0];
//    NSLayoutConstraint *landscapeLeading = [NSLayoutConstraint constraintWithItem:newView
//                                                                        attribute:NSLayoutAttributeLeading
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:priorView
//                                                                        attribute:NSLayoutAttributeTrailing
//                                                                       multiplier:1.0
//                                                                         constant:distance];
//    NSLayoutConstraint *landscapeWidth = [NSLayoutConstraint constraintWithItem:newView
//                                                                      attribute:NSLayoutAttributeWidth
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:nil
//                                                                      attribute:NSLayoutAttributeNotAnAttribute
//                                                                     multiplier:1.0
//                                                                       constant:widht];
//    NSLayoutConstraint *landscapeHeight = [NSLayoutConstraint constraintWithItem:newView
//                                                                       attribute:NSLayoutAttributeHeight
//                                                                       relatedBy:NSLayoutRelationEqual
//                                                                          toItem:self
//                                                                       attribute:NSLayoutAttributeHeight
//                                                                      multiplier:1.0
//                                                                        constant:0];
    
    
    

    
    NMMSubViewConfiguration *colletion = [[NMMSubViewConfiguration alloc]init];
    
    colletion.portraitHeight = portraitHeight;
    colletion.portraitLeading = portraitLeading;
    colletion.portraitTop = portraitTop;
    colletion.portraitWidth = portraitWidth;
    colletion.loadView = newView;
    colletion.padding = distance;
    
//    colletion.landscapeHeight = landscapeHeight;
//    colletion.landscapeLeading = landscapeLeading;
//    colletion.landscapeTop = landscapeTop;
//    colletion.landscapeWidth = landscapeWidth;

    
    [self.configurations insertObject:colletion atIndex:insertIndex];

    if (self.portraitArrange) {
        [NSLayoutConstraint activateConstraints:[colletion portraitConstraints]];
    } else {
        [NSLayoutConstraint activateConstraints:[colletion landscapeConstraints]];
    }

    if (insertIndex < self.configurations.count-1) {
        NMMSubViewConfiguration *trailingConfigureation =  self.configurations[insertIndex];
        
        UIView *trailingViwe = trailingConfigureation.loadView;
        BOOL acitve;
        CGFloat padding;
        //Portrait.
        padding = trailingConfigureation.portraitTop.constant;
        acitve = trailingConfigureation.portraitTop.active;
//        trailingConfigureation.portraitTop.active = false;

        [trailingViwe removeConstraint:trailingConfigureation.portraitTop];
        trailingConfigureation.portraitTop = [NSLayoutConstraint constraintWithItem:trailingViwe
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:newView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1
                                                                           constant:padding];
        trailingConfigureation.portraitTop.active = acitve;

//        //Landscape
//        padding = trailingConfigureation.landscapeLeading.constant;
//        acitve = trailingConfigureation.landscapeLeading.active;
//        
//        trailingConfigureation.landscapeLeading.active = false;
//        trailingConfigureation.landscapeLeading = [NSLayoutConstraint constraintWithItem:trailingViwe
//                                                                               attribute:NSLayoutAttributeLeading
//                                                                               relatedBy:NSLayoutRelationEqual
//                                                                                  toItem:newView
//                                                                               attribute:NSLayoutAttributeTrailing
//                                                                              multiplier:1.0
//                                                                                constant:padding];
//        trailingConfigureation.landscapeLeading.active = acitve;

        
        NSLog(@"newView %@", newView.constraints);
        NSLog(@"trailingView %@", trailingViwe.constraints);
    }
    
    
    
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    }];

    

}

- (void)removeSubViewAtIndex:(NSInteger)index {
    
}
#pragma mark - Utilize.

- (BOOL)checkIndexInBounds:(NSInteger)index {
    if (index < 1 || index > self.configurations.count) {
        NSLog(@"Not in range");
        return false;
    }
    return true;
}

- (NSInteger)getRealIndex:(NSInteger)index {
    NSInteger insertIndex;
    if (index <= 0) {
        insertIndex = 1;
    } else if(index >= self.configurations.count) {
        insertIndex = self.configurations.count;
    } else {
        insertIndex = index+1;
    }
    return insertIndex;
}


@end



