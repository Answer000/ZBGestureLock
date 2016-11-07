# ZBGestureLock
### 框架作用：
* 用于实现手势解锁屏幕功能，两行代码实现手势锁设置、解锁、重置功能
* 框架地址：[https://github.com/AnswerXu/ZBGestureLock.git](https://github.com/AnswerXu/ZBGestureLock.git)

### 简介
* 该框架的手势解锁屏幕功能有三种状态模式
    * 设置手势密码模式
    * 解锁手势密码模式
    * 重置手势密码模式
                                 
### 使用方法
    * 手动导入：将 ZBGestureLock.h 和 ZBGestureLock.h 文件拖入到工程中
    * 改框架支持cocoapods导入：  pod 'ZBGestureLock', ~> '0.0.2'
* 设置密码模式：setState
```Objc
    //懒加载视图
    -(ZBGestureLockView *)gestureLockView{
        if (!_gestureLockView) {
            _gestureLockView = [[ZBGestureLockView alloc] initWithFrame:self.view.bounds];
        }
        return _gestureLockView;
    }
    
    //获取本地手势密码
    NSString *gestureP = [self.gestureLockView getGesturePassword];
    [self.gestureLockView showGestureLockViewWithState:gestureP ? unlockState : setState];
```

* 解锁密码模式：unlockState
```Objc
    ZBGestureLockView *view = [[ZBGestureLockView alloc] initWithFrame:self.view.bounds];
    [view showGestureLockViewWithState:unlockState];
```

* 重设密码模式：reSetState
```Objc
    ZBGestureLockView *view = [[ZBGestureLockView alloc] initWithFrame:self.view.bounds];
    [view showGestureLockViewWithState:reSetState];
```

### 清除密码
```Objc
    [ZBGestureLockView clearGesturePassword];
```

### 弹出视图
```Objc
    [self.gestureLockView showGestureLockViewWithState:setState];
````
