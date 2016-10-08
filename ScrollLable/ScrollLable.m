//
//  ScrollLable.m
//  CALayer
//
//  Created by WEI on 2016/10/8.
//  Copyright © 2016年 WEI. All rights reserved.
//

#import "ScrollLable.h"
typedef void(^LableAction)();

@interface ScrollLable ()<CAAnimationDelegate>{
    UILabel *maLable;
    CGFloat lableWidth;
    CGFloat lablehight;
    UIButton *coverButton;
}
@property(nonatomic,copy) LableAction click;
@property(nonatomic,assign) ScrollLableDirection direction;
@property(nonatomic,strong) NSString *msg;
@property(nonatomic,strong) UIFont *ft;


@end

@implementation ScrollLable

- (instancetype)initWithFrame:(CGRect)frame withDirection:(ScrollLableDirection)direction withMessage:(NSString *)message{
    if (self = [super initWithFrame:frame]) {
        self.msg = message;
        self.direction = direction;
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withDirection:(ScrollLableDirection)direction withMessage:(NSString *)message messageFont:(UIFont *)font{
    if (self = [super initWithFrame:frame]) {
        self.msg = message;
        self.direction = direction;
        self.ft = font;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withDirection:(ScrollLableDirection)direction withMessage:(NSString *)message withAction:(void(^)())action{
    if (self = [super initWithFrame:frame]) {
        self.click = action;
        self.msg = message;
        self.direction = direction;
    }
    return self;
}

- (void)makeSubViewMessage:(NSString *)message messageFont:(UIFont *)font withDirection:(ScrollLableDirection)direction{
    self.layer.masksToBounds = YES;
    UIFont *messageFont = font == nil ? [UIFont fontWithName:@"HelveticaNeue" size:14.0f] :font;
    if (!direction) {direction = ScrollLableDirectionH;}
    self.direction = direction;
    
    CGFloat lineNumber;
    CGFloat lableX;
    CGFloat lableY;
    
    switch (direction) {
        case ScrollLableDirectionH:
            lableWidth = [self textSize:message withFont:messageFont].width;
            lablehight = self.frame.size.height;
            lableX = self.startPoint == ScrollLableStartPointLeft ? 0:1.0/(self.startPoint-1);
            lableY = 0;
            lineNumber = 1.0;
            break;
        case ScrollLableDirectionV:
            lableWidth = self.frame.size.width;
            lineNumber = ([self textSize:message withFont:messageFont].width/self.frame.size.width)+1;
            lablehight = lineNumber*[self textSize:message withFont:messageFont].height;
            lableX = 0;
            lableY = self.startPoint == ScrollLableStartPointLeft ? 0:1.0/(self.startPoint-1);
            break;
    }
    maLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*lableX, self.frame.size.height*lableY, lableWidth, lablehight)];
    [maLable setNumberOfLines:lineNumber];
    maLable.text = message;
    maLable.font = messageFont;
    maLable.backgroundColor = [UIColor clearColor];
    [self addSubview:maLable];
    
    coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [coverButton addTarget:self action:@selector(butTouchDown) forControlEvents:UIControlEventTouchDown];
    if (self.click) {
        [self addSubview:coverButton];
    }
}
- (CGSize)textSize:(NSString *)text withFont:(UIFont *)textFont{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil]];
}
- (void)butTouchDown{
    if (self.click) {
        self.click();
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self stop];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self restart];
}

- (void)move{
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    [movePath moveToPoint:maLable.center];
    switch (self.direction) {
        case ScrollLableDirectionH:
            [movePath addLineToPoint:CGPointMake(-lableWidth/2, maLable.center.y)];
            moveAnim.duration = lableWidth * 0.01*self.speed;
            break;
        case ScrollLableDirectionV:
            [movePath addLineToPoint:CGPointMake(maLable.center.x, -lablehight/2)];
            moveAnim.duration = lablehight * 0.03*self.speed;
            break;
    }
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    [moveAnim setDelegate:self];
    [maLable.layer addAnimation:moveAnim forKey:nil];
}
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self move];
    }
}
#pragma mark -  设置滚动速度
-(ScrollLableSpeed)speed{
    if (!_speed) {
        _speed = ScrollLableSpeedMediumFast;
    }
    return _speed;
}
#pragma mark -  设置滚动起始位置
-(ScrollLableStartPoint)startPoint{
    if (!_startPoint) {
        _startPoint = ScrollLableStartPointRight;
    }
    return _startPoint;
}
#pragma mark -  滚动动画相关操作
- (void)start{
    [self makeSubViewMessage:self.msg messageFont:self.ft withDirection:self.direction];
    [self move];
}

- (void)stop{
    [self pauseLayer:maLable.layer];
}

- (void)restart{
    [self resumeLayer:maLable.layer];
}

@end
