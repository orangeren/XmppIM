//
//  AddMoreCell.m
//  XmppIM
//
//  Created by 任 on 2018/11/13.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "AddMoreCell.h"

@implementation AddMoreCell

- (void)setPage:(NSInteger)page {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _page = page;
    
    CGFloat itemViewW = ScreenWidth / 4;
    CGFloat itemViewH = (Input_AddMoreKeyboard_Height-20) / 2;
    for (int i = 0 ; i < self.cellDataArr.count; i++) {
        NSDictionary *dict = self.cellDataArr[i];
        
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(itemViewW*(i%4), itemViewH*(i/4), itemViewW, itemViewH);
        [self.contentView addSubview:itemBtn];
        
        itemBtn.info_Dict = dict;
        [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         
        // 1.UIImageView
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dict[kAddMoreDataSourceIcon]]];
        imageV.backgroundColor = [UIColor whiteColor];
        imageV.frame = CGRectMake((itemBtn.width-itemViewW*0.5)/2, 12, itemViewW*0.5, itemViewW*0.5);
        imageV.layer.cornerRadius = 8;
        imageV.layer.masksToBounds = YES;
        imageV.layer.borderWidth = 0.5;
        imageV.layer.borderColor = [UIColor colorWithHexString:@"f3f3f3"].CGColor;
        [itemBtn addSubview:imageV];
        // 2.UILabel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageV.bottom+5, itemBtn.width, 20)];
        label.text = dict[kAddMoreDataSourceTitle];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [itemBtn addSubview:label];
    }
}

- (void)itemBtnClick:(UIButton *)button {
    if (self.cellItemClickBlock) {
        self.cellItemClickBlock(button.info_Dict);
    }
}

@end
