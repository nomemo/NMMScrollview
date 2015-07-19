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
@property (weak, nonatomic) IBOutlet NMMAutolayoutScrollView *scrollView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //  [self.scrollView insertSubView:temp];
    
    //  UIView *temp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    //  temp.backgroundColor  = [UIColor blackColor];
    //  UIView *temp2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 70)];
    //  temp2.backgroundColor  = [UIColor greenColor];
    //  UIView *temp3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 110)];
    //  temp3.backgroundColor  = [UIColor redColor];
    
    //  [self.tpView insertSubview:temp withPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
    //  [self.tpView insertSubview:temp2 withPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
    //  [self.tpView insertSubview:temp3 withPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    
    //  self.scrollView.vertical = true;
    //  for (int i = 0; i < 20; i ++) {
    //    CGFloat height =  (arc4random() % 3 + 1) * 20;
    //    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    //    temp.text = [NSString stringWithFormat:@"%d", i];
    //    temp.font = [UIFont systemFontOfSize:30];
    //    temp.textColor = [UIColor whiteColor];
    //    temp.backgroundColor  = [UIColor blackColor];
    //    [self.scrollView insertSubView:temp withDistanceFromLastView:arc4random() % 10];
    //  }
    //
    //
    //  self.scrollView2.vertical = false;
    //  for (int i = 22; i < 40; i ++) {
    //    CGFloat height =  (arc4random() % 3 + 1) * 20;
    //    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    //    temp.text = [NSString stringWithFormat:@"%d", i];
    //    temp.font = [UIFont systemFontOfSize:30];
    //    temp.textColor = [UIColor whiteColor];
    //    temp.backgroundColor  = [UIColor blackColor];
    //    [self.scrollView2 insertSubView:temp withDistanceFromLastView:arc4random() % 10];
    //  }
    self.scrollView.vertical = true;
}

- (IBAction)addHead:(id)sender {
    NSString *labelStr = [NSString stringWithFormat:@"%d", (int)[self.scrollView.autoLayoutViews count]];
    UILabel *label = [self createLabel:labelStr];
    [self.scrollView insertSubview:label withDistanceFromLastViews:10 atIndex:0];
}
- (IBAction)addMid:(id)sender {
    NSInteger count = [self.scrollView.autoLayoutViews count];
    NSString *labelStr = [NSString stringWithFormat:@"%d", (int)count];
    UILabel *label = [self createLabel:labelStr];
    [self.scrollView insertSubview:label withDistanceFromLastViews:count atIndex:count/2];
}
- (IBAction)addTail:(id)sender {
    NSInteger count = [self.scrollView.autoLayoutViews count];
    NSString *labelStr = [NSString stringWithFormat:@"%d", (int)count];
    UILabel *label = [self createLabel:labelStr];
    [self.scrollView insertSubview:label withDistanceFromLastViews:count atIndex:count];
}
- (IBAction)resizeSubView:(id)sender {
    NSInteger count = [self.scrollView.autoLayoutViews count];
    //  [self.scrollView changeViewHeightTo:15 atIndex:count];
    [self.scrollView removeSubViewAtIndex:count/2];
    //  [self.scrollView removeSubViewAtIndex:count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rotate:(id)sender {
    self.scrollView.vertical = !self.scrollView.vertical;
}

- (IBAction)randomInsert:(id)sender {
    NSString *labelStr = [NSString stringWithFormat:@"%d", (int)[self.scrollView.autoLayoutViews count]];
    NSInteger index = arc4random() %  ([self.scrollView.autoLayoutViews count] + 1);
    UILabel *label = [self createLabel:labelStr];
    [self.scrollView insertSubview:label withDistanceFromLastViews:index atIndex:index];
}

- (IBAction)randomRemove:(id)sender {
    NSInteger index = arc4random() %  [self.scrollView.autoLayoutViews count];
    [self.scrollView removeSubViewAtIndex:index];
}


- (UILabel *)createLabel:(NSString *)string {
    CGFloat size1 =  (arc4random() % 3 + 1) * 20;
    CGFloat size2 =  (arc4random() % 3 + 1) * 20;
    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size1, size2)];
    temp.text = [NSString stringWithFormat:@"%@", string];
    temp.font = [UIFont systemFontOfSize:30];
    temp.textColor = [UIColor whiteColor];
    temp.backgroundColor  = [UIColor blackColor];
    return temp;
}

@end
