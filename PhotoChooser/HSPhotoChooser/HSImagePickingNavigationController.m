//
//  HSImagePickingNavigationController.m
//  ContentCreationSandbox
//
//  Created by Stephen O'Connor on 22/04/16.
//  Copyright © 2016 qLearning Applications GmbH. All rights reserved.
//

#import "HSImagePickingNavigationController.h"


@interface HSImagePickingNavigationController ()

@end

@implementation HSImagePickingNavigationController

- (void)commonInit
{
    _squareEditMode = YES;
    _assetCreationBehaviour = 0;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


@end
