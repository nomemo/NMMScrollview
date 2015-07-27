
//  TPAutolayoutScrollView.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "NMMAutolayoutScrollView.h"


static NSString * const kNMMAlignTypeChange = @"kNMMAlignTypeChange";
static NSString * const kNMMSizeTypeChange = @"kNMMSizeTypeChange";

@interface NMMSubViewConfiguration : NSObject

@property (strong, nonatomic) UIView *loadView;
@property (assign, nonatomic) NMMSubviewAlignType orialignType;
@property (assign, nonatomic) NMMSubViewSizeType oriSizeType;

@property (strong, nonatomic) NSLayoutConstraint *landscapeAlign;
@property (strong, nonatomic) NSLayoutConstraint *landscapeLeading;
@property (strong, nonatomic) NSLayoutConstraint *landscapeWidth;
@property (strong, nonatomic) NSLayoutConstraint *landscapeHeight;


@property (strong, nonatomic) NSLayoutConstraint *portraitTop;
@property (strong, nonatomic) NSLayoutConstraint *portraitAlign;
@property (strong, nonatomic) NSLayoutConstraint *portraitWidth;
@property (strong, nonatomic) NSLayoutConstraint *portraitHeight;

//Only for zero.
@property (nonatomic, strong) NSLayoutConstraint *constraintForZeroPotraitTrailing;
@property (nonatomic, strong) NSLayoutConstraint *constraintForZeroLandscapeBottom;

- (NSArray *)landscapeConstraints;
- (NSArray *)portraitConstraints;

@end

@implementation NMMSubViewConfiguration

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(changeAlignConstraint:) name:kNMMAlignTypeChange object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(changeSizeConstraint:) name:kNMMSizeTypeChange object:nil];
    }
    return self;
}

- (void)changeAlignConstraint:(NSNotification *)noti {
    
    if (self.constraintForZeroPotraitTrailing) {
        return;
    }
    if (self.constraintForZeroLandscapeBottom) {
        return;
    }
    
    id obj = [noti object];
    NMMSubviewAlignType alignType = [obj integerValue];
    if (alignType == SubviewAlignType_OriAlign) {
        alignType = self.orialignType;
    }
    NSLayoutAttribute portraitAlignAttr = [NMMAutolayoutScrollView convertAlignTypeToLayoutAttribute:alignType portrait:true];
    NSLayoutAttribute landscapeAlignAttr = [NMMAutolayoutScrollView convertAlignTypeToLayoutAttribute:alignType portrait:false];
    
    UIView *firstView = self.portraitAlign.firstItem;
    UIView *secondView = self.portraitAlign.secondItem;
    BOOL active = self.portraitAlign.active;
    
    self.portraitAlign.active = false;
    self.landscapeAlign.active = false;

    NSLayoutConstraint *portraitAlign = [NSLayoutConstraint constraintWithItem:firstView
                                                                     attribute:portraitAlignAttr
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:secondView
                                                                     attribute:portraitAlignAttr
                                                                    multiplier:1.0
                                                                      constant:0];
    self.portraitAlign = portraitAlign;
    self.portraitAlign.active = active;
    
    
    NSLayoutConstraint *landscapeAlign = [NSLayoutConstraint constraintWithItem:firstView
                                                                      attribute:landscapeAlignAttr
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:secondView
                                                                      attribute:landscapeAlignAttr
                                                                     multiplier:1.0
                                                                       constant:0];
    self.landscapeAlign = landscapeAlign;
    self.landscapeAlign.active = !active;
    
}

- (void)changeSizeConstraint:(NSNotification *)noti {
    id obj = [noti object];
    NMMSubViewSizeType sizeType = [obj integerValue];
    if (sizeType == SubViewSizeType_OriSize) {
        sizeType = self.oriSizeType;
    }
    CGFloat multipler = [NMMAutolayoutScrollView convertSizeTypeToMultiplier:sizeType];
    
    UIView *firstView = self.landscapeHeight.firstItem;
    UIView *secondView = self.landscapeHeight.secondItem;
    BOOL active = self.landscapeHeight.active;
    
    self.landscapeHeight.active = false;
    self.portraitWidth.active = false;
    
    self.landscapeHeight = [NSLayoutConstraint constraintWithItem:firstView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:secondView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:multipler
                                                         constant:0];
    self.portraitWidth = [NSLayoutConstraint constraintWithItem:firstView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:secondView
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:multipler
                                                       constant:0];
    self.landscapeHeight.active = active;
    self.portraitWidth.active = !active;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LoadView %@, ptTop %@, ldLeading %@" , self.loadView, self.portraitTop, self.landscapeLeading];
}

