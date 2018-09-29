//
//  IMManager.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/6/12.
//  Copyright © 2018年 qudao.tbkf.net. All rights reserved.
//

#import "IMManager.h"
#import "UserManager.h"

#define kTimeout 10
#define kPort 5222

static NSString * const kHost = @"localhost";
static NSString * const kDomain = @"bogon";
static NSString * const kResource = @"iOS";

typedef enum : NSUInteger {
    HHXMPPStatusLogin,
    HHXMPPStatusRegister
} HHXMPPStatus;

@interface IMManager ()

@property (nonatomic, assign) HHXMPPStatus actionType;

@property (nonatomic, strong) UserModel *currentUser;

@property (nonatomic, copy) void(^loginSuccessHandle)(void);
@property (nonatomic, copy) void(^loginFailedHandle)(void);

@end

@implementation IMManager

+ (instancetype)shareManager{
    static IMManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _xmppStream = [[XMPPStream alloc] init];
        _xmppStream.hostName = kHost;
        _xmppStream.hostPort = kPort;
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        XMPPRosterCoreDataStorage *rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
        _roster = [[XMPPRoster alloc] initWithRosterStorage:rosterStorage dispatchQueue:dispatch_get_main_queue()];
        [_roster activate:_xmppStream];
        
        XMPPMessageArchivingCoreDataStorage *messageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:messageArchivingStorage dispatchQueue:dispatch_get_main_queue()];
        [_messageArchiving activate:_xmppStream];
        
        _managerObjectContext = messageArchivingStorage.mainThreadManagedObjectContext;
        
    }
    return self;
}

//断开链接
- (void)disconnect{
    XMPPPresence *pre = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:pre];
    [_xmppStream disconnect];
}
// 登录
- (void)loginWithUser:(UserModel *)user success:(void (^)(void))success fail:(void (^)(void))fail {
    _actionType = HHXMPPStatusLogin;
    [self connectWithUser:user success:success fail:fail];
}

// 注册
- (void)registerWithUser:(UserModel *)user success:(void (^)(void))success fail:(void (^)(void))fail{
    _actionType = HHXMPPStatusRegister;
    [self connectWithUser:user success:success fail:fail];
}

- (void)connectWithUser:(UserModel *)user success:(void (^)(void))success fail:(void (^)(void))fail {
    _currentUser = user;
    
    XMPPJID *jid = [XMPPJID jidWithUser:user.name domain:kDomain resource:kResource];
    _xmppStream.myJID = jid;
    NSError *error = nil;
    [_xmppStream connectWithTimeout:kTimeout error:&error];
    if (error) {
        NSLog(@"%@",error);
        if (fail) {
            fail();
        }
        [_xmppStream disconnect];
    }
    self.loginSuccessHandle = success;
    self.loginFailedHandle = fail;
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    if (_xmppStream.isAuthenticated) {
        return;
    }
    NSError *error = nil;
    switch (_actionType) {
        case HHXMPPStatusLogin:
        {
            [sender authenticateWithPassword:_currentUser.password error:&error];
        }
            break;
        case HHXMPPStatusRegister:
        {
            [sender registerWithPassword:_currentUser.password error:&error];
        }
            break;
        default:
            break;
    }
//    if (error) {
//        NSLog(@"%@",error);
//        [_xmppStream disconnect];
//    }else{
//        NSLog(@"success");
//    }
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"socket 链接成功");
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    XMPPPresence *pre = [XMPPPresence presenceWithType:@"available"];
    [_xmppStream sendElement:pre];
    if (_loginSuccessHandle) {
        _loginSuccessHandle();
    }
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    if (_loginFailedHandle) {
        _loginFailedHandle();
    }
    NSLog(@"xmpp授权失败:%@", error.description);
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"%@",message.body);
}


//发消息
- (void)sendMessage{

}

//获取花名册
- (void)fetchRoster:(void (^)(NSArray *))handle{
    
}


@end
