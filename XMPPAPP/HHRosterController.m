//
//  HHRosterController.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/9/28.
//  Copyright © 2018 qudao.tbkf.net. All rights reserved.
//

#import "HHRosterController.h"

NSString * const kCell = @"kCell";

@interface HHRosterController ()

@property (nonatomic, strong) NSMutableArray *rosterArray;

@end

@implementation HHRosterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBar];
    [self addViews];
    [self loadData];
}
- (void)setupNaviBar {
    self.navigationItem.title = @"好友列表";
}
- (void)addViews {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];
}
- (void)loadData{
    _rosterArray = [NSMutableArray array];
    UserModel *currentUser = [UserManager currentUserModel];
    @weakify(self)
    [[IMManager shareManager] loginWithUser:currentUser success:^{
        [[IMManager shareManager].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[IMManager shareManager].roster fetchRoster];
    } fail:^{
        [weak_self showToastWith:@"拉去好友失败！"];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rosterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    XMPPJID *jid = self.rosterArray[indexPath.row];
    cell.textLabel.text = jid.user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPJID *jid = _rosterArray[indexPath.row];
    HHChatController *vc = [HHChatController new];
    vc.toJID = jid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark XMPPRosterDelegate
//刚开始获取好友列表
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
    NSLog(@"开始获取好友列表");
}

//正在获取好友列表
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    NSLog(@"正在获取好友列表...%@",item);
    NSString *jidStr = [[item attributeForName:@"jid"] stringValue];
    XMPPJID *jid =[XMPPJID jidWithString:jidStr];
    [self.rosterArray addObject:jid];
    
    //将数据添加进数组
   // [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.rosterArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

//已经完成好友列表获取
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    [self.tableView reloadData];
}


@end