- (NSArray *)landscapeConstraints {
    if (_constraintForZeroLandscapeBottom) {
        return @[_landscapeHeight, _landscapeLeading, _landscapeAlign , _landscapeWidth, _constraintForZeroLandscapeBottom];
    }
    return @[_landscapeHeight, _landscapeLeading, _landscapeAlign , _landscapeWidth];
}
- (NSArray *)portraitConstraints {
    if (_constraintForZeroPotraitTrailing) {
        return @[_portraitHeight, _portraitAlign, _portraitTop, _portraitWidth, _constraintForZeroPotraitTrailing];
    }
    return @[_portraitHeight, _portraitAlign, _portraitTop, _portraitWidth];
}
@end


@interface NMMAutolayoutScrollView ()

@property (nonatomic, strong) NSMutableArray *configurations;

@end

@implementation NMMAutolayoutScrollView {
    CGFloat portriatContentLength;
    CGFloat landscapeContentLength;
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
    
    portriatContentLength = 0;
    landscapeContentLength = 0;
    self.configurations = [NSMutableArray array];
    
    self.backgroundColor = [UIColor blackColor];
    
    //NEW.
    self.portraitArrange = true;
    self.viewAnimation = true;
    showZeroView = false;
}


- (void)layoutSubviews {
    if (self.portraitArrange) {
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), portriatContentLength);
    } else {
        self.contentSize = CGSizeMake(landscapeContentLength , CGRectGetHeight(self.frame));
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
    
    NSLayoutConstraint *landscapeBottom = [NSLayoutConstraint constraintWithItem:zeroView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
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
    NSLayoutConstraint *portraitTrailing = [NSLayoutConstraint constraintWithItem:zeroView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTrailing
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
    configuration.landscapeWidth = landscapeWidth;
    
    configuration.landscapeAlign = landscapeTop;
    configuration.constraintForZeroLandscapeBottom = landscapeBottom;
    
    
    configuration.portraitHeight = portraitHeight;
    configuration.portraitTop = portraitTop;
    configuration.portraitWidth = portraitWidth;
    
    configuration.portraitAlign = portraitLeading;
    configuration.constraintForZeroPotraitTrailing= portraitTrailing;
    
    
    configuration.loadView = zeroView;
    
    [self.configurations addObject:configuration];
    
    if (self.portraitArrange) {
        [NSLayoutConstraint activateConstraints:[configuration portraitConstraints]];
    } else {
        [NSLayoutConstraint activateConstraints:[configuration landscapeConstraints]];
    }
}


#pragma mark - Action

- (UIView *)subViewAtIndex:(NSInteger)index {
    NSInteger fetchIndex = [self getRealIndex:index];
    NMMSubViewConfiguration *configuration = self.configurations[fetchIndex];
    return configuration.loadView;
}

- (void)changeSize:(NMMSubViewSizeType)sizeType atIndex:(NSInteger)index {
    
}

- (void)changeDistance:(CGFloat)padding atIndex:(NSInteger)index {
    
}

- (void)changeSubViewAlignTo:(NMMSubviewAlignType)alignType {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNMMAlignTypeChange object:@(alignType)];
}

- (void)changeAllSubViewSize:(NMMSubViewSizeType)size {
    if (self.viewAnimation) {
        //FIXME: no animation.
        for (NMMSubViewConfiguration *configuration in self.configurations) {
            [self changeConfiguration:configuration sizeType:size asNewValue:false];
        }
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.25f animations:^{
            [self layoutIfNeeded];
        }];
        
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNMMSizeTypeChange object:@(size)];
    }
}


