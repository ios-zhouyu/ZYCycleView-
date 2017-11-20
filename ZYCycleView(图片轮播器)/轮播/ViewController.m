//
//  ViewController.m
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import "ViewController.h"
#import "ZYCycleView.h"
#import "DemoViewController.h"

@interface ViewController ()<ZYCycleViewDelegate>
@property (nonatomic, copy) NSArray *imageURLStringArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轮播图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
}

#pragma mark 点击的是第几个图片
- (void)cycleView:(ZYCycleView *)cycleView didSelectItemAtIndex:(NSInteger)index{
    DemoViewController *demo = [[DemoViewController alloc] init];
    demo.title = [NSString stringWithFormat:@"第%d个图片的跳转",(int)index + 1];
    demo.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:demo animated:YES];
}

- (void)setUpUI {
    CGFloat pointY = 44 + [UIApplication sharedApplication].statusBarFrame.size.height;
    ZYCycleView *cycleView = [[ZYCycleView alloc] initWithFrame:CGRectMake(0, pointY, [UIScreen mainScreen].bounds.size.width, 220)];
    cycleView.imageURLStringArr = self.imageURLStringArr;
    cycleView.mode = HMCycleViewContentModeScaleAspectFill;
    cycleView.delegate = self;
    [self.view addSubview:cycleView];
}

#pragma mark 懒加载
- (NSArray *)imageURLStringArr{
    if (_imageURLStringArr == nil) {
        _imageURLStringArr = @[
                               @"http://www.wocoor.com/templates/images/banner01.jpg",
                               @"http://www.wocoor.com/templates/images/banner02.jpg",
                               @"http://www.wocoor.com/templates/images/banner03.jpg",
                               @"http://www.wocoor.com/templates/images/banner04.jpg"
                               ];
    }
    return _imageURLStringArr;
}

@end
