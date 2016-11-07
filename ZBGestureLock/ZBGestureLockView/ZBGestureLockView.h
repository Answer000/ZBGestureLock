//
//  ZBGestureClockView.h
//  ZBGestureClockView
//
//  Created by 澳蜗科技 on 16/11/4.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    //解锁模式
    unlockState = 0,
    //设置密码模式
    setState,
    //重设密码模式
    reSetState
} ZBGestureLockState;

@interface ZBGestureLockView : UIView

//正常状态下线条颜色
@property(nonatomic,strong) UIColor *lineColorWithNormal;
//错误状态下线条颜色
@property(nonatomic,strong) UIColor *lineColorWithError;

@property(nonatomic,assign) ZBGestureLockState state;

//获取本地密码
- (NSString *)getGesturePassword;
//清除密码
+ (void)clearGesturePassword;
//弹出视图
- (void)showGestureLockViewWithState:(ZBGestureLockState)state;
@end