- (void)changeConfiguration:(NMMSubViewConfiguration *)configuration sizeType:(NMMSubViewSizeType)type asNewValue:(BOOL)asNewValue {
    NMMSubViewSizeType sizeType = type;
    if (sizeType == SubViewSizeType_OriSize) {
        sizeType = configuration.oriSizeType;
    }
    CGFloat multipler = [NMMAutolayoutScrollView convertSizeTypeToMultiplier:sizeType];
    
    UIView *firstView = configuration.landscapeHeight.firstItem;
    UIView *secondView = configuration.landscapeHeight.secondItem;
    BOOL active = configuration.landscapeHeight.active;
    
    configuration.landscapeHeight.active = false;
    configuration.portraitWidth.active = false;
    
    configuration.landscapeHeight = [NSLayoutConstraint constraintWithItem:firstView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondView
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:multipler
                                                                  constant:0];
    configuration.portraitWidth = [NSLayoutConstraint constraintWithItem:firstView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:secondView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:multipler
                                                                constant:0];
    configuration.landscapeHeight.active = active;
    configuration.portraitWidth.active = !active;
    if (asNewValue) {
        configuration.oriSizeType = type;
    }
    
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
            alignType:(NMMSubviewAlignType)alignType
             SizeType:(NMMSubViewSizeType)sizeType
         priorPadding:(CGFloat)distance {
    
    //Data prepare
    CGFloat portraitHeightConstant = CGRectGetHeight(newView.frame);
    CGFloat landscapeWidhtConstant = CGRectGetWidth(newView.frame);
    NSInteger insertIndex = [self getRealIndex:index];
    CGFloat sizeMultiplier = [[self class] convertSizeTypeToMultiplier:sizeType];
    [self addSubview:newView];
    
    landscapeContentLength = landscapeContentLength + landscapeWidhtConstant + distance;
    portriatContentLength = portriatContentLength + portraitHeightConstant + distance;
    if (self.portraitArrange) {
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), portriatContentLength);
    } else {
        self.contentSize = CGSizeMake(landscapeContentLength , CGRectGetHeight(self.frame));
    }
    [super layoutSubviews];
    
    NSLog(@"%@: %@ , insertIndex %@", NSStringFromSelector(_cmd), NSStringFromCGSize(self.contentSize), @(insertIndex));
    
    [newView invalidateIntrinsicContentSize];
    [newView setTranslatesAutoresizingMaskIntoConstraints:false];
    NMMSubViewConfiguration *priorConfiguration = self.configurations[insertIndex-1];
    UIView *priorView = priorConfiguration.loadView;
    
    NSLayoutAttribute portraitAlignAttr = [[self class]convertAlignTypeToLayoutAttribute:alignType portrait:true];
    NSLayoutAttribute landscapeAlignAttr = [[self class]convertAlignTypeToLayoutAttribute:alignType portrait:false];
    //Portrait
    NSLayoutConstraint *portraitTop = [NSLayoutConstraint constraintWithItem:newView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:priorView
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:distance];
    NSLayoutConstraint *portraitAlign = [NSLayoutConstraint constraintWithItem:newView
                                                                     attribute:portraitAlignAttr
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:portraitAlignAttr
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *portraitWidth = [NSLayoutConstraint constraintWithItem:newView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:sizeMultiplier
                                                                      constant:0];
    NSLayoutConstraint *portraitHeight = [NSLayoutConstraint constraintWithItem:newView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:portraitHeightConstant];
    //Landscape
    NSLayoutConstraint *landscapeAlign = [NSLayoutConstraint constraintWithItem:newView
                                                                      attribute:landscapeAlignAttr
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:landscapeAlignAttr
                                                                     multiplier:1.0
                                                                       constant:0];
    NSLayoutConstraint *landscapeLeading = [NSLayoutConstraint constraintWithItem:newView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:priorView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.0
                                                                         constant:distance];
    NSLayoutConstraint *landscapeWidth = [NSLayoutConstraint constraintWithItem:newView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:landscapeWidhtConstant];
    NSLayoutConstraint *landscapeHeight = [NSLayoutConstraint constraintWithItem:newView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:sizeMultiplier
                                                                        constant:0];
    
    
    NMMSubViewConfiguration *colletion = [[NMMSubViewConfiguration alloc]init];
    
    colletion.portraitHeight = portraitHeight;
    colletion.portraitAlign = portraitAlign;
    colletion.portraitTop = portraitTop;
    colletion.portraitWidth = portraitWidth;
    
    colletion.landscapeHeight = landscapeHeight;
    colletion.landscapeLeading = landscapeLeading;
    colletion.landscapeAlign = landscapeAlign;
    colletion.landscapeWidth = landscapeWidth;
    
    colletion.loadView = newView;
    colletion.orialignType = alignType;
    colletion.oriSizeType = sizeType;
    
    
    if (insertIndex < self.configurations.count) {
        NMMSubViewConfiguration *trailingConfigureation =  self.configurations[insertIndex];
        
        NSLayoutConstraint *poTopCon = trailingConfigureation.portraitTop;
        UIView *trailingView = trailingConfigureation.portraitTop.firstItem;
        BOOL acitve;
        CGFloat padding;
        //Portrait.
        padding = trailingConfigureation.portraitTop.constant;
        acitve = trailingConfigureation.portraitTop.active;
        poTopCon.active = false;
        
        trailingConfigureation.portraitTop = [NSLayoutConstraint constraintWithItem:trailingView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:newView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1
                                                                           constant:padding];
        trailingConfigureation.portraitTop.active = acitve;
        
        //Landscape
        padding = trailingConfigureation.landscapeLeading.constant;
        acitve = trailingConfigureation.landscapeLeading.active;
        
        trailingConfigureation.landscapeLeading.active = false;
        trailingConfigureation.landscapeLeading = [NSLayoutConstraint constraintWithItem:trailingView
                                                                               attribute:NSLayoutAttributeLeading
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:newView
                                                                               attribute:NSLayoutAttributeTrailing
                                                                              multiplier:1.0
                                                                                constant:padding];
        trailingConfigureation.landscapeLeading.active = acitve;
    }
    [self.configurations insertObject:colletion atIndex:insertIndex];
    
    
    if (self.portraitArrange) {
        [NSLayoutConstraint activateConstraints:[colletion portraitConstraints]];
    } else {
        [NSLayoutConstraint activateConstraints:[colletion landscapeConstraints]];
    }
    
    if (self.viewAnimation) {
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.25f animations:^{
            [self layoutIfNeeded];
        }];
    }
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

