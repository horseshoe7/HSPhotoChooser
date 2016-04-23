//
//  ViewController.m
//  PhotoChooser
//
//  Created by Stephen O'Connor on 21/11/15.
//  Copyright © 2015 Software Barn. All rights reserved.
//

#import "ViewController.h"
#import "HSImagePicking.h"
#import "HSPhotoEditingViewController.h"

@interface ViewController ()<HSImagePicking>
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedCameraButton:(id)sender
{
    [self performSegueWithIdentifier:@"camera" sender:self];
}

- (IBAction)photosAssetWasPicked:(UIStoryboardSegue*)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[HSPhotoEditingViewController class]]) {
        
        HSPhotoEditingViewController *editor = unwindSegue.sourceViewController;
        
        if (editor.outputInfo) {
            NSLog(@"%@", editor.outputInfo);
            [self processChosenImage:editor.outputInfo[HSPhotoEditingResultKeyImage]];
        }
        else
        {
            [self imagePickingWasCancelled];
        }
    }
    else
    {
        [self imagePickingWasCancelled];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // set up any properties you want regarding how editing should occur.
    if ([segue.identifier isEqualToString:@"camera"]) {
        HSImagePickingNavigationController *cameraNav = [segue destinationViewController];
        cameraNav.squareEditMode = YES;
        cameraNav.assetCreationBehaviour = HSPhotoEditingAssetCreationBehaviourNone;
    }
}

- (void)processChosenImage:(UIImage*)image
{
    self.imageView.image = image;
}

- (void)processChosenAsset:(PHAsset*)asset
{
    
}

- (void)imagePickingWasCancelled
{
    
}

@end
