//
//  UserManager.h
//  XMPPAPP
//
//  Created by 何学成 on 2018/6/14.
//  Copyright © 2018年 qudao.tbkf.net. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^HHHandle)(void);

@interface UserModel : NSObject <NSCoding>
- (instancetype)initWithName:(NSString *)name password:(NSString *)password;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;

@end

@interface UserManager : NSObject
// 是否已经登录
+ (BOOL)isLogedIn;

+ (UserModel *)currentUserModel;

// 登录
+ (void)loginWithName:(NSString *)name password:(NSString *)passwrod successHandle:(void(^)(void))success failedHandle:(void(^)(void))failed;

//注册
+ (void)signUpWithName:(NSString *)name password:(NSString *)password;

// 登出
+ (void)logout;

@end
