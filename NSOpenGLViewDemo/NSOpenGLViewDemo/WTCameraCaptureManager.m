//
//  WTCameraCaptureManager.m
//  NSOpenGLViewDemo
//
//  Created by tyler on 12/31/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTCameraCaptureManager.h"
#import "IUtil.h"
@import AVFoundation;

@interface WTCameraCaptureManager () <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_captureSession;
    dispatch_queue_t _captureQueue;
}

@end

@implementation WTCameraCaptureManager

-(instancetype)init {
    if (self = [super init]) {
        _captureQueue = dispatch_queue_create("AVCapture2", 0);
    }
    return self;
}

- (void)initCaptureSession
{
    
    _captureSession = [[AVCaptureSession alloc] init];
    
    [_captureSession beginConfiguration];
    
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSCAssert(captureDevice, @"no device");
    
    NSError *error;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    [_captureSession addInput:input];
    
    //-- Create the output for the capture session.
    AVCaptureVideoDataOutput * dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES]; // Probably want to set this to NO when recording
    
    for (int i = 0; i < dataOutput.availableVideoCVPixelFormatTypes.count; i++) {
        char fourr[5] = {0};
        *((int32_t *)fourr) = CFSwapInt32([dataOutput.availableVideoCVPixelFormatTypes[i] intValue]);
        NSLog(@"%s", fourr);
    }
    
    //-- Set to YUV420.
    [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt:kCVPixelFormatType_24RGB],
                                   (id)kCVPixelBufferWidthKey:@640,
                                   (id)kCVPixelBufferHeightKey:@480}];
     
    // Set dispatch to be on the main thread so OpenGL can do things with the data
    [dataOutput setSampleBufferDelegate:self queue:_captureQueue];
    
    NSAssert([_captureSession canAddOutput:dataOutput], @"can't output");
    
    [_captureSession addOutput:dataOutput];
    
    [_captureSession commitConfiguration];

}

-(void)openCamera {
    
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
}
-(void)closeCamera {
    
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    static CMFormatDescriptionRef desc;
    if (!desc) {
        desc = CMSampleBufferGetFormatDescription(sampleBuffer);
        NSLog(@"%@", desc);
    }
    
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    if (self.captureVideoBlock) {
        self.captureVideoBlock(buffer);
    }
    //[self.openGLView setImage:buffer];
    
    //fps
    [IUtil printFPSInfomation];
}






#pragma mark 请求权限
-(void)requestCameraAuthority:(void(^)(BOOL success))completion {
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
        {
            //获取授权成功
            if (completion) {
                completion(YES);
            }
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            //目前用户为选择
            dispatch_suspend(_captureQueue);//self.seaaionQueue 是串行线程
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(granted);
                    }
                });
            }];
            break;
        }
        default:
        {
          //处理其余情况
            if (completion) {
                completion(NO);
            }
            break;
        }
    }
}

@end
