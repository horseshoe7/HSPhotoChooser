//
//  HSCameraNavigationViewController.h
//  PhotoChooser
//
//  Created by Stephen O'Connor on 21/11/15.
//  Copyright © 2015 Software Barn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPhotoEditingViewController.h"

@interface HSCameraNavigationViewController : UINavigationController

@property (nonatomic, assign) IBInspectable BOOL squareEditMode;
@property (nonatomic, assign) IBInspectable HSPhotoEditingAssetCreationBehaviour assetCreationBehaviour;

@end
