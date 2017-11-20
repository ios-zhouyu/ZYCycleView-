//
//  ZYCellFlowLayout.m
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import "ZYCellFlowLayout.h"

@implementation ZYCellFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    //尺寸
    self.itemSize = self.collectionView.bounds.size;
    //间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    //滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
