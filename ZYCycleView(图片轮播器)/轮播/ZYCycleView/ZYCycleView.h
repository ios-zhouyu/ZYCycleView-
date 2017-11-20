//
//  ZYCycleView.h
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HMCycleViewContentModeScaleAspectFill,
    HMCycleViewContentModeScaleAspectFit,
} HMCycleViewContentMode;

@class ZYCycleView;

@protocol ZYCycleViewDelegate<NSObject>
- (void)cycleView: (ZYCycleView *)cycleView didSelectItemAtIndex:(NSInteger)index;
@end

@interface ZYCycleView : UIView

@property (nonatomic, copy) NSArray *imageURLStringArr;
@property (nonatomic, assign) HMCycleViewContentMode mode;
@property (nonatomic, strong) UIColor *pageColor;
@property (nonatomic, strong) UIColor *currentPageColor;

@property (nonatomic, weak) id<ZYCycleViewDelegate> delegate;
@end
