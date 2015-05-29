//
//  ViewController.m
//  ScrollView
//
//  Created by 张珏 on 15/5/25.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "ViewController.h"
#import "TPAutolayoutScrollView.h"
#import "TPAutoLayoutUIView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TPAutolayoutScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TPAutoLayoutUIView *tpView;
@property (weak, nonatomic) IBOutlet TPAutolayoutScrollView *scrollView2;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
//  [self.scrollView insertSubView:temp];

  UIView *temp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
  temp.backgroundColor  = [UIColor blackColor];
  UIView *temp2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 70)];
  temp2.backgroundColor  = [UIColor greenColor];
  UIView *temp3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 110)];
  temp3.backgroundColor  = [UIColor redColor];

//  [self.tpView insertSubview:temp withPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
//  [self.tpView insertSubview:temp2 withPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
//  [self.tpView insertSubview:temp3 withPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
  


  self.scrollView.vertical = true;
  for (int i = 0; i < 20; i ++) {
    CGFloat height =  (arc4random() % 3 + 1) * 20;
    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    temp.text = [NSString stringWithFormat:@"%d", i];
    temp.font = [UIFont systemFontOfSize:30];
    temp.textColor = [UIColor whiteColor];
    temp.backgroundColor  = [UIColor blackColor];
    [self.scrollView insertSubView:temp withDistanceFromLastView:arc4random() % 10];
  }
  
  
  self.scrollView2.vertical = false;
  for (int i = 22; i < 40; i ++) {
    CGFloat height =  (arc4random() % 3 + 1) * 20;
    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    temp.text = [NSString stringWithFormat:@"%d", i];
    temp.font = [UIFont systemFontOfSize:30];
    temp.textColor = [UIColor whiteColor];
    temp.backgroundColor  = [UIColor blackColor];
    [self.scrollView2 insertSubView:temp withDistanceFromLastView:arc4random() % 10];
  }

}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender {
  self.scrollView.vertical = !self.scrollView.vertical;
}
@end
