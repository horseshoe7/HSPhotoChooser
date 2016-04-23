//
//  HSPhotoEditingViewController.h
//
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


#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PECropViewController.h"
#import "HSImagePickingNavigationController.h"



@interface HSPhotoEditingViewController : PECropViewController

// one or the other will be set, not both!
@property (nonatomic, strong) id input;  // if an image, from the camera, not a PHAsset yet.  Or a PHAsset

// "output"
@property (nonatomic, strong) NSDictionary *outputInfo;

// NOTE!  Is readonly if you instantiated this View Controller via a storyboard and its embedded in a HSImagePickingNavigationController!
@property (nonatomic, assign) BOOL squareEditMode;
@property (nonatomic, assign) HSPhotoEditingAssetCreationBehaviour assetCreationBehaviour;

// set these before segueing to this View controller
@property (nonatomic, assign) HSPhotoSource photoSource;
@property (nonatomic, strong) NSNumber *cameraSourceOrNil;  // wraps a HSCameraSource
@property (nonatomic, strong) NSNumber *cameraLightingOrNil; // wraps a HSCameraLighting

@end
