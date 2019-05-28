//
//  HeadPicViewController.m
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "HeadPicViewController.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
#import "XMPPvCardTemp.h"

@interface HeadPicViewController ()<UIScrollViewDelegate> {
    CGFloat scaleNum;   //图片放大倍数
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headPic;
@end

@implementation HeadPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_Background_STR];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 右边添加按钮
    UIButton *righteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [righteBtn setImage:[UIImage imageNamed:@"MeMore"] forState:UIControlStateNormal];
    righteBtn.frame = CGRectMake(0, 0, 44, 44);
    [righteBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:righteBtn];
    
    [self setUI];
}

- (void)setUI {
    scaleNum = 1.0;
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight-TabBarHeightAddition);
    [self.scrollView addSubview:self.headPic];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTap];
    
    [self.scrollView setMinimumZoomScale:1.0f];
    [self.scrollView setMaximumZoomScale:3.0f];
    
    
    // 显示当前用户的个人信息
    XMPPvCardTemp *myVCard = kXmppManager.vCard.myvCardTemp;
    if (myVCard.photo) {
        [self.headPic setImage:[UIImage imageWithData:myVCard.photo]];
    }
}


#pragma mark - 上传图片
- (void)rightBtnClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, (ScreenHeight-ScreenWidth)/2, ScreenWidth, ScreenWidth);
    // 头像圆形
//    imagePickerVc.needCircleCrop = YES;
//    NSInteger left = 15;
//    NSInteger widthHeight = ScreenWidth - 2 * left;
//    NSInteger top = (ScreenHeight - widthHeight) / 2;
//    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count) {
            UIImage *resultImage = photos[0];
            [self.headPic setImage:resultImage];
            
            // 图片限制在500kb
            NSData *data = UIImageJPEGRepresentation(resultImage, 1);
            int scale = 1/(([data length]/1000) % 500);
            if (scale < 1) {
                data = UIImageJPEGRepresentation(resultImage, scale);
            }
            // 更新到服务器 
            XMPPvCardTemp *vCard = kXmppManager.vCard.myvCardTemp;
            [vCard setPhoto:data];
            [kXmppManager.vCard updateMyvCardTemp:vCard];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



#pragma mark - 双击图片放大
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    if (scaleNum == 1.0) {
        scaleNum = 3.0;
    } else {
        scaleNum = 1.0;
    }
    
    [self.scrollView setZoomScale:scaleNum animated:YES];
}


#pragma mark - UIScrollViewDelegate

// 返回一个放大或者缩小的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.headPic;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 设置中心点
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width) ? (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height) ?
    (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;

    self.headPic.center = CGPointMake(self.scrollView.contentSize.width/2 + offsetX, self.scrollView.contentSize.height/2 + offsetY);
}

#pragma mark - lazy load

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;//是否显示侧边的滚动栏
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)headPic {
    if (!_headPic) {
        _headPic = [[UIImageView alloc] init];
        _headPic.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
        _headPic.center = CGPointMake(CGRectGetMaxX(self.scrollView.frame)/2, CGRectGetMaxY(self.scrollView.frame)/2);
    }
    return _headPic;
}

@end
