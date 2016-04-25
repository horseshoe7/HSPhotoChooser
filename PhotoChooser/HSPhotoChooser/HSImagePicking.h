//
//  HSImagePicking.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 This means, if you provide an image as the input, should it create an asset from it, or should this controller just be used for cropping, and return a new image as the result.  Otherwise you specify when the asset should be created.  Before you start cropping, or after.  If it's before, the HSPhotoEditingResultKeyAssetNormalizedCropRect will reflect the cropping.  If after, the HSPhotoEditingResultKeyAssetNormalizedCropRect will be {0,0,1,1}.
 
 If the input is an asset, then HSPhotoEditingAssetCreationBehaviourCreateAssetFromInput will have no effect (same as HSPhotoEditingAssetCreationBehaviourNone), and HSPhotoEditingAssetCreationBehaviourCreateAssetFromOutput will create a new asset.  As above, depending on these, the normalizedCropRect will reflect that choice.
 */
typedef NS_ENUM(NSInteger, HSPhotoEditingAssetCreationBehaviour) {
    HSPhotoEditingAssetCreationBehaviourNone = 0,
    HSPhotoEditingAssetCreationBehaviourCreateAssetFromInput,
    HSPhotoEditingAssetCreationBehaviourCreateAssetFromOutputIfChanged
};

typedef NS_ENUM(NSInteger, HSPhotoSource) {
    HSPhotoSourceUnknown = 0,
    HSPhotoSourceCamera,
    HSPhotoSourceLibrary
};

typedef NS_ENUM(NSInteger, HSCameraSource) {
    HSCameraSourceUnknown = 0,
    HSCameraSourceFrontCam, /* selfie cam */
    HSCameraSourceBackCam
};

typedef NS_ENUM(NSInteger, HSCameraLighting) {
    HSCameraLightingUnknown = 0,
    HSCameraLightingOff = 1,
    HSCameraLightingFlash,
    HSCameraLightingTorch
};

// the keys that could have values in the outputInfo
static NSString * const HSPhotoEditingResultKeyAsset = @"asset";
static NSString * const HSPhotoEditingResultKeyImage = @"image";
static NSString * const HSPhotoEditingResultKeyPhotoSource = @"photoSource";
static NSString * const HSPhotoEditingResultKeyCameraSource = @"cameraSource";
static NSString * const HSPhotoEditingResultKeyCameraLighting = @"cameraLighting";

// SEGUE IDENTIFIER NAMES.
static NSString * const HSImageUploadAssetWasPickedSegueIdentifier = @"unwindPhotosAssetWasPicked";


// On any View Controller that supports image picking, you need to implement this method!
@protocol HSImagePicking <NSObject>

@required
- (IBAction)photosAssetWasPicked:(UIStoryboardSegue*)unwindSegue;  // the ImagePicking storyboard will call this!

@end
