//
//  ReSetGestureViewController.m
//  ZBGestureClockView
//
//  Created by 澳蜗科技 on 16/11/4.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import "ReSetGestureViewController.h"
#import "ZBGestureLockView.h"

@interface ReSetGestureViewController ()

@end

@implementation ReSetGestureViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    ZBGestureLockView *view = [[ZBGestureLockView alloc] initWithFrame:self.view.bounds];
    [view showGestureClockViewWithState:reSetState];
}
@end
