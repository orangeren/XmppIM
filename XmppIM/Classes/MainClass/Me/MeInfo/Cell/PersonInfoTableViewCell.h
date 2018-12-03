//
//  PersonInfoTableViewCell.h
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *showValue;
@property (weak, nonatomic) IBOutlet UIButton *headPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;

- (void)updateCellUIWithCellName:(NSString *)cellname cellTitle:(NSString *)celltitle;

@end
