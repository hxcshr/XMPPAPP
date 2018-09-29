//
//  HHChatController.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/9/28.
//  Copyright © 2018 qudao.tbkf.net. All rights reserved.
//

#import "HHChatController.h"
#import "HHChatCell.h"

@interface HHChatController () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *allMessageArray;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation HHChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allMessageArray = [NSMutableArray array];
    self.navigationItem.title = _toJID.user;
    self.tableView.estimatedRowHeight = 50;
    [self.tableView registerClass:[HHChatCell class] forCellReuseIdentifier:kHHSendCell];
    [self.tableView registerClass:[HHChatCell class] forCellReuseIdentifier:kHHReceiveCell];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addViews];
    
    
    [self loadData];
    
    [[IMManager shareManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)addViews {
    self.tableView.height = kScreenHeight / 2;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2.0 -25, kScreenWidth, 50)];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
}

- (void)loadData {
    NSManagedObjectContext *managerObjectContext = [IMManager shareManager].managerObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ And streamBareJidStr == %@", self.toJID.bare,[IMManager shareManager].xmppStream.myJID.bare];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *fetchResutl = [managerObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [_allMessageArray removeAllObjects];
    
    [_allMessageArray addObjectsFromArray:fetchResutl];
    
    [self.tableView reloadData];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    return YES;
}

- (void)sendMessage {
    NSString *tmp = _textView.text;
    if (tmp.length == 0) {
        return;
    }
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.toJID];
    //要发送的消息添加到Body
    [message addBody:tmp];
    //发送消息
    [[IMManager shareManager].xmppStream sendElement:message];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    _textView.text = @"";
    [self loadData];
}

- (void)xmppStream:(XMPPStream *)sneder didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    [self showToastWith:@"发送失败，请重试！"];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message isChatMessageWithBody]) {
        [self loadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allMessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *message = _allMessageArray[indexPath.row];
    HHChatCell *cell;
    if (message.isOutgoing) {
        cell = [tableView dequeueReusableCellWithIdentifier:kHHSendCell forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kHHReceiveCell forIndexPath:indexPath];
    }
    cell.message = message.message;
    return cell;
}
@end
