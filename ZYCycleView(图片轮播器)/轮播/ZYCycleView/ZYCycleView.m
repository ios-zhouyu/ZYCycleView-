//
//  ZYCycleView.m
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import "ZYCycleView.h"
#import "ZYCellFlowLayout.h"
#import "ZYCycleCell.h"

//CollectionView复用cell的机制,不管当前的section有道少了item,当cell的宽和屏幕的宽一致是,当前屏幕最多显示两个cell(图片切换时是两个cell),切换完成时有且仅有一个cell,即使放大1000倍,内存中最多加载两个cell,所以不会造成内存暴涨现象
#define KCount 100

static NSString *cellID = @"cell";

@interface ZYCycleView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ZYCycleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

#pragma mark 获取图片URL数组
- (void)setImageURLStringArr:(NSArray *)imageURLStringArr {
    _imageURLStringArr = imageURLStringArr;
    self.pageControl.numberOfPages = imageURLStringArr.count;
    [self.collectionView reloadData];

    //滚动到中间位置
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:imageURLStringArr.count * KCount inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark 开始拖拽时,停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    // 当拖拽的时候 设置下次触发的时间 为 4001年!!!
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark 结束拖拽时,恢复定时器
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

#pragma mark 监听手动减速完成(停止滚动)  - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / self.bounds.size.width;

    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (page == 0) { // 第一页
        self.collectionView.contentOffset = CGPointMake(offsetX + self.imageURLStringArr.count * KCount * self.bounds.size.width, 0);
    } else if (page == itemsCount - 1) { // 最后一页
        self.collectionView.contentOffset = CGPointMake(offsetX - self.imageURLStringArr.count * KCount * self.bounds.size.width, 0);
    }
}

#pragma mark 滚动动画结束的时候调用 - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView{
    // 手动调用减速完成的方法
    [self scrollViewDidEndDecelerating:self.collectionView];
}

#pragma mark 正在滚动(设置分页) -- 算出滚动位置,更新指示器
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat page = offsetX / self.bounds.size.width + 0.5;
    page = (NSInteger)page % self.imageURLStringArr.count;
    self.pageControl.currentPage = page;
}

#pragma mark 更新定时器 获取当前位置,滚动到下一位置
- (void)updateTimer{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
    NSIndexPath *nextPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark 随父控件的消失取消定时器
- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.timer invalidate];
}

#pragma mark 数据源和代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(cycleView:didSelectItemAtIndex:)]) {
        [_delegate cycleView:self didSelectItemAtIndex:indexPath.item % self.imageURLStringArr.count];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLStringArr.count * 2 * KCount;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath{
    ZYCycleCell *cell = (ZYCycleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.mode = self.mode;
    cell.imageURLString = self.imageURLStringArr[indexPath.item % self.imageURLStringArr.count];
    return cell;
}

#pragma mark 设置pageControl的颜色
- (void)setPageColor:(UIColor *)pageColor {
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}
- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

#pragma mark 设置UI界面 轮播界面,指示器,定时器
- (void)setUpUI {
    //MARK: collectionview轮播图
    ZYCellFlowLayout *layout = [[ZYCellFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.bounces = NO;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[ZYCycleCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    //MARK: 轮播指示器
    CGFloat width = 120;
    CGFloat height = 20;
    CGFloat pointX = ([UIScreen mainScreen].bounds.size.width - width) / 2;
    CGFloat pointY = self.bounds.size.height - height;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
    pageControl.numberOfPages = self.imageURLStringArr.count;
    pageControl.userInteractionEnabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    //MARK: 设置定时器
    NSTimer* timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

@end
