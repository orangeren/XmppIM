//
//  AddFriendsCell.m
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "AddFriendsCell.h"

@implementation AddFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateCell1:(NSDictionary *)cellDic {
    NSString *cellTitle = cellDic[kAddFriendDataSourceTitle];
    NSString *cellDesc = cellDic[kAddFriendDataSourceDesc];
    NSString *cellIcon = cellDic[kAddFriendDataSourceIcon];
    
    self.icon.image = [UIImage imageNamed:cellIcon];
    self.name.text = cellTitle;
    self.desc.text = cellDesc;
}

@end
