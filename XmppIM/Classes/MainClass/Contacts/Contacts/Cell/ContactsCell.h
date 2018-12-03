//
//  ContactsCell.h
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *loginStatus; 
@end
