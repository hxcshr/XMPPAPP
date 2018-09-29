//
//  UserManager.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/6/14.
//  Copyright © 2018年 qudao.tbkf.net. All rights reserved.
//

#import "UserManager.h"

NSString * const kIsLogIn = @"kIsLogIn";
NSString * const kCurrentUser = @"kCurrentUser";

@implementation UserModel
- (instancetype)initWithName:(NSString *)name password:(NSString *)password
{
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _password = [coder decodeObjectForKey:@"password"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_password forKey:@"password"];
}
@end

@implementation UserManager

+ (BOOL)isLogedIn{
    return [[MMKV defaultMMKV] getBoolForKey:kIsLogIn defaultValue:NO];
}

+ (UserModel *)currentUserModel{
    NSData *data = [[MMKV defaultMMKV] getObjectOfClass:[NSData class] forKey:kCurrentUser];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)loginWithName:(NSString *)name password:(NSString *)passwrod successHandle:(void (^)(void))success failedHandle:(void (^)(void))failed{

    UserModel *model = [[UserModel alloc] initWithName:name password:passwrod];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[MMKV defaultMMKV] setObject:data forKey:kCurrentUser];
    [[IMManager shareManager] loginWithUser:model success:^{
        [[MMKV defaultMMKV] setBool:YES forKey:kIsLogIn];
        if (success) {
            success();
        }
    } fail:failed];
}
+ (void)signUpWithName:(NSString *)name password:(NSString *)password{
    
}
+ (void)logout{

}

@end
