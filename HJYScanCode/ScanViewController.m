//
//  ScanViewController.m
//  HJYScanCode
//
//  Created by 黄家永 on 16/6/23.
//  Copyright © 2016年 黄家永. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, copy) NSString *license;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.captureSession = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScan];
}

- (void)startScan {
    NSError *error;
    //初始化捕捉设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    //创建数据输出
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //创建会话
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //将输入添加到会话
    [self.captureSession addInput:input];
    
    //将输出添加到会话
    [self.captureSession addOutput:captureMetadataOutput];
    
    //设置输出数据类型
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    
    //设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    //设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置图层的frame
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];
    
    //将图层添加到预览view的图层上
    [self.view.layer addSublayer:self.videoPreviewLayer];
    
    //扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //开始扫描
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.license = [metadataObj stringValue];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        }
    }
}

//停止扫描
-(void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.delegate license:self.license];
    [self.videoPreviewLayer removeFromSuperlayer];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)license:(NSString *)license {
    if ([self.delegate respondsToSelector:@selector(license:)]) {
        [self.delegate license:self.license];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
