//
//  IMManager.h
//  XMPPAPP
//
//  Created by 何学成 on 2018/6/12.
//  Copyright © 2018年 qudao.tbkf.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>

typedef enum : NSUInteger {
    HHMessageContentTypeText,
    HHMessageContentTypeFile,
    HHMessageContentTypeOther,
} HHMessageContentType;

@interface HHMessage : NSObject

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) HHMessageContentType type;

@end


@class UserModel;
@interface IMManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) XMPPStream *xmppStream;

@property (nonatomic, strong) XMPPRoster *roster;

@property (nonatomic, strong) XMPPMessageArchiving *messageArchiving;

@property (nonatomic, strong) NSManagedObjectContext *managerObjectContext;

//断开链接
- (void)disconnect;
// 登录
- (void)loginWithUser:(UserModel *)user success:(void(^)(void))success fail:(void(^)(void))fail;
// 注册
- (void)registerWithUser:(UserModel *)user success:(void(^)(void))success fail:(void(^)(void))fail;
//发消息
- (void)sendMessage;

//获取花名册
- (void)fetchRoster:(void(^)(NSArray *))handle;

@end
