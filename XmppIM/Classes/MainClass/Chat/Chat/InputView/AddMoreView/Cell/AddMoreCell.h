//
//  AddMoreCell.h
//  XmppIM
//
//  Created by 任 on 2018/11/13.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAddMoreDataSource.h"
#import "InputConfig.h"

@interface AddMoreCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger page;       //第几页
@property (nonatomic, strong) NSArray *cellDataArr; //数据源

@property (nonatomic, strong) void (^cellItemClickBlock)(NSDictionary *dict);
@end
