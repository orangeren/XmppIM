//
//  ExpressionView.m
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "ExpressionView.h"
#import "ExpressionCell.h"

@interface ExpressionView()<
UICollectionViewDelegate, UICollectionViewDataSource,
ExpressionCellDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, assign) NSInteger numberInPage;   // 个/页
@property (nonatomic, assign) NSInteger pages;          // 页数
@end

@implementation ExpressionView

+ (instancetype)expressionView {
    return [[NSBundle mainBundle] loadNibNamed:@"ExpressionView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ExpressionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.sendButton setBackgroundImage:[Common createColorImageWithColor:[UIColor colorWithRed:250 / 255.f green:250 / 255.f blue:250 / 255.f alpha:1.f]] forState:UIControlStateDisabled];
    [self.sendButton setBackgroundImage:[Common createColorImageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

#pragma mark - Click Action
/* 点击发送按钮 */
- (IBAction)didSelectSendButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(expressionViewDidSelectSendButton:)]) {
        [self.delegate expressionViewDidSelectSendButton:sender];
    }
}

#pragma mark - 公共方法 「设置发送按钮状态」
- (void)setSendButtonState:(BOOL)enabled {
    self.sendButton.enabled = enabled;
}



// 个/页   3*7 = 21
- (NSInteger)numberInPage {
    _numberInPage = Expression_LineOfPage * Expression_NumberOfLine;
    return _numberInPage;
}

// 页数
- (NSInteger)pages {
    _pages = ceil(ExpressionCount / (CGFloat)(Expression_LineOfPage*Expression_NumberOfLine-1));
    self.pageControl.numberOfPages = _pages;
    return _pages;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pages;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}
// 设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// 设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath { 
    ExpressionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.expressionNumber = self.numberInPage;
    cell.maxLineNumber = Expression_NumberOfLine;
    cell.page = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    self.pageControl.currentPage = page;
}


#pragma mark - ExpressionCellDelegate 代理
// 点击emoji
- (void)expressionCell:(ExpressionCell *)cell didSelectEmoji:(NSString *)emoji {
    if ([self.delegate respondsToSelector:@selector(expressionView:didSelectImageName:)]) {
        [self.delegate expressionView:self didSelectImageName:emoji];
    }
}
// 点击删除
- (void)expressionCellDeleteEmoji:(ExpressionCell *)cell {
    if ([self.delegate respondsToSelector:@selector(expressionViewDidSelectDeleteButton:)]) {
        [self.delegate expressionViewDidSelectDeleteButton:self];
    }
}


@end
