//
//  ExpressionCell.m
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "ExpressionCell.h"
#import "ExpressionConfig.h"

@implementation ExpressionCell

- (void)setPage:(NSInteger)page {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _page = page;
    
    CGFloat expressionWH = ScreenWidth / Expression_NumberOfLine;
    
    for (int i = 0 ; i < _expressionNumber; i++) {
        UIButton *expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *img = [[UIImageView alloc] init];
        
        // 删除按钮
        if (i == _expressionNumber - 1) {
            [expressionButton setImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
            img.image = [UIImage imageNamed:@"DeleteEmoticonBtn"];
            [expressionButton addTarget:self action:@selector(selectDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        // Emoji
        else {
            NSString *imageName = [NSString stringWithFormat:@"Expression_%ld", _page * (_expressionNumber - 1) + i + 1];
            [expressionButton setImage:[Common scaleImage:[UIImage imageNamed:imageName] toSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            img.image = [UIImage imageNamed:imageName];
            expressionButton.tag = _page * (_expressionNumber - 1) + i + 1;
            [expressionButton addTarget:self action:@selector(selectExpression:) forControlEvents:UIControlEventTouchUpInside];
        }
        CGRect bounds = expressionButton.imageView.bounds;
        bounds.size.height += 10;
        bounds.size.width += 10;
        expressionButton.imageView.bounds = bounds;
        
        //计算行列
        NSInteger row = i % _maxLineNumber;
        NSInteger col = i / _maxLineNumber;
        
        CGFloat x = row * expressionWH;
        CGFloat y = col * expressionWH;
        
        expressionButton.frame = CGRectMake(x, y, expressionWH, expressionWH);
        img.frame = expressionButton.frame;
        [self.contentView addSubview:expressionButton];
    }
}

// 点击Emoji操作
- (void)selectExpression:(UIButton *)btn {
    NSString *imageName = [NSString stringWithFormat:@"Expression_%ld", btn.tag];
    if ([self.delegate respondsToSelector:@selector(expressionCell:didSelectEmoji:)]) {
        [self.delegate expressionCell:self didSelectEmoji:imageName];
    }
}
// 点击删除操作
- (void)selectDeleteButton:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(expressionCellDeleteEmoji:)]) {
        [self.delegate expressionCellDeleteEmoji:self];
    }
}

@end
