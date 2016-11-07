//
//  ZBGestureClockView.m
//  ZBGestureClockView
//
//  Created by 澳蜗科技 on 16/11/4.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import "ZBGestureLockView.h"

//密码
#define KPassword   [self getGesturePassword]
//左右边距
#define KLREdge       50
//顶部和底部边距
#define KTBEdge       ([UIScreen mainScreen].bounds.size.height - 3*KPictureWH - 2*KSpace)/2.0
//图片宽高
#define KPictureWH    74
//按钮间距
#define KSpace        (([UIScreen mainScreen].bounds.size.width - KPictureWH*3) - (2*KLREdge))/2.0
//偏好设置
#define KDefaults     [NSUserDefaults standardUserDefaults]

@interface ZBGestureLockView()<UIAlertViewDelegate>
//titleLabel
@property (nonatomic,strong) UILabel *titleLabel;
//messageLabel
@property (nonatomic,strong) UILabel *messageLabel;
//滑动手势
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
//存放所有按钮的数组
@property (nonatomic,copy) NSMutableArray<UIButton *> *buttons;
//存放选中按钮的数组
@property (nonatomic,copy) NSMutableArray<UIButton *> *selectedBtns;
//线条颜色
@property (nonatomic,strong) UIColor *lineColor;
//当前点
@property (nonatomic,assign) CGPoint currentP;
//重设密码校验成功的标记
@property (nonatomic,assign) BOOL reSetCalibrateFlag;

@end

static NSString *_GPWithOld   = @"请输入原密码";
static NSString *_GPWithNew   = @"请设置新密码";
static NSString *_GPWithError = @"密码错误";
static NSString *_GPWithLess  = @"密码长度小于4位";

@implementation ZBGestureLockView

#pragma mark----------------------------懒加载----------------------------
-(UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    }
    return _pan;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.center = CGPointMake(self.center.x, 100);
        _titleLabel.bounds = CGRectMake(0, 0, 200, 20);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.center = CGPointMake(self.center.x, self.bounds.size.height - 100);
        _messageLabel.bounds = CGRectMake(0, 0, 200, 20);
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}
- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (NSMutableArray<UIButton *> *)selectedBtns{
    if (!_selectedBtns) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}


#pragma mark-----------------------------系统方法----------------------------

- (void)drawRect:(CGRect)rect {
    
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //清空上下文
    CGContextClearRect(ctx, rect);
    //描述路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (self.selectedBtns.count > 0){
        //设置起点
        [path moveToPoint:self.selectedBtns.firstObject.center];
        //设置经过点和终点
        for (UIButton *selectedBtn in self.selectedBtns) {
            [path addLineToPoint:selectedBtn.center];
        }
        [path addLineToPoint:self.currentP];
    }
    //设置颜色和宽度
    [_lineColor set];
    CGContextSetLineWidth(ctx, 15);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //将路径绘制到上下文
    CGContextAddPath(ctx, path.CGPath);
    //绘图
    CGContextStrokePath(ctx);
}
- (void)layoutSubviews {
    //添加拖动手势
    [self addGestureRecognizer:self.pan];
    //添加titleLabel
    switch (self.state) {
        case unlockState:
            self.titleLabel.text = @"解锁模式";
            self.messageLabel.text = _GPWithOld;
            break;
        case setState:
            self.titleLabel.text = @"设置密码模式";
            self.messageLabel.text = _GPWithNew;
            break;
        case reSetState:
            self.titleLabel.text = @"重设密码模式";
            self.messageLabel.text = _reSetCalibrateFlag ? _GPWithNew : _GPWithOld;
            break;
        default:
            break;
    }
    
    for(int i=0; i<9; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [btn setTag:i];
        
        CGFloat r = i/3;
        CGFloat c = i%3;
        CGFloat x = KLREdge + c * (KSpace + KPictureWH);
        CGFloat y = KTBEdge + r * (KSpace + KPictureWH);
        btn.frame = CGRectMake(x, y, KPictureWH, KPictureWH);
        
        [self addSubview:btn];
        //存放到数组中
        [self.buttons addObject:btn];
    }
}

#pragma mark-----------------------------事件监听------------------------
- (void)panClick:(UIPanGestureRecognizer *)pan {
    //获取当前触摸点
    self.currentP = [pan locationInView:self];
    if(pan.state == UIGestureRecognizerStateBegan){
        [self unlockWithFail];
    }else if(pan.state == UIGestureRecognizerStateChanged){
        //开始滑动 || 正在滑动
        [self isBoundsWithPoint:self.currentP];
    }else if(pan.state == UIGestureRecognizerStateEnded){
        //结束滑动
        if(self.state == setState){
            //设置密码
            [self setGesturePassword];
        }else if(self.state == unlockState){
            //解锁
            [self calibrateGesturePassword:unlockState];
        }else if(self.state == reSetState){
            //重设密码
            [self calibrateGesturePassword:reSetState];
        }
    }
}

