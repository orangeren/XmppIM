//
//  CurrentContacterCell.m
//  XmppIM
//
//  Created by 任 on 2018/11/7.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "CurrentContacterCell.h"

@implementation CurrentContacterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(XMPPMessageArchiving_Contact_CoreDataObject *)contact {
    // 展示名字
    self.displayName.text = contact.bareJid.user;
    // 头像
    NSData *photoData = [kXmppManager.avatar photoDataForJID:contact.bareJid];
    if (photoData) {
        self.headPhoto.image = [[UIImage alloc] initWithData:photoData];
    } else {
        self.headPhoto.image = [UIImage imageNamed:@"defaultPhoto"];
    }
    // 最后通话内容
    self.lastMessage.text = contact.mostRecentMessageBody;
    // 最后通话时间
    self.lastTime.text = [Common timeStr:contact.mostRecentMessageTimestamp];
    // 未读数
    self.unReadTag.hidden = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[IMAppCache getUnreadNumFromSanbox]];
    NSArray *keys = dict.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString *keyStr = [keys objectAtIndex:i];
        if ([keyStr isEqualToString:contact.bareJid.user]) {
            NSString *unReadNum = [dict objectForKey:keyStr];
            self.unReadTag.hidden = NO;
            self.unReadTag.text = [NSString stringWithFormat:@"%@",unReadNum];
            break;
        }
    }
}

@end
