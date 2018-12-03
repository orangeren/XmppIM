//
//  DIYNormalHeader.m
//  XmppIM
//
//  Created by 任 on 2018/11/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "DIYNormalHeader.h"

@implementation DIYNormalHeader

#pragma mark - lazy load
- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.fillColor = nil;
        _circleLayer.lineWidth = 1.0;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.strokeStart = 0;
        _circleLayer.strokeEnd = 0;
        _circleLayer.strokeColor = [UIColor grayColor].CGColor;
    }
    return _circleLayer;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.circleLayer.frame = self.arrowView.bounds;
    CGPoint center = CGPointMake(self.arrowView.width * 0.5, self.arrowView.height * 0.5);
    CGFloat radius = self.arrowView.height * 0.5 - self.circleLayer.lineWidth * 0.5;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2*M_PI - M_PI_2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    self.circleLayer.path = path.CGPath;
    [self.arrowView.layer addSublayer:self.circleLayer];
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshFastAnimationDuration * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.circleLayer setStrokeStart:0];
                [self.circleLayer setStrokeEnd:0];
            });
        }
    } else if (state == MJRefreshStatePulling) {
        self.circleLayer.strokeEnd = 1;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    CGFloat pullPerc = fmin(self.pullingPercent, 1);
    //NSLog(@"pullingPercent - %f  pullPerc - %f  state:%ld  alpha:%f", self.pullingPercent, pullPerc, (long)self.state, self.contentView.alpha);
    
    if (self.state == MJRefreshStateRefreshing) {
        return;
    }
    
    //if (self.scrollView.isDragging) {// 拖拽
    self.circleLayer.strokeEnd = pullPerc;
    //}
}

@end
