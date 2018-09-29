//
//  HHChatCell.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/9/29.
//  Copyright © 2018 qudao.tbkf.net. All rights reserved.
//

#import "HHChatCell.h"

NSString * const kHHSendCell = @"kHHSendCell";
NSString * const kHHReceiveCell = @"kHHReceiveCell";

@implementation HHChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageLabel = [UILabel new];
        _messageLabel.numberOfLines = 0;
        [self.contentView addSubview:_messageLabel];
        if (reuseIdentifier == kHHReceiveCell) {
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.top.mas_equalTo(8);
                make.bottom.mas_equalTo(-8);
                make.width.height.mas_greaterThanOrEqualTo(0);
                make.right.mas_lessThanOrEqualTo(-50);
            }];
        } else {
            _messageLabel.textColor = [UIColor lightGrayColor];
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-16);
                make.top.mas_equalTo(8);
                make.bottom.mas_equalTo(-8);
                make.width.height.mas_greaterThanOrEqualTo(0);
                make.left.mas_greaterThanOrEqualTo(50);
            }];
        }
    }
    return self;
}

- (void)setMessage:(XMPPMessage *)message{
    if (_message == message) {
        return;
    }
    _message = message;
    _messageLabel.text = _message.body;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
