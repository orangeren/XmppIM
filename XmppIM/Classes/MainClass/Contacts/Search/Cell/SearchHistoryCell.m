//
//  SearchHistoryCell.m
//  XmppIM
//
//  Created by 任 on 2018/11/6.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

- (IBAction)onDeleteClick:(UIButton *)sender {
    if (self.deleteHistoryBlock) {
        self.deleteHistoryBlock();
    }
}

@end
