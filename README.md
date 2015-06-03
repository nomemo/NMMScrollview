# NPScrollview


![](http://ww2.sinaimg.cn/mw690/56becbc4gw1esrd2gmvtzg20e80eknpe.gif)


* SubClass of UIScrollView
* The subviews will automaticlly add with Vertical and Horizon NSConstraints to support autolayout.
* The subviews will arrange as linked list, and support insert, delete , change orientation, change padding and size
* Support both Storyboard and code.

## Installation & Usage

> Just darg **TPAutolayoutScrollView.h** and **TPAutolayoutScrollView.m** to your project.   



~~~obj

@property (nonatomic, assign) BOOL vertical; //change subviews orientation.

- (void)insertSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance atIndex:(NSInteger)index;

- (void)addSubview:(UIView *)view withDistanceFromLastViews:(CGFloat)distance;

- (void)removeSubViewAtIndex:(NSInteger)index;

- (void)changeViewHeightTo:(CGFloat)height atIndex:(NSInteger)index;

- (void)changeDistance:(CGFloat)height toIndex:(NSInteger)index;

~~~

## TO DO

* Fix some autolayout warning after change the subview orientation.
* Combine some redundant code.
* Support cocoapods.
* Make a better demo and readme.
