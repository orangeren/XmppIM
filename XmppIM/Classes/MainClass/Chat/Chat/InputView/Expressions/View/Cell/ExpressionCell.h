//
//  ExpressionCell.h
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpressionCell;

@protocol ExpressionCellDelegate <NSObject>
// 点击emoji
- (void)expressionCell:(ExpressionCell *)cell didSelectEmoji:(NSString *)emoji;
// 点击删除
- (void)expressionCellDeleteEmoji:(ExpressionCell *)cell;
@end


@interface ExpressionCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger page; //第几页
@property (nonatomic, assign) NSInteger expressionNumber; //一页多少个表情
@property (nonatomic, assign) NSInteger maxLineNumber; //一行多少个表情

@property (nonatomic, weak) id<ExpressionCellDelegate> delegate;

@end
