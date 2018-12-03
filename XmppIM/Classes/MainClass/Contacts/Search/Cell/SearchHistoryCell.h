//
//  SearchHistoryCell.h
//  XmppIM
//
//  Created by 任 on 2018/11/6.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *historyLab;
@property (weak, nonatomic) IBOutlet UIView *topLine; 

@property (nonatomic, copy) void(^deleteHistoryBlock)(void);

@end
