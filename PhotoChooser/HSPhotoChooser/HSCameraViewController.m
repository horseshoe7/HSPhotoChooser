//
//  HSCameraViewController.m
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


#import "HSCameraViewController.h"
#import <FastttCamera.h>
#import "HSPhotoEditingViewController.h"
#import "UIImage+CameraButton.h"
#import "HSImagePickingNavigationController.h"

static NSInteger const kSegmentedControlIndexFlashOff = 0;
static NSInteger const kSegmentedControlIndexFlashOn = 1;
static NSInteger const kSegmentedControlIndexFlashTorch = 2;

@interface HSSquareCameraMaskView : UIView
{
    UIColor *_maskColor;
}
@end

@implementation HSSquareCameraMaskView

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [super setBackgroundColor:[UIColor clearColor]];
        _maskColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    return self;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _maskColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect iR; // insideRect
    
    BOOL portrait = self.bounds.size.width < self.bounds.size.height;
    
    iR.size.width = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width : self.bounds.size.height;
    iR.size.height = iR.size.width;
    
    if (portrait) {
        iR.origin.x = 0;
        iR.origin.y = (self.bounds.size.height - iR.size.height)/2.f;
    }
    else
    {
        iR.origin.y = 0;
        iR.origin.x = (self.bounds.size.width - iR.size.height)/2.f;
    }
    
    CGRect oR = self.bounds; // outsideRect
    
 
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    CGContextAddRect(c, CGContextGetClipBoundingBox(c));
    
    // go counter-clockwise around iR
    CGContextMoveToPoint(c, iR.origin.x, iR.origin.y);
    CGContextAddLineToPoint(c, iR.origin.x, iR.origin.y + iR.size.height);
    CGContextAddLineToPoint(c, iR.origin.x + iR.size.width, iR.origin.y + iR.size.height);
    CGContextAddLineToPoint(c, iR.origin.x + iR.size.width, iR.origin.y);
    CGContextClosePath(c);
    CGContextEOClip(c);
    CGContextMoveToPoint(c, oR.origin.x, oR.origin.y);
    CGContextAddLineToPoint(c, oR.origin.x + oR.size.width, oR.origin.y);
    CGContextAddLineToPoint(c, oR.origin.x + oR.size.width, oR.origin.y + oR.size.height);
    CGContextAddLineToPoint(c, oR.origin.x, oR.origin.y + oR.size.height);
    CGContextAddLineToPoint(c, oR.origin.x, oR.origin.y);
    
    CGContextSetFillColorWithColor(c, _maskColor.CGColor);
    
    CGContextFillPath(c);
    CGContextRestoreGState(c);
}

@end


@interface HSCameraViewController ()<FastttCameraDelegate>
{
    BOOL _squareEditMode;
    HSPhotoEditingAssetCreationBehaviour _assetCreationBehaviour;
}
@property (nonatomic, strong) FastttCamera *fastCamera;

@property (nonatomic, weak) IBOutlet HSSquareCameraMaskView *maskView;
@property (nonatomic, weak) IBOutlet UIButton *snapButton;
@property (nonatomic, weak) IBOutlet UISegmentedControl *flashMode;
@property (nonatomic, weak) IBOutlet UIButton *flipButton;

@property (nonatomic, strong) UIImage *capturedImage;

@property (nonatomic, assign) HSCameraLighting lighting;
@property (nonatomic, assign) HSCameraSource source;

@end

@implementation HSCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera belowSubview:self.maskView];
    self.fastCamera.view.frame = self.view.frame;
    
    if (![FastttCamera isCameraDeviceAvailable:FastttCameraDeviceRear])
    {
        self.flipButton.hidden = YES;
    }
    
    [self updateSegmentedControl];
    
    [self updateSnapButton];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSegmentedControl
{
    if (![FastttCamera isFlashAvailableForCameraDevice:self.fastCamera.cameraDevice]) {
        [self.flashMode setEnabled:NO forSegmentAtIndex:kSegmentedControlIndexFlashOn];
    }
    else
    {
        [self.flashMode setEnabled:YES forSegmentAtIndex:kSegmentedControlIndexFlashOn];
    }
    
    if (![FastttCamera isTorchAvailableForCameraDevice:self.fastCamera.cameraDevice]) {
        [self.flashMode setEnabled:NO forSegmentAtIndex:kSegmentedControlIndexFlashTorch];
    }
    else
    {
        [self.flashMode setEnabled:YES forSegmentAtIndex:kSegmentedControlIndexFlashTorch];
    }

}

