//
//  UIViewController+HUD.h
//  XMPPAPP
//
//  Created by 何学成 on 2018/9/28.
//  Copyright © 2018 qudao.tbkf.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HUD)

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)showToastWith:(NSString *)title;

- (void)showWait;

- (void)hideHUD;
@end

NS_ASSUME_NONNULL_END
