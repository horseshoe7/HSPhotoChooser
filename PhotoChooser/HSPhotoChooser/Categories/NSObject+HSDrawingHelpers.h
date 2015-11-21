//
//  NSObject+DrawingHelpers.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface NSObject (HSDrawingHelpers)

+ (CGPoint)HS_vectorProjectionFromOrigin:(CGPoint)origin direction:(CGPoint)directionVector length:(CGFloat)length;
+ (CGPoint)HS_rotatePoint:(CGPoint)point aroundPivotPoint:(CGPoint)pivotPoint angle:(CGFloat)radians;
+ (CGPoint)HS_lineVectorFromOrigin:(CGPoint)origin toDestination:(CGPoint)destination;  // i.e. adding the result of this to origin will give you the destination
+ (CGRect)HS_rectAspectFit:(CGSize)sourceSize destRect:(CGRect)destRect;
+ (CGRect)HS_rectAspectFill:(CGSize)sourceSize fitSize:(CGSize)fitSize;
+ (CGFloat)HS_aspectScaleFit:(CGSize)sourceSize destRect:(CGRect)destRect;


+ (CGRect)HS_rectFromPointA:(CGPoint)ptA pointB:(CGPoint)ptB;
+ (CGPoint)HS_centerOfRect:(CGRect)rect roundToPixelBoundary:(BOOL)roundValues;
+ (CGPoint)HS_midpointBetweenPointA:(CGPoint)ptA pointB:(CGPoint)ptB;

+ (CGPoint)HS_pointA:(CGPoint)ptA plus:(CGPoint)pointB;
+ (CGPoint)HS_pointA:(CGPoint)ptA minus:(CGPoint)pointB;

@end
