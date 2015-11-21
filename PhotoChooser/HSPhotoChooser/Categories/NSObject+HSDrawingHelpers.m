//
//  NSObject+DrawingHelpers.m
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


#import "NSObject+HSDrawingHelpers.h"

@implementation NSObject (HSDrawingHelpers)

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

+ (CGRect)HS_rectAspectFill:(CGSize)sourceSize fitSize:(CGSize)fitSize
{    
    float sourceWidth = sourceSize.width;
    float sourceHeight = sourceSize.height;
    float targetWidth = fitSize.width;
    float targetHeight = fitSize.height;
    BOOL cropping = YES;
	
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    CGRect sourceRect, destRect;
    if (cropping) {
        destRect = CGRectMake(0, 0, targetWidth, targetHeight);
        float destX, destY;
        
        destX = round((scaledWidth - targetWidth) / 2.0);
        destY = round((scaledHeight - targetHeight) / 2.0);
        
        sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
        destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
    }

    return destRect;
}

+ (CGRect)HS_rectFromPointA:(CGPoint)ptA pointB:(CGPoint)ptB
{
    CGRect r = CGRectMake(MIN(ptA.x, ptB.x),
                          MIN(ptA.y, ptB.y),
                          fabs(ptA.x - ptB.x),
                          fabs(ptA.y - ptB.y));
    
    return r;
}

+ (CGPoint)HS_lineVectorFromOrigin:(CGPoint)origin toDestination:(CGPoint)destination
{
    CGPoint lineVector;
    lineVector.x = destination.x - origin.x;
    lineVector.y = destination.y - origin.y;
    
    return lineVector;
}

+ (CGPoint)HS_unitVectorOfVector:(CGPoint)vector
{
    CGPoint unitVector;
    unitVector.x = vector.x / sqrtf(vector.x * vector.x + vector.y * vector.y);
    unitVector.y = vector.y / sqrtf(vector.x * vector.x + vector.y * vector.y);
    
    return unitVector;
}

+ (CGPoint)HS_vectorProjectionFromOrigin:(CGPoint)origin direction:(CGPoint)directionVector length:(CGFloat)length
{
    CGPoint projection = origin;
    CGPoint unitVector = [self HS_unitVectorOfVector:directionVector];
    projection.x += unitVector.x * length;
    projection.y += unitVector.y * length;
    
    return projection;
    
}
+ (CGPoint)HS_rotatePoint:(CGPoint)point aroundPivotPoint:(CGPoint)pivotPoint angle:(CGFloat)radians
{
    CGAffineTransform translation, rotation;
	
    translation	= CGAffineTransformMakeTranslation(-pivotPoint.x, -pivotPoint.y);
	point		= CGPointApplyAffineTransform(point, translation);  // temporarily set pivot point to the origin
    
	rotation	= CGAffineTransformMakeRotation(radians);
	point		= CGPointApplyAffineTransform(point, rotation); // rotate it
    
	translation	= CGAffineTransformMakeTranslation(pivotPoint.x, pivotPoint.y);
	point		= CGPointApplyAffineTransform(point, translation);  // now put it back
    
	return point;
}

+ (CGPoint)HS_centerOfRect:(CGRect)rect roundToPixelBoundary:(BOOL)roundValues
{
    CGPoint center;
    if (roundValues) {
        center.x = roundf(CGRectGetMidX(rect));
        center.y = roundf(CGRectGetMidY(rect));
    }
    else
    {
        center.x = CGRectGetMidX(rect);
        center.y = CGRectGetMidY(rect);
    }
    return center;
}

+ (CGPoint)HS_midpointBetweenPointA:(CGPoint)ptA pointB:(CGPoint)ptB
{
    CGPoint retVal;
    CGPoint aToB;
    aToB.x = ptB.x - ptA.x;
    aToB.y = ptB.y - ptA.y;
    
    retVal = [self HS_vectorProjectionFromOrigin:ptA direction:aToB length:0.5f];
    return retVal;
}

+ (CGPoint)HS_pointA:(CGPoint)ptA minus:(CGPoint)ptB
{
    return (CGPoint){ptA.x - ptB.x, ptA.y - ptB.y};
}

+ (CGPoint)HS_pointA:(CGPoint)ptA plus:(CGPoint)ptB
{
    return (CGPoint){ptA.x + ptB.x, ptA.y + ptB.y};
}

@end
