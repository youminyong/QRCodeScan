//
//  QRCodeScanViewController.m
//  QRCodeScanDemo
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import <ScanQRCode/ScanView.h>

@interface QRCodeScanViewController ()<ScanViewDelegate>
/**  容器视图*/
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**  扫描容器高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;
/**  冲击波视图*/
@property (weak, nonatomic) IBOutlet UIImageView *scanBorderView;
/**  冲击波视图顶部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineViewTopCons;

@property (strong, nonatomic) ScanView * scanView;
@end

@implementation QRCodeScanViewController

#pragma mark - 懒加载

- (ScanView *)scanView{
    if (!_scanView) {
        _scanView = [[ScanView alloc] init];
        _scanView.delegate = self;
        _scanView.frame = self.view.bounds;
        [self.view insertSubview:_scanView atIndex:0];
    }
    return _scanView;
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerHeightCons.constant = [UIScreen mainScreen].bounds.size.width - 83*2;
    [self scan];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self scan];
}

- (void)scan{
    // 1.开始冲击波动画
    [self startAnimation];
    
    // 2.设置扫码类型
    self.scanView.qrcode = QRCode;
    
    // 3.开始扫描
    [self.scanView startScan];
}

/** 开始冲击波动画 */
- (void)startAnimation{
    // 1.停止冲击波图层动画
    [self.scanBorderView.layer removeAllAnimations];
    
    // 2.让约束从顶部开始
    self.scanLineViewTopCons.constant = -self.containerHeightCons.constant;
    
    // 3.更新视图布局
    [self.view layoutIfNeeded];
    
    // 4.执行冲击波动画
    [UIView animateWithDuration:1.5 animations:^{
        // 5.修改约束
        self.scanLineViewTopCons.constant = self.containerHeightCons.constant;
        // 6.设置动画次数
        [UIView setAnimationRepeatCount:MAXFLOAT];
        // 7.更新视图布局
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ScanViewDelegate
- (void)didFinishScan:(ScanView *)scanView result:(NSString *)result{
    NSLog(@"result:%@",result);
}
@end
