//
//  ViewController.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "ViewController.h"
#import "NMMAutolayoutScrollView.h"

@interface ViewController ()<NMMAutolayoutScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NMMAutolayoutScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *touchAction;

@property (assign, nonatomic) NMMSubviewAlignType alignType;
@property (assign, nonatomic) NMMSubViewSizeType sizeType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alignType = SubviewAlignType_OriAlign;
    self.sizeType = SubviewAlignType_OriAlign;
    self.scrollView.nmmDelegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rotate:(id)sender {
    self.scrollView.portraitArrange = !self.scrollView.portraitArrange;
}


- (IBAction)addSubView:(id)sender {
    NSInteger insertIndex = arc4random() % self.scrollView.subviews.count;
    NSInteger padding = arc4random() % 20;
    NSInteger sizeType = arc4random() % 4;
    NSInteger alignType = arc4random() % 3;
    
    NSInteger showNumber = self.scrollView.subviews.count;
    NSInteger textLength = arc4random() % 10 + 1;
    while (textLength --) {
        showNumber *= 10;
    }
    UIView *view = [self createLabel:[NSString stringWithFormat:@"%@",@(showNumber)]];

    [self.scrollView insertSubView:view atIndex:insertIndex alignType:alignType SizeType:sizeType priorPadding:padding];
}

- (IBAction)sizeChange:(id)sender {
    self.sizeType ++;
    if (self.sizeType > SubViewSizeType_OriSize) {
        self.sizeType = SubViewSizeType_Full;
    }
    [self.scrollView changeAllSubViewSize:_sizeType];
}

- (IBAction)alignChange:(id)sender {
    self.alignType ++;
    if (self.alignType > SubviewAlignType_OriAlign) {
        self.alignType = SubviewAlignType_Center;
    }
    [self.scrollView changeSubViewAlignTo:_alignType];
}

- (IBAction)deleteView:(id)sender {
    NSInteger showNumber = self.scrollView.subviews.count;
    NSInteger index = arc4random() % showNumber;
    [self.scrollView removeSubViewAtIndex:index];
}

- (IBAction)showZeroView:(id)sender {
    UISwitch *st = sender;
    self.scrollView.showZeroView = st.isOn;
}


- (UIColor *)color {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}



- (UIView *)createRandomView {
    CGFloat height =  (arc4random() % 100 ) + 20;
    CGFloat width =  (arc4random() % 100 ) + 20;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, height, width)];
    view.backgroundColor = [self color];
    return view;
}

- (UILabel *)createLabel:(NSString *)string {
    CGFloat size1 =  (arc4random() % 3 + 1) * 20;
    CGFloat size2 =  (arc4random() % 3 + 1) * 20;
    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size1, size2)];
    temp.text = [NSString stringWithFormat:@"%@", string];
    temp.font = [UIFont systemFontOfSize:30];
    temp.textColor = [UIColor whiteColor];
    temp.backgroundColor  = [self color];
    [temp sizeToFit];
    return temp;
}

- (void)scrollView:(NMMAutolayoutScrollView *)scrollView touchSubviewAtIndex:(NSInteger)index {
    if (self.touchAction.selectedSegmentIndex == 0) {
        [self.scrollView removeSubViewAtIndex:index];
    }
    if (self.touchAction.selectedSegmentIndex == 1) {
        NSInteger alignType = arc4random() % 3;
        [self.scrollView changeAlign:alignType atIndex:index];
    }

    if (self.touchAction.selectedSegmentIndex == 2) {
        NSInteger padding = arc4random() % 20;
        [self.scrollView changeDistance:padding atIndex:index];
    }

    if (self.touchAction.selectedSegmentIndex == 3) {
        NSInteger sizeType = arc4random() % 4;
        [self.scrollView changeSize:sizeType  atIndex:index];
    }

}

@end
