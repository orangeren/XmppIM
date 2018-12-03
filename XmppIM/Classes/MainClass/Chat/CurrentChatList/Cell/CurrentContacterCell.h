//
//  CurrentContacterCell.h
//  XmppIM
//
//  Created by 任 on 2018/11/7.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentContacterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *lastMessage;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@property (weak, nonatomic) IBOutlet UILabel *unReadTag;

- (void)updateCell:(XMPPMessageArchiving_Contact_CoreDataObject *)contact;

@end
