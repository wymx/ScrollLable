//
//  ScrollLable.h
//  CALayer
//
//  Created by WEI on 2016/10/8.
//  Copyright © 2016年 WEI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollLableDirection) {//文字滚动方向
    ScrollLableDirectionH,//横向默认
    ScrollLableDirectionV,//纵向
};
typedef NS_ENUM(NSInteger, ScrollLableStartPoint) {//文字起始滚动位置
    ScrollLableStartPointLeft = 1,//左边
    ScrollLableStartPointRight = 2,//右边-默认
    ScrollLableStartPointMid = 3,//中间
};
typedef NS_ENUM(NSInteger, ScrollLableSpeed) {//滚动速度
    ScrollLableSpeedFast = 2,
    ScrollLableSpeedMediumFast = 3,//默认
    ScrollLableSpeedMediumSlow = 6,
    ScrollLableSpeedSlow = 8,
};
@interface ScrollLable : UIView

@property(nonatomic,assign) ScrollLableStartPoint startPoint;
@property(nonatomic,assign) ScrollLableSpeed speed;

- (void)stop;
- (void)start;
- (void)restart;
- (instancetype)initWithFrame:(CGRect)frame withDirection:(ScrollLableDirection)direction withMessage:(NSString *)message;
- (instancetype)initWithFrame:(CGRect)frame withDirection:(ScrollLableDirection)direction withMessage:(NSString *)message messageFont:(UIFont *)font;
- (instancetype)initWithFrame:(CGRect)frame withDirection:(ScrollLableDirection)direction withMessage:(NSString *)message withAction:(void(^)())action;
@end
