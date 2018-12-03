//
//  ImagesScrollView.m
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/24.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import "ImagesScrollView.h"
#import "PhotoView.h"

@interface ImagesScrollView()<UIScrollViewDelegate> {
    CGFloat scaleNum;   //图片放大倍数
    int _currentIndex;  //当前展示的是第几张图片
    int _currentShow;   //当前展示的是第几个View 0 1 2
    int _showCount;     //展示图片数量 1 2 3
}

@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (nonatomic, strong) PhotoView *currentImageView;
@property (nonatomic, strong) PhotoView *nextImageView;
@property (nonatomic, strong) PhotoView *preImageView;
@property (nonatomic, strong) PhotoView *curPhotoView; //展示图片的View
@property (strong, nonatomic) NSMutableArray *imgViewsArray;

//数据
@property (strong, nonatomic) NSArray *imgDataSource;

@end

@implementation ImagesScrollView

// 数据源
- (NSArray *)imgDataSource {
    if (!_imgDataSource) {
        _imgDataSource = [[NSMutableArray alloc] init];
    }
    return _imgDataSource;
}

// 展示的图片控件
- (NSMutableArray *)imgViewsArray {
    if (!_imgViewsArray) {
        _imgViewsArray = [[NSMutableArray alloc] init];
    }
    return _imgViewsArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        scaleNum = 1.0;
    }
    return self;
}

- (void)handleSingleTap:(UIGestureRecognizer*)gestureRecognizer {
    [self removeFromSuperview];
}


- (void)drawRect:(CGRect)rect {
    // 数据源
    ImageDataSource *object = [[ImageDataSource alloc] init];
    object.friendJid = self.friendJid;
    _imgDataSource = [object loadImageMsgs];
    
    
    // 获取当前展示图片在数据源中的位置
    _currentIndex = -1;
    for (int i = ((int)_imgDataSource.count - 1); i >= 0; i--) {
        XMPPMessageArchiving_Message_CoreDataObject *msg = _imgDataSource[i];
        if ([msg.timestamp isEqualToDate:_timestamp]) {
            _currentIndex = i;
            break;
        }
    }
    
    // 初始化View
    if (_currentIndex != -1) {
        [self initViews:_currentIndex];
    }
}


- (void)initViews:(int)index {
    // 灰色背景
    UIView *garyBgView = [[UIView alloc] init];
    garyBgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    garyBgView.backgroundColor = [UIColor blackColor];
    garyBgView.alpha = 0;
    [self addSubview:garyBgView];
    
    
    // 大scrollView
    _imgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _imgScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imgScrollView];
    _imgScrollView.tag = 100;
    _imgScrollView.showsHorizontalScrollIndicator = NO;
    _imgScrollView.pagingEnabled = YES;
    _imgScrollView.delegate = self;
    
    // 单击手势 去除View
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [_imgScrollView addGestureRecognizer:singleTap];
    
    // 双击手势 点击图片放大
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [_imgScrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    // 初始化大Scroll的内容
    if (_imgDataSource.count == 1) {
        _showCount = 1;
        _currentShow = index;
        [self initImagesWithStart:0 count:1 andIndex:index];
    }
    else if (_imgDataSource.count == 2) {
        _showCount = 2;
        _currentShow = index;
        [self initImagesWithStart:0 count:2 andIndex:index];
    }
    else {
        _showCount = 3;
        if (index == 0) {
            _currentShow = 0;
            [self initImagesWithStart:0 count:3 andIndex:index];
        }
        else if (index == _imgDataSource.count-1) {
            _currentShow = 2;
            [self initImagesWithStart:index-2 count:3 andIndex:index];
        }
        else {
            _currentShow = 1;
            [self initImagesWithStart:index-1 count:3 andIndex:index];
        }
    }
    
    // 动画
    //    CGRect curRect = _showImageView.frame;
    //    _showImageView.frame = CGRectMake(index*ScreenWidth+_showImageRect.origin.x, _showImageRect.origin.y, _showImageRect.size.width, _showImageRect.size.height);
    //
    //    NSLog(@"frame - %@  %@ =---- \n %@",NSStringFromCGRect(curRect), NSStringFromCGRect(_showImageRect),NSStringFromCGRect(_showImageView.frame));
    //
    [UIView animateWithDuration:0.3 animations:^{
        //        _showImageView.frame = curRect;
        garyBgView.alpha = 1;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)initImagesWithStart:(int)start count:(int)count andIndex:(int)index {
    [_imgScrollView setContentSize:CGSizeMake(ScreenWidth*count, ScreenHeight)];// 大Scroll的内容大小
    _imgScrollView.contentOffset = CGPointMake((index-start)*ScreenWidth, 0);   // 大Scroll的偏移位置
    
    for (int i = start; i < (start+count); i++) {
        PhotoView *photoV = [[PhotoView alloc] init];
        photoV.delegate = self;
        photoV.frame = CGRectMake(ScreenWidth * (i-start), 0, ScreenWidth, ScreenHeight);
        XMPPMessageArchiving_Message_CoreDataObject *msg = _imgDataSource[i]; 
        [photoV initPhotoView:msg.message];
        
        [_imgScrollView addSubview:photoV];
        [self.imgViewsArray addObject:photoV];
        
        
        if (i == index) {
            _curPhotoView = photoV;
        }
        
        if (count == 3) {
            if (i == start) {
                _preImageView = photoV;
            }
            if (i == start + 1) {
                _currentImageView = photoV;
            }
            if (i == start + 2) {
                _nextImageView = photoV;
            }
        }
    }
}




#pragma mark - 双击图片放大
- (void)handleDoubleTap:(UIGestureRecognizer*)gestureRecognizer {
    NSLog(@"双击放大3倍 %f",scaleNum);
    
    if (scaleNum == 1.0) {
        scaleNum = 3.0;
    } else {
        scaleNum = 1.0;
    }
    
    [_curPhotoView setZoomScale:scaleNum animated:YES];
}




#pragma mark - UIScrollViewDelegate

// 返回一个放大或者缩小的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _curPhotoView.imageView;
}
// 开始放大或者缩小
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    //NSLog(@"1111111");
}
// 缩放结束时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    scaleNum = scrollView.zoomScale;
}
// 等比例放大，让放大的图片保持在scrollView的中央
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 设置中心点
    CGFloat offsetX = (_curPhotoView.bounds.size.width > _curPhotoView.contentSize.width) ? (_curPhotoView.bounds.size.width - _curPhotoView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (_curPhotoView.bounds.size.height > _curPhotoView.contentSize.height) ?
    (_curPhotoView.bounds.size.height - _curPhotoView.contentSize.height) * 0.5 : 0.0;

    _curPhotoView.imageView.center = CGPointMake(_curPhotoView.contentSize.width * 0.5 + offsetX, _curPhotoView.contentSize.height * 0.5 + offsetY);
}

