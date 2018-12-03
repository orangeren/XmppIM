//
//  AddFriendsCell.h
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFriendDataSource.h"

@interface AddFriendsCell : UITableViewCell

#pragma mark - cell0
@property (weak, nonatomic) IBOutlet UITextField *searchFriendTF;

#pragma mark - cell1
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
- (void)updateCell1:(NSDictionary *)cellDic;

@end
