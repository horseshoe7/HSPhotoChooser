# Camera and Photos View Controllers and Storyboard

## Introduction

This bit of code will one day be packaged into a Cocoapod, but in the meantime, you can import it
and hack it to your heart's content.

Just

Contents:
- HSCameraViewController.h/.m
- HSPhotoEditingViewController.h/.m
- HSGridViewCell.h/.m
- HSPhotoSelectionViewController.h/.m
- UIImage+CameraButton.h/.m
- This file
- HSImagePicking.xcassets
- HSImagePicking.storyboard
- HSImagePicking.h

Required Dependencies / Cocoapods:

pod 'PEPhotoCropEditor', '~> 1.3'
pod "FastttCamera"


## Usage

You can use Storyboard references to segue to this flow.  It can be used either as a Modal view controller or can be pushed.  In which case you will want to choose the right storyboard identifier.

HSImagePicking.WithNavigationController will have everything embedded in a UINavigationController (easiest for Modal presentations)
HSImagePicking.NoNavigationController  is what you want if you just want to push the whole flow onto an existing navigation controller stack

The Initial View Controller is HSImagePicking.WithNavigationController

NOTE:  You should make sure you know if you are triggering a UINavigationController or a HSPhotoSelectionViewController so to set defaults

##Sample Unwind Method:

```
- (IBAction)photosAssetWasPicked:(UIStoryboardSegue*)unwindSegue
{

    id sourceVC = [unwindSegue sourceViewController];

    if ([sourceVC isKindOfClass:[HSPhotoEditingViewController class]]) {

        HSPhotoEditingViewController *editor = sourceVC;


        if (editor.outputInfo) {

            HSPhotoSource photoSource = (HSPhotoSource)[editor.outputInfo[HSPhotoEditingResultKeyPhotoSource] integerValue];
            NSNumber *camLightingOrNil = editor.outputInfo[HSPhotoEditingResultKeyCameraLighting];  // call integerValue and cast to HSCameraLighting
            NSNumber *camSourceOrNil = editor.outputInfo[HSPhotoEditingResultKeyCameraSource];  // call integerValue and cast to HSCameraSource
        }

        // whether one of these are set or the other, depends on the value of .assetCreationBehavior
        PHAsset *assetResult = editor.outputInfo[HSPhotoEditingResultKeyAsset];
        UIImage *imageResult = editor.outputInfo[HSPhotoEditingResultKeyImage];


        // we assume we set it up to return a UIImage.  Your implementation might use PHAsset objects
        [self prepareImageForUpload:imageResult];
    }
    else
    {
        [self imagePickingWasCanceled];
    }
}

- (void)prepareImageForUpload:(UIImage*)image
{
    __weak MyViewController *weakself = self;

    if (image) {
        // do something.  Set the Image View to something.

        // or upload to a webservice then set the imageView.  These are your details...

        weakself.userImageView.image = image;
        weakself.imageIcon.hidden = YES;  // i.e. that thing that you display over an empty avatar image view
        weakself.imagePromptLabel.hidden = YES;  // a text label that accompanies the above
    }
    else
    {
        [self imagePickingWasCanceled];
    }
}

- (void)imagePickingWasCanceled
{
    // another sample method.  Maybe you were changing your current image, but you canceled.

    BOOL hasImage = (self.userImageView.image != nil);

    self.imageIcon.hidden = hasImage;
    self.imagePromptLabel.hidden = hasImage;
}
```