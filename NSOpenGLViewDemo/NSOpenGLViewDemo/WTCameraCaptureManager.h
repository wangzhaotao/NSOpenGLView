//
//  WTCameraCaptureManager.h
//  NSOpenGLViewDemo
//
//  Created by tyler on 12/31/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

typedef void(^CaptureVideoDataBlock)(CVImageBufferRef dataBuffer);



@interface WTCameraCaptureManager : NSObject

- (void)initCaptureSession;
- (void)openCamera;
- (void)closeCamera;

@property (nonatomic, copy) CaptureVideoDataBlock captureVideoBlock;

@end


