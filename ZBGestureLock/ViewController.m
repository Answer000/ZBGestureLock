//
//  ViewController.m
//  ZBGestureLock
//
//  Created by 澳蜗科技 on 16/11/7.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import "ZBGestureLockView.h"

@interface ViewController ()
@property (nonatomic,strong) ZBGestureLockView *gestureLockView;
@end

@implementation ViewController

-(ZBGestureLockView *)gestureLockView{
    if (!_gestureLockView) {
        _gestureLockView = [[ZBGestureLockView alloc] initWithFrame:self.view.bounds];
    }
    return _gestureLockView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"手势密码:%@",[self.gestureLockView getGesturePassword]);
    NSString *gestureP = [self.gestureLockView getGesturePassword];
    [self.gestureLockView showGestureLockViewWithState:gestureP ? unlockState : setState];
}
- (IBAction)clearGesturePasswordClick:(UIButton *)sender {
    [ZBGestureLockView clearGesturePassword];
    [self.gestureLockView showGestureLockViewWithState:setState];
}

@end
