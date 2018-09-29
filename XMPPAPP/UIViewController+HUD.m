//
//  UIViewController+HUD.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/9/28.
//  Copyright © 2018 qudao.tbkf.net. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>

const void * kHudKey = "kHudKey";
@implementation UIViewController (HUD)

- (MBProgressHUD *)hud{
    return objc_getAssociatedObject(self, kHudKey);
}

- (void)setHud:(MBProgressHUD *)hud{
    objc_setAssociatedObject(self, kHudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showWait{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        self.hud.removeFromSuperViewOnHide = YES;
    }
    [self.view addSubview:self.hud];
    self.hud.label.text = nil;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.hud showAnimated:YES];
}

- (void)showToastWith:(NSString *)title{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        self.hud.removeFromSuperViewOnHide = YES;
    }
    [self.view addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = @"请输入正确的用户名和密码";
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:1];
}

- (void)hideHUD{
    [self.hud hideAnimated:YES];
}

@end