- (void)updateSnapButton
{
    UIImage *normal, *highlighted;
    
    normal = [UIImage HS_iOSCameraButtonWithSize:self.snapButton.bounds.size
                                     highlighted:NO];
    
    [self.snapButton setTitle:nil forState:UIControlStateNormal];
    [self.snapButton setImage:normal forState:UIControlStateNormal];
    
    
    highlighted = [UIImage HS_iOSCameraButtonWithSize:self.snapButton.bounds.size
                                          highlighted:YES];
    
    [self.snapButton setImage:highlighted forState:UIControlStateHighlighted];
    
}

#pragma mark - Actions

- (IBAction)pressedSnapButton:(id)sender
{
    [self.fastCamera takePicture];
}

- (IBAction)pressedFlipButton:(id)sender
{
    if(self.fastCamera.cameraDevice == FastttCameraDeviceFront)
    {
        if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceRear]) {
            [self.fastCamera setCameraDevice:FastttCameraDeviceRear];
        }
    }
    else if (self.fastCamera.cameraDevice == FastttCameraDeviceRear)
    {
        if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceFront]) {
            [self.fastCamera setCameraDevice:FastttCameraDeviceFront];
        }
    }
    
    [self updateSegmentedControl];
    
}

- (IBAction)pressedSegmentedControl:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case kSegmentedControlIndexFlashOff:
            [self.fastCamera setCameraTorchMode:FastttCameraTorchModeOff];
            [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOff];
            break;
        case kSegmentedControlIndexFlashOn:
            [self.fastCamera setCameraTorchMode:FastttCameraTorchModeOff];
            [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOn];
            break;
        case kSegmentedControlIndexFlashTorch:
            [self.fastCamera setCameraTorchMode:FastttCameraTorchModeOn];
            [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOff];
            break;
        default:
            break;
    }
}

#pragma mark - IFTTTFastttCameraDelegate

- (void)cameraController:(FastttCamera *)cameraController
 didFinishCapturingImage:(FastttCapturedImage *)capturedImage
{
    /**
     *  Here, capturedImage.fullImage contains the full-resolution captured
     *  image, while capturedImage.rotatedPreviewImage contains the full-resolution
     *  image with its rotation adjusted to match the orientation in which the
     *  image was captured.
     */
}

- (void)cameraController:(FastttCamera *)cameraController
didFinishScalingCapturedImage:(FastttCapturedImage *)capturedImage
{
    /**
     *  Here, capturedImage.scaledImage contains the scaled-down version
     *  of the image.
     */
}

- (void)cameraController:(FastttCamera *)cameraController
didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage
{
    /**
     *  Here, capturedImage.fullImage and capturedImage.scaledImage have
     *  been rotated so that they have image orientations equal to
     *  UIImageOrientationUp. These images are ready for saving and uploading,
     *  as they should be rendered more consistently across different web
     *  services than images with non-standard orientations.
     */
    _capturedImage = capturedImage.fullImage;  // we keep this briefly so to instantiate the destination view controller
    
    [self performSegueWithIdentifier:@"showPhotoEditor" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showPhotoEditor"]) {
        HSPhotoEditingViewController *editorVC = [segue destinationViewController];
        editorVC.input = self.capturedImage;
        _capturedImage = nil;
        editorVC.photoSource = HSPhotoSourceCamera;
        editorVC.assetCreationBehaviour = self.assetCreationBehaviour;
        editorVC.squareEditMode = self.squareEditMode;
        
        if(self.fastCamera.cameraDevice == FastttCameraDeviceFront){
            editorVC.cameraSourceOrNil = @(HSCameraSourceFrontCam);
        }
        else if (self.fastCamera.cameraDevice == FastttCameraDeviceRear)
        {
            editorVC.cameraSourceOrNil = @(HSCameraSourceBackCam);
        }
        
        switch (self.flashMode.selectedSegmentIndex) {
            case kSegmentedControlIndexFlashOff:
                editorVC.cameraLightingOrNil = @(HSCameraLightingOff);
                break;
            case kSegmentedControlIndexFlashOn:
                editorVC.cameraLightingOrNil = @(HSCameraLightingFlash);
                break;
            case kSegmentedControlIndexFlashTorch:
                editorVC.cameraLightingOrNil = @(HSCameraLightingTorch);
                break;
            default:
                break;
        }
        
    }
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


@end
