//
//  WTRootVC.m
//  NSOpenGLViewDemo
//
//  Created by tyler on 12/31/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTRootVC.h"
#import "VideoGLView.h"
#import "Masonry.h"
#import "WTCameraCaptureManager.h"
//#import <OpenGL/gl3.h>


@interface WTRootVC ()
@property (nonatomic, strong) VideoGLView *openGLView;
@property (nonatomic, strong) WTCameraCaptureManager *captureManager;

@end

@implementation WTRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self.view setWantsLayer:YES];
    
    [self initUI];
    
    WTCameraCaptureManager *captureManager = [[WTCameraCaptureManager alloc]init];
    _captureManager = captureManager;
    __weak typeof(self) weakSelf = self;
    _captureManager.captureVideoBlock = ^(CVImageBufferRef dataBuffer) {
        [weakSelf.openGLView setImage:dataBuffer];
    };
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    //初始化
    [_captureManager initCaptureSession];
}



-(void)initUI {
    
    //view
    VideoGLView *openGLView = [[VideoGLView alloc]init];
    [self.view addSubview:openGLView];
    _openGLView = openGLView;
    openGLView.frame = CGRectMake(50, 50, 300, 400);
    
    //button
    NSButton *openBtn = [[NSButton alloc]init];
    openBtn.bordered = YES;
    openBtn.title = @"打开";
    openBtn.contentTintColor = [NSColor blackColor];
    openBtn.target = self;
    openBtn.action = @selector(openBtnAction:);
    [self.view addSubview:openBtn];
    openBtn.frame = CGRectMake(50, 600, 60, 30);
    
    NSButton *closeBtn = [[NSButton alloc]init];
    closeBtn.title = @"关闭";
    closeBtn.contentTintColor = [NSColor blackColor];
    closeBtn.target = self;
    closeBtn.action = @selector(closeBtnAction:);
    [self.view addSubview:closeBtn];
    closeBtn.frame = CGRectMake(150, 600, 60, 30);
    
    [openGLView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.centerX.equalTo(@0);
        make.width.equalTo(@500);
        make.height.equalTo(@400);
    }];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(openGLView.mas_bottom).offset(50);
        make.centerX.equalTo(@-100);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(openGLView.mas_bottom).offset(50);
        make.centerX.equalTo(@100);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
}

-(void)openBtnAction:(NSButton*)sender {
    
    //打开
    [_captureManager openCamera];
}
-(void)closeBtnAction:(NSButton*)sender {
    
    //关闭
    [_captureManager closeCamera];
}

@end