+ (CGFloat)convertSizeTypeToMultiplier:(NMMSubViewSizeType)sizeType {
    CGFloat sizeMultiplier = 0;
    switch (sizeType) {
        case SubViewSizeType_Full:
            sizeMultiplier = 1;
            break;
        case SubViewSizeType_Quarter:
            sizeMultiplier = 0.25;
            break;
            
        case SubViewSizeType_Half:
            sizeMultiplier = 0.5;
            break;
        case SubViewSizeType_ThreeQuarter:
            sizeMultiplier = 0.75;
            break;
        default:
            sizeMultiplier = 1;
            break;
    }
    return sizeMultiplier;
}


+ (NSLayoutAttribute)convertAlignTypeToLayoutAttribute:(NMMSubviewAlignType)alignType portrait:(BOOL)portrait {
    //    SubviewAlignType_Center,
    //    SubviewAlignType_Left,
    //    SubviewAlignType_Right,
    //    SubviewAlignType_OriAlign,
    
    switch (alignType) {
        case SubviewAlignType_Center:
            if (portrait) {
                return NSLayoutAttributeCenterX;
                
            } else {
                return NSLayoutAttributeCenterY;
            }
            break;
        case SubviewAlignType_Left:
            if (portrait) {
                return NSLayoutAttributeLeading;
            } else {
                return NSLayoutAttributeBottom;
            }
            break;
            
        case SubviewAlignType_Right:
            if (portrait) {
                return NSLayoutAttributeTrailing;
            } else {
                return NSLayoutAttributeTop;
            }
            break;
        default:
            if (portrait) {
                return NSLayoutAttributeLeading;
            } else {
                return NSLayoutAttributeBottom;
            }
            break;
    }
    return NSLayoutAttributeNotAnAttribute;
}

@end