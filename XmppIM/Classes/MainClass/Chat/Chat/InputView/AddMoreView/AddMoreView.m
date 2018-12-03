//
//  AddMoreView.m
//  XmppWeChat
//
//  Created by 任芳 on 2016/12/1.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import "AddMoreView.h"
#import "IMAddMoreDataSource.h"
#import "AddMoreCell.h"

#import "TZImagePickerController.h"



#define NumberInPage 8          //每页8个 

@interface AddMoreView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger pages;          // 页数
@end

@implementation AddMoreView

+ (AddMoreView *)addMoreView {
    return [[NSBundle mainBundle] loadNibNamed:@"AddMoreView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddMoreCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}


// 页数
- (NSInteger)pages {
    _pages = ceil([IMAddMoreDataSource addMoreDataSource].count / (CGFloat)NumberInPage);
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
    AddMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *allDateArr = [IMAddMoreDataSource addMoreDataSource];
    cell.cellDataArr = [allDateArr subarrayWithRange:NSMakeRange(NumberInPage*indexPath.row, MIN(NumberInPage, allDateArr.count-NumberInPage*indexPath.row))];
    cell.page = indexPath.row;
    
    cell.cellItemClickBlock = ^(NSDictionary *dict) {
        NSNumber *name = dict[kAddMoreDataSourceName];
        switch (name.intValue) {
            case AddMoreName_Picture:   [self addMore_picture];     break;
            case AddMoreName_Camera:    [self addMore_vedio];       break;
            case AddMoreName_AudioChat: [self addMore_audioChat];   break;
            case AddMoreName_VideoChat: [self addMore_vedioChat];   break;
            case AddMoreName_Location:  [self addMore_location];    break;
            default: break;
        }
    };
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    self.pageControl.currentPage = page;
}


#pragma mark -------------------------------------------
#pragma mark - Click Actions
- (void)addMoreClicked:(UIButton *)button {
    switch (button.tag-100) {
        case AddMoreName_Picture:   [self addMore_picture];     break;
        case AddMoreName_Camera:    [self addMore_vedio];       break;
        case AddMoreName_AudioChat: [self addMore_audioChat];   break;
        case AddMoreName_VideoChat: [self addMore_vedioChat];   break;
        case AddMoreName_Location:  [self addMore_location];    break;
        default:
            break;
    }
}

/* 点击了图片 */
- (void)addMore_picture {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVc.allowPickingOriginalPhoto = NO;   //禁止显示原图
    imagePickerVc.allowTakePicture = NO;            //不在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;              //禁止拍摄视频
    imagePickerVc.showSelectedIndex = YES;          //显示选择序号
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count) { 
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            for (UIImage *photo in photos) {
                NSData *data = UIImageJPEGRepresentation(photo, 1);
                // 图片限制在500kb
                int scale = 1/(([data length]/1000) % 500);
                if (scale < 1) {
                    data = UIImageJPEGRepresentation(photo, scale);
                }
                [dataArr addObject:data];
            }
            
            if ([self.delegate respondsToSelector:@selector(sendImages:bodyMsg:)]) {
                [self.delegate sendImages:dataArr bodyMsg:@"[图片]"];
            }
        }
    }];
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

/* 点击了视频 */
- (void)addMore_vedio {
    
}

/* 点击了「语音聊天」 */
- (void)addMore_audioChat {
//    [self startCommunication:NO];
}

/* 点击了「视频聊天」 */
- (void)addMore_vedioChat {
//    [self startCommunication:YES];
}

/* 点击了 「定位」 */
- (void)addMore_location {
    //    LocationViewController *locationVC = [[LocationViewController alloc] init];
    //    locationVC.delegate = self;
    //    [[self superNavigationController] pushViewController:locationVC animated:YES];
}



#pragma mark - 私有方法
/* 开始 音／视频 通话 */
- (void)startCommunication:(BOOL)isVideo {
//    WebRTCClient *client = [WebRTCClient sharedInstance];
//    [client startEngine];
//    client.myJID = [IMXmppTool sharedIMXmppTool].xmppStream.myJID.full;
//    client.remoteJID = self.remoteJID.full;
//    client.isVideo = isVideo;
//    [client showRTCViewByRemoteName:self.remoteJID.user isVideo:isVideo isCaller:YES];
}

@end
