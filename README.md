# NMMScrollview


SubClass of UIScroll view, arrange the subviews automatic.

## Easy use.

~~~objc

#pragma mark - Action

- (void)changeArrangeOrientation;

- (void)insertSubView:(UIView *)newView
              atIndex:(NSInteger)index
            alignType:(NMMSubviewAlignType)alignType
             SizeType:(NMMSubViewSizeType)sizeType
         priorPadding:(CGFloat)distance;

- (void)removeSubViewAtIndex:(NSInteger)index;

#pragma mark - Change SubView

- (void)changeDistance:(CGFloat)padding atIndex:(NSInteger)index;

- (void)changeAlign:(NMMSubviewAlignType)algin atIndex:(NSInteger)index;

- (void)changeSize:(NMMSubViewSizeType)sizeType atIndex:(NSInteger)index;

- (void)changeSubViewAlignTo:(NMMSubviewAlignType)alignType;

- (void)changeAllSubViewSize:(NMMSubViewSizeType)sizeType;

~~~

## Demo Show

![123](https://raw.githubusercontent.com/Wing-Of-War/NPScrollview/master/Gif/1.gif)

![123](https://raw.githubusercontent.com/Wing-Of-War/NPScrollview/master/Gif/2.gif)

![333](https://raw.githubusercontent.com/Wing-Of-War/NPScrollview/master/Gif/3.gif)