int perCurrentIndex;
// 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    perCurrentIndex = _currentIndex;
}

// 停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        float offset = scrollView.contentOffset.x;
        if ((int)offset % (int)ScreenWidth == 0 && perCurrentIndex != _currentIndex) {
            scaleNum = 1;
            [_curPhotoView setZoomScale:1 animated:NO];
            _curPhotoView = _imgViewsArray[_currentShow];
            _imgScrollView.contentOffset = CGPointMake(ScreenWidth*_currentShow, 0);
        }
    }
}

// 开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        // _currentIndex  当前展示的是第几张图片
        float offset = scrollView.contentOffset.x;
        
        
        // 2个
        if (_imgDataSource.count == 2) {
            if (offset == 0) {
                _currentIndex = 0;
                _currentShow = 0;
            }
            else if (offset == ScreenWidth) {
                _currentIndex = 1;
                _currentShow = 1;
            }
        }
        
        
        // 3个
        if (_imgDataSource.count >= 3) {
            if (_currentIndex > 0 && _currentIndex < _imgDataSource.count-1) {
                if (self.nextImageView.imageView.image == nil || self.preImageView.imageView.image == nil) {
                    // 加载下一个视图
                    XMPPMessageArchiving_Message_CoreDataObject *msg1 = _imgDataSource[_currentIndex+1];
                    UIImage *tempImage1 = [PhotoView getImageWithXMPPMessage:msg1.message];
                    CGSize size1 = [PhotoView scaleSize:tempImage1.size];
                    UIImage *newImage1 = [Common scaleImage:tempImage1 toSize:size1];
                    _nextImageView.imageView.image = newImage1;
                    
                    // 加载上一个视图
                    XMPPMessageArchiving_Message_CoreDataObject *msg2 = _imgDataSource[_currentIndex-1];
                    UIImage *tempImage2 = [PhotoView getImageWithXMPPMessage:msg2.message];
                    CGSize size2 = [PhotoView scaleSize:tempImage2.size];
                    UIImage *newImage2 = [Common scaleImage:tempImage2 toSize:size2];
                    _preImageView.imageView.image = newImage2;
                }
            }
            
            if (offset == 0) {
                if (_currentIndex != 0) {
                    if (_currentIndex > 1) {
                        _currentImageView.imageView.image = _preImageView.imageView.image;
                        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
                        _preImageView.imageView.image = nil;
                    }
                    _currentIndex--;
                }
                if (_currentIndex == 0) {
                    _currentShow = 0;
                }
            }
            
            if (offset == ScreenWidth * 2) {
                if (_currentIndex != _imgDataSource.count-1) {
                    if (_currentIndex < _imgDataSource.count-2) {
                        _currentImageView.imageView.image = _nextImageView.imageView.image;
                        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
                        _nextImageView.imageView.image = nil;
                    }
                    _currentIndex++;
                }
                if (_currentIndex == _imgDataSource.count-1) {
                    _currentShow = 2;
                }
            }
            
            if (offset == ScreenWidth) {
                if (_currentIndex == 0) {
                    _currentIndex++;;
                }
                
                if (_currentIndex == _imgDataSource.count-1) {
                    _currentIndex--;
                }
                
                _currentShow = 1;
            }
        }
        //NSLog(@"_currentIndex - %d  %f  %d",_currentIndex,_curPhotoView.frame.origin.x, _currentShow);
    }
}


@end
