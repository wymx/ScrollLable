//
//  ViewController.m
//  ScrollLable
//
//  Created by WEI on 2016/10/8.
//  Copyright © 2016年 weiyouming. All rights reserved.
//

#import "ViewController.h"
#import "ScrollLable.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ScrollLable *lable = [[ScrollLable alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70) withDirection:ScrollLableDirectionV withMessage:@"这是测试文字1这是测试文字这是测试文字这是测试文3字这是测试文字这是测试文字这是测试文字这是测试文5" withAction:^{
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"按钮标题" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:cancelAction];
        [self presentViewController:alter animated:YES completion:nil];
    }];
    lable.backgroundColor = [UIColor redColor];
    lable.startPoint = ScrollLableStartPointMid;
    [lable start];
    [self.view addSubview:lable];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
