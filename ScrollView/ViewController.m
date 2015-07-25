//
//  ViewController.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "ViewController.h"
#import "NMMAutolayoutScrollView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NMMAutolayoutScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rotate:(id)sender {
    self.scrollView.portraitArrange = !self.scrollView.portraitArrange;
}


- (IBAction)addSubView:(id)sender {
//    UIView *view = [self createRandomView];
    NSInteger insertIndex = arc4random() % self.scrollView.subviews.count /2;
    NSInteger padding = arc4random() % 20;
    
    UIView *view = [self createLabel:[NSString stringWithFormat:@"%@",@(self.scrollView.subviews.count)]];
    [self.scrollView insertSubView:view atIndex:insertIndex ailgnType:1 SizeType:1 priorPadding:padding];
    NSLog(@"insert index is %@" , @(insertIndex));
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

@end
