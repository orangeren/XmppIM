//
//  EditPersonInfoViewController.h
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeInfoDataSource.h"

@interface EditPersonInfoViewController : BaseTableViewController
@property (nonatomic, strong) NSDictionary *meInfoDict;
@property (nonatomic, strong) NSString *showTitle;
@property (nonatomic, strong) NSString *showValue;
@end