#pragma mark-------------------------public fuction---------------------
#pragma mark-  判断当前触摸点是否在范围内
- (void)isBoundsWithPoint:(CGPoint)currentP{
    for (UIButton *btn in self.buttons) {
        if (CGRectContainsPoint(btn.frame, currentP)) {
            if(![self.selectedBtns containsObject:btn]){
                btn.selected = YES;
                //存放到数组
                [self.selectedBtns addObject:btn];
            }
        }
    }
    //设置线条颜色
    _lineColor = self.lineColorWithNormal ? self.lineColorWithNormal : [UIColor greenColor];
    //重绘
    [self setNeedsDisplay];
}
#pragma mark-  拼接密码字符串
- (NSString *)appendGesturePassword{
    NSMutableString *str = [NSMutableString string];
    for (UIButton *selectedBtn in _selectedBtns) {
        [str appendFormat:@"%ld",selectedBtn.tag];
    }
    return str;
}
#pragma mark-  弹出视图
- (void)showGestureLockViewWithState:(ZBGestureLockState)state{
    self.state = state;
    [self resumeNormalView];
    self.messageLabel.text = _GPWithNew;
    self.titleLabel.text = @"设置密码模式";
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

#pragma mark----------------------——存储密码模式--------------------------
#pragma mark-  保存密码
- (void)setGesturePassword{
    //密码长度不小于4
    if ([self appendGesturePassword].length < 4) {
        self.messageLabel.text = _GPWithLess;
        [self calibrateWithFail];
    }else{
        //获取选择密码
        NSString *gesturePW = [self appendGesturePassword];
        //存入沙盒
        [KDefaults setObject:gesturePW forKey:@"gesturePW"];
        [KDefaults synchronize];
        //从父视图移除
        [self removeFromSuperview];
    }
}
#pragma mark-  获取密码
- (NSString *)getGesturePassword{
    return [KDefaults valueForKey:@"gesturePW"];
}
#pragma mark-  清除密码
+ (void)clearGesturePassword{
    [KDefaults removeObjectForKey:@"gesturePW"];
}

#pragma mark------------------------重设密码模式--------------------------
#pragma mark-  重设密码校验成功
- (void)resumeNormalView{
    //全部设置为未选中状态
    for (UIButton *btn in self.buttons) {
        btn.selected = NO;
    }
    //清空选中按钮数组
    [self.selectedBtns removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

#pragma mark-------------------------解锁模式----------------------------
#pragma mark-  校验密码
- (void)calibrateGesturePassword:(ZBGestureLockState)state{
    //设置当前点为最后选择按钮的中心点
    self.currentP = self.selectedBtns.lastObject.center;
    //判断是否图形正确
    BOOL isEqual = [[self appendGesturePassword] isEqualToString:KPassword];
    if (state == unlockState) {
        if (isEqual) {
            [self unlockWithSuccess];
        }else{
            //校验失败
            [self calibrateWithFail];
            self.messageLabel.text = _GPWithError;
        }
    }else if (state == reSetState){
        if (_reSetCalibrateFlag) {
            [self setGesturePassword];
            _reSetCalibrateFlag = NO;
        }else{
            if (isEqual) {
                _reSetCalibrateFlag = YES;
                self.messageLabel.text = _GPWithNew;
                [self resumeNormalView];
            }else{
                //校验失败
                [self calibrateWithFail];
                self.messageLabel.text = _GPWithError;
            }
        }
    }
}
#pragma mark-  解锁成功
- (void)unlockWithSuccess{
    [self.selectedBtns removeAllObjects];
    [self removeFromSuperview];
}
#pragma mark-  解锁失败
- (void)unlockWithFail{
    //恢复成正常状态
    [self resumeNormalView];
}
#pragma mark-  校验失败
- (void)calibrateWithFail{
    _lineColor = self.lineColorWithError ? self.lineColorWithError : [UIColor redColor];
    [self setNeedsDisplay];
    [self shakeAnimation];
}
#pragma mark-  解锁失败抖动动画
- (void)shakeAnimation{
    //设置抖动的两个终点位置
    CGPoint topPoint = CGPointMake(self.center.x, self.center.y - 10);
    CGPoint bottomPoint = CGPointMake(self.center.x, self.center.y + 10);
    //设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    //设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:topPoint]];
    //设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:bottomPoint]];
    //设置自动反转
    [animation setAutoreverses:YES];
    //设置时间
    [animation setDuration:0.005];
    //设置次数
    [animation setRepeatCount:5];
    //添加动画
    [self.layer addAnimation:animation forKey:nil];
}

@end
