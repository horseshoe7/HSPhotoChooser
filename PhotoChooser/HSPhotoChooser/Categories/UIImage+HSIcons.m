//
//  UIImage+Icons.m
//
//  Created by Stephen O'Connor on 2/6/15.
//  The MIT License (MIT)
//
// Copyright (c) 2015 Stephen O'Connor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIImage+HSIcons.h"
#import "UIImage+HSiOSPictureButton.h"
#import "UIColor+HSHexColors.h"


#import <QuartzCore/QuartzCore.h>

// userInfo keys
NSString * const HSIconInfoKeyInsetRect = @"insetRect";  // a CGValue that you get a CGRect from.  I.e. if you need an inset draw rect from image edges
NSString * const HSIconInfoKeyLineColor = @"lineColor"; // a UIColor
NSString * const HSIconInfoKeyLineWidth = @"lineWidth";  // a NSNumber
NSString * const HSIconInfoKeyFillColor = @"fillColor";  // a UIColor
NSString * const HSIconInfoKeyBackgroundColor = @"backgroundColor"; // a UIColor
NSString * const HSIconInfoKeyStretchableFromCenter = @"stretchable";  // a NSNumber
NSString * const HSIconInfoKeyCacheKey = @"cachekey"; // if you need to pre-load its cachekey

static NSUInteger const HSIconTypeIdentifierCameraButton = 0;


static NSCache *kImageCache = nil;

@implementation UIImage (Icons)

+ (NSString*)cacheKeyForImageParameters:(NSUInteger)typeIdentifier
                                   size:(CGSize)size
                              lineWidth:(CGFloat)lineWidth
                              lineColor:(UIColor*)lineColor
                              fillColor:(UIColor*)fillColor
                        backgroundColor:(UIColor*)backgroundColorOrNil
{
    return [NSString stringWithFormat:@"t:%i_s:%@_lw:%.2f_lc:%@_fc:%@_bc:%@", (int)typeIdentifier, NSStringFromCGSize(size), lineWidth, [UIColor hexValuesFromUIColor:lineColor], [UIColor hexValuesFromUIColor:fillColor], [UIColor hexValuesFromUIColor:backgroundColorOrNil]];
}

+ (NSDictionary*)HS_standardParametersForTakePictureButtonWithSize:(CGSize)size
                                                         lineWidth:(CGFloat)lineWidth
                                                         lineColor:(UIColor*)lineColor
                                                         fillColor:(UIColor*)fillColor
                                                   backgroundColor:(UIColor*)backgroundColorOrNil
{
    NSString *cacheKey = [self cacheKeyForImageParameters:HSIconTypeIdentifierCameraButton size:size lineWidth:lineWidth lineColor:lineColor fillColor:fillColor backgroundColor:backgroundColorOrNil];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    info[HSIconInfoKeyLineWidth] = @(lineWidth);
    info[HSIconInfoKeyCacheKey] = cacheKey;
    
    if (lineColor) {
        info[HSIconInfoKeyLineColor] = lineColor;
    }
    if (fillColor) {
        info[HSIconInfoKeyFillColor] = fillColor;
    }
    if (backgroundColorOrNil) {
        info[HSIconInfoKeyBackgroundColor] = backgroundColorOrNil;
    }
    
    return info;
}

+ (UIImage*)HS_takePictureImageWithSize:(CGSize)size
                              lineColor:(UIColor*)lineColor
                              fillColor:(UIColor*)fillColor
                        backgroundColor:(UIColor*)backgroundColorOrNil
{
    NSDictionary *info = [self HS_standardParametersForTakePictureButtonWithSize:size
                                                                       lineWidth:0
                                                                       lineColor:lineColor
                                                                       fillColor:fillColor
                                                                 backgroundColor:backgroundColorOrNil];
    
    return [self HS_takePictureImageWithSize:size parameters:info];
}


+ (UIImage*)HS_takePictureImageWithSize:(CGSize)size
                             parameters:(NSDictionary*)params
{
    return [self HS_imageWithIconType:HSIconTypeIdentifierCameraButton size:size parameters:params];
}

+ (UIImage*)HS_imageWithIconType:(NSUInteger)typeIdentifier
                             size:(CGSize)size
                         parameters:(NSDictionary*)params
{
    
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    
    UIImage *image = nil;
    
    NSString *cacheKey = params[HSIconInfoKeyCacheKey];
    NSAssert(cacheKey, @"You have to provide a cache key for this to work!");
    
    if (kImageCache) {
        image = [kImageCache objectForKey:cacheKey];
    }
    
    if (image) {
        return image;
    }
    
    
    BOOL opaque = (params[HSIconInfoKeyBackgroundColor] != nil);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self HS_drawImageInContext:context withType:typeIdentifier imageRect:imageRect params:params];
    
    image = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
    UIGraphicsEndImageContext();
    
    if (!kImageCache) {
        kImageCache = [[NSCache alloc] init];
    }
    
    if ([params[HSIconInfoKeyStretchableFromCenter] boolValue]) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake((int)image.size.height/2,
                                                                    (int)image.size.width/2,
                                                                    (int)image.size.height/2,
                                                                    (int)image.size.width/2)];
    }
    
    [kImageCache setObject:image forKey:cacheKey];
    
    return image;
    
}

#pragma mark - Icon Drawing Methods

+ (void)HS_drawImageInContext:(CGContextRef)context
                      withType:(NSUInteger)typeIdentifier
                      imageRect:(CGRect)imageRect
                        params:(NSDictionary*)params
{
    switch (typeIdentifier) {
        
        case HSIconTypeIdentifierCameraButton:
        {
            [self HS_drawPictureIconInContext:context imageRect:imageRect params:params];
            break;
        }
        default: {
            break;
        }
    }
}


@end
