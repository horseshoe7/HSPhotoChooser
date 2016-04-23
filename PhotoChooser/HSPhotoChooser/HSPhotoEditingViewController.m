//
//  HSPhotoEditingViewController.m
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


#import "HSPhotoEditingViewController.h"
#import <Photos/Photos.h>
#import "HSImagePickingNavigationController.h"




@interface PECropViewController(private)
- (void)done:(id)sender;
@end

@interface HSPhotoEditingViewController ()<PECropViewControllerDelegate>
{
    BOOL _squareEditMode;
    HSPhotoEditingAssetCreationBehaviour _assetCreationBehaviour;
}
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *outputImage;

@end

@implementation HSPhotoEditingViewController



- (void)configureViewControllerForSquareEditModeState:(BOOL)squareEditMode
{
    if (squareEditMode) {
        self.cropAspectRatio = 1.0f;
        self.keepingCropAspectRatio = YES;
        self.toolbarHidden = YES;
    }
    else
    {
        self.cropAspectRatio = 0;
        self.keepingCropAspectRatio = NO;
        self.toolbarHidden = NO;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    
    NSAssert(self.input != nil, @"You need to provide an input object for this controller to work!");
    NSAssert([self.input isKindOfClass:[UIImage class]] || [self.input isKindOfClass:[PHAsset class]], @"Designed to work with images or assets");
    NSAssert(self.navigationController, @"Thought he'd be embedded by now!");
    
    [self configureViewControllerForSquareEditModeState:self.squareEditMode];
    
    if ([self.input isKindOfClass:[PHAsset class]]) {
        // get image from asset
        self.asset = (PHAsset*)self.input;
        [self setImageFromAsset:(PHAsset*)self.input];
    }
    else if ([self.input isKindOfClass:[UIImage class]])
    {
        // use image
        if (self.assetCreationBehaviour == HSPhotoEditingAssetCreationBehaviourCreateAssetFromInput) {
            [self createAssetFromImage:(UIImage *)self.input
                            completion:nil];
        }
        
        [self setImage:(UIImage*)self.input];
    }
}

- (void)createAssetFromImage:(UIImage*)image completion:(void(^)(BOOL success, NSError *error))completion
{
    // Add it to the photo library
    __block NSString *assetIdentifier = nil;
    
    __weak HSPhotoEditingViewController *weakself = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        PHObjectPlaceholder *pl = assetChangeRequest.placeholderForCreatedAsset;
        assetIdentifier = pl.localIdentifier;
        
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error creating asset: %@", error);
        }
        else
        {
            PHFetchResult *results = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier]
                                                                      options:nil];
            
            PHAsset *asset = results.firstObject;
            weakself.asset = asset;
        }
        
        // was causing a crash bug.  Apparently this completionHandler is not called on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(success, error);
            }
            
        });
        
    }];
}


- (void)setImageFromAsset:(PHAsset*)asset
{
    // todo:  this.  do this.
    if (asset) {
        // do something.  Set the Image View to something.
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:PHImageManagerMaximumSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:options
                                                resultHandler:^(UIImage *result, NSDictionary *info)
         {
             
             [self setImage:result];
         }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{    
    // Add it to the photo library
    __weak HSPhotoEditingViewController *weakself = self;
    
    switch (self.assetCreationBehaviour) {
        case HSPhotoEditingAssetCreationBehaviourNone: {
            self.outputImage = croppedImage;
            [self finishUp];
            break;
        }
        case HSPhotoEditingAssetCreationBehaviourCreateAssetFromInput: {

            self.outputImage = croppedImage;
            [self finishUp];
            break;
        }
        case HSPhotoEditingAssetCreationBehaviourCreateAssetFromOutputIfChanged: {

            self.outputImage = croppedImage;
            [self createAssetFromImage:croppedImage
                            completion:^(BOOL success, NSError *error) {
                                // finish up
                                [weakself finishUp];
                            }];
            break;
        }
        default: {
            break;
        }
    }

}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    self.outputInfo = nil;
    [self performSegueWithIdentifier:HSImageUploadAssetWasPickedSegueIdentifier sender:self];
}

- (void)finishUp
{
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    if (self.outputImage) {
        results[HSPhotoEditingResultKeyImage] = self.outputImage;
    }
    if (self.asset) {
        results[HSPhotoEditingResultKeyAsset] = self.asset;
    }
    if (self.cameraSourceOrNil) {
        results[HSPhotoEditingResultKeyCameraSource] = self.cameraSourceOrNil;
    }
    if (self.cameraLightingOrNil) {
        results[HSPhotoEditingResultKeyCameraLighting] = self.cameraLightingOrNil;
    }
    results[HSPhotoEditingResultKeyPhotoSource] = @(self.photoSource);
    
    self.outputInfo = results;
    
    [self performSegueWithIdentifier:HSImageUploadAssetWasPickedSegueIdentifier sender:self];
}

#pragma mark - Semi-derived Properties

- (void)setSquareEditMode:(BOOL)squareEditMode
{
    if (self.navigationController && [self.navigationController isKindOfClass:[HSImagePickingNavigationController class]]) {
        [(HSImagePickingNavigationController*)self.navigationController setSquareEditMode: squareEditMode];
    }
    else
    {
        if (squareEditMode != _squareEditMode) {
            _squareEditMode = squareEditMode;
        }
    }
    
}

- (BOOL)squareEditMode
{
    if (self.navigationController && [self.navigationController isKindOfClass:[HSImagePickingNavigationController class]]) {
        return [(HSImagePickingNavigationController*)self.navigationController squareEditMode];
    }
    else
    {
        return _squareEditMode;
    }
}

- (void)setAssetCreationBehaviour:(HSPhotoEditingAssetCreationBehaviour)assetCreationBehaviour
{
    if (self.navigationController && [self.navigationController isKindOfClass:[HSImagePickingNavigationController class]]) {
        [(HSImagePickingNavigationController*)self.navigationController setAssetCreationBehaviour:assetCreationBehaviour];
    }
    else
    {
        if (assetCreationBehaviour != _assetCreationBehaviour) {
            _assetCreationBehaviour = assetCreationBehaviour;
        }
    }
    
}

- (HSPhotoEditingAssetCreationBehaviour)assetCreationBehaviour
{
    if (self.navigationController && [self.navigationController isKindOfClass:[HSImagePickingNavigationController class]]) {
        return [(HSImagePickingNavigationController*)self.navigationController assetCreationBehaviour];
    }
    else
    {
        return _assetCreationBehaviour;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
