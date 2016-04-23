//
//  HSImagePickingNavigationController.h
//  ContentCreationSandbox
//
//  Created by Stephen O'Connor on 22/04/16.
//  Copyright © 2016 qLearning Applications GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSImagePicking.h"


@interface HSImagePickingNavigationController : UINavigationController

@property (nonatomic, assign) HSPhotoEditingAssetCreationBehaviour assetCreationBehaviour;  // HSPhotoEditingAssetCreationBehaviourNone is default.
@property (nonatomic, assign) BOOL squareEditMode;  // defaults to yes

@end
