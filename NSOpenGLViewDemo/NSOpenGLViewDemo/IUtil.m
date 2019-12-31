//
//  IUtil.m
//  NSOpenGLViewDemo
//
//  Created by tyler on 12/31/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "IUtil.h"
#include <assert.h>
#include <CoreServices/CoreServices.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>

@implementation IUtil

+(void)printFPSInfomation
{
    static int fps = 0;
    
    static uint64_t        start;
    uint64_t        end;
    uint64_t        elapsed;
    Nanoseconds     elapsedNano;
    
    // Start the clock.
    if (start == 0) {
        start = mach_absolute_time();
    }
    
    
    // Stop the clock.
    end = mach_absolute_time();
    
    // Calculate the duration.
    elapsed = end - start;
    
    // Convert to nanoseconds.
    // Have to do some pointer fun because AbsoluteToNanoseconds
    // works in terms of UnsignedWide, which is a structure rather
    // than a proper 64-bit integer.
    elapsedNano = AbsoluteToNanoseconds( *(AbsoluteTime *) &elapsed );
    if (* (uint64_t *) &elapsedNano > 1000000000ULL) {
        NSLog(@"fps: %d", fps);
        fps = 0;
        start = end;
    }
    
    fps++;
}

@end
