//
//  ZYCycleCell.h
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCycleView.h"

@interface ZYCycleCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, assign) HMCycleViewContentMode mode;
@end
