//
//  AVSampleBufferDisplayLayer+IVS.m
//  BasicRealTime
//
//  Created by Crist, Ryan on 7/15/24.
//

#import "AVSampleBufferDisplayLayer+IVS.h"

#import <objc/runtime.h>

@implementation AVSampleBufferDisplayLayer (IVS)

// Shamelessly inspired by https://nshipster.com/method-swizzling/
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(enqueueSampleBuffer:);
        SEL swizzledSelector = @selector(ivs_enqueueSampleBuffer:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        IMP originalImp = method_getImplementation(originalMethod);
        IMP swizzledImp = method_getImplementation(swizzledMethod);

        class_replaceMethod(class,
                swizzledSelector,
                originalImp,
                method_getTypeEncoding(originalMethod));
        class_replaceMethod(class,
                originalSelector,
                swizzledImp,
                method_getTypeEncoding(swizzledSelector));

    });
}

- (void)ivs_enqueueSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    [self ivs_enqueueSampleBuffer:sampleBuffer];
    // Do something with the sample buffer...
}

@end
