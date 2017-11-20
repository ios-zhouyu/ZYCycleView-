//
//  ZYCycleCell.m
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import "ZYCycleCell.h"
#import "UIImageView+WebCache.h"

@interface ZYCycleCell()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation ZYCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

// 填充模式
- (void)setMode:(HMCycleViewContentMode)mode{
    _mode = mode;

    switch (self.mode) {
        case HMCycleViewContentModeScaleAspectFit:
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            break;
        case HMCycleViewContentModeScaleAspectFill:
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            break;

        default:
            break;
    }
}

//设置图片
- (void)setupUI{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
}

- (void)setImageURLString:(NSString *)imageURLString{
    _imageURLString = imageURLString;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
}

@end
