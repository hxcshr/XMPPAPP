//
//  HHChatCell.h
//  XMPPAPP
//
//  Created by 何学成 on 2018/9/29.
//  Copyright © 2018 qudao.tbkf.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kHHSendCell;
extern NSString * const kHHReceiveCell;

@interface HHChatCell : UITableViewCell

//@property (nonatomic, strong) UIImageView *avatarImg;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) XMPPMessage *message;

@end

NS_ASSUME_NONNULL_END
