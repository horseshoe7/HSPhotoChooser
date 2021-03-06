//
//  UIImage+CameraButton.m
//  Created by Stephen O'Connor on 05/02/15.
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

#import "UIImage+CameraButton.h"

@implementation UIImage (CameraButton)

+ (UIImage*)HS_iOSCameraButtonWithSize:(CGSize)size highlighted:(BOOL)highlighted
{
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    
    UIImage *image = nil;
    
    BOOL opaque = NO;
    
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = highlighted ? [UIColor lightGrayColor] : [UIColor whiteColor];
    UIColor *rimColor = [UIColor whiteColor];
    
    [self HS_drawPictureIconInContext:context
                            imageRect:imageRect
                 imageBackgroundColor:nil
                            lineColor:rimColor
                            fillColor:fillColor];
    
    image = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)HS_drawPictureIconInContext:(CGContextRef)context
                          imageRect:(CGRect)imageRect
               imageBackgroundColor:(UIColor*)bgColor
                          lineColor:(UIColor*)lineColor
                          fillColor:(UIColor*)fillColor
{
    if (bgColor)
    {
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:imageRect];
        [bgColor setFill];
        [rectanglePath fill];
    }
    
    CGSize referenceSize = (CGSize){250,250};  // exported from paintcode
    CGRect fitRect = [self HS_rectAspectFit: referenceSize destRect:imageRect];
    CGFloat wf = fitRect.size.width/referenceSize.width;
    CGFloat hf = fitRect.size.height/referenceSize.height;
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(fitRect.origin.x + wf * 53.1, fitRect.origin.y + hf * 52.52)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 53.1, fitRect.origin.y + hf * 197.48) controlPoint1: CGPointMake(fitRect.origin.x + wf * 13.4, fitRect.origin.y + hf * 92.55) controlPoint2: CGPointMake(fitRect.origin.x + wf * 13.4, fitRect.origin.y + hf * 157.45)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 196.9, fitRect.origin.y + hf * 197.48) controlPoint1: CGPointMake(fitRect.origin.x + wf * 92.81, fitRect.origin.y + hf * 237.51) controlPoint2: CGPointMake(fitRect.origin.x + wf * 157.19, fitRect.origin.y + hf * 237.51)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 196.9, fitRect.origin.y + hf * 52.52) controlPoint1: CGPointMake(fitRect.origin.x + wf * 236.6, fitRect.origin.y + hf * 157.45) controlPoint2: CGPointMake(fitRect.origin.x + wf * 236.6, fitRect.origin.y + hf * 92.55)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 53.1, fitRect.origin.y + hf * 52.52) controlPoint1: CGPointMake(fitRect.origin.x + wf * 157.19, fitRect.origin.y + hf * 12.49) controlPoint2: CGPointMake(fitRect.origin.x + wf * 92.81, fitRect.origin.y + hf * 12.49)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(fitRect.origin.x + wf * 212.33, fitRect.origin.y + hf * 36.26)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 212.33, fitRect.origin.y + hf * 213.74) controlPoint1: CGPointMake(fitRect.origin.x + wf * 260.56, fitRect.origin.y + hf * 85.27) controlPoint2: CGPointMake(fitRect.origin.x + wf * 260.56, fitRect.origin.y + hf * 164.73)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 37.67, fitRect.origin.y + hf * 213.74) controlPoint1: CGPointMake(fitRect.origin.x + wf * 164.1, fitRect.origin.y + hf * 262.75) controlPoint2: CGPointMake(fitRect.origin.x + wf * 85.9, fitRect.origin.y + hf * 262.75)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 37.67, fitRect.origin.y + hf * 36.26) controlPoint1: CGPointMake(fitRect.origin.x + wf * -10.56, fitRect.origin.y + hf * 164.73) controlPoint2: CGPointMake(fitRect.origin.x + wf * -10.56, fitRect.origin.y + hf * 85.27)];
    [bezierPath addCurveToPoint: CGPointMake(fitRect.origin.x + wf * 212.33, fitRect.origin.y + hf * 36.26) controlPoint1: CGPointMake(fitRect.origin.x + wf * 85.9, fitRect.origin.y + hf * -12.75) controlPoint2: CGPointMake(fitRect.origin.x + wf * 164.1, fitRect.origin.y + hf * -12.75)];
    [bezierPath closePath];
    [lineColor setFill];
    [bezierPath fill];
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(fitRect.origin.x + wf * 30.5, fitRect.origin.y + hf * 30.5,
                                                                                fitRect.origin.x + wf * 188, fitRect.origin.y + hf * 189)];
    [fillColor setFill];
    [ovalPath fill];
}

+ (CGRect)HS_rectAspectFit:(CGSize)sourceSize destRect:(CGRect)destRect
{
    CGSize destSize = destRect.size;
    CGFloat destScale = [self HS_aspectScaleFit:sourceSize destRect:destRect];
    
    CGFloat newWidth = sourceSize.width * destScale;
    CGFloat newHeight = sourceSize.height * destScale;
    
    float dWidth = ((destSize.width - newWidth) / 2.0f);
    float dHeight = ((destSize.height - newHeight) / 2.0f);
    
    CGRect rect = CGRectMake(destRect.origin.x + dWidth, destRect.origin.y + dHeight, newWidth, newHeight);
    return rect;
}

+ (CGFloat)HS_aspectScaleFit:(CGSize)sourceSize destRect:(CGRect)destRect
{
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return MIN(scaleW, scaleH);
}

@end
