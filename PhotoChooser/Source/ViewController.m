//
//  ViewController.m
//  PhotoChooser
//
//  Created by Stephen O'Connor on 21/11/15.
//  Copyright © 2015 Software Barn. All rights reserved.
//

#import "ViewController.h"
#import "HSPhotoChooser.h"

@interface ViewController ()<HSPhotoChoosingProtocol>
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

- (IBAction)HS_userFinishedSelectingPhoto:(UIStoryboardSegue *)sender
{
    if ([sender.sourceViewController isKindOfClass:[HSPhotoEditingViewController class]]) {
        
        HSPhotoEditingViewController *editor = sender.sourceViewController;
        
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
        HSCameraNavigationViewController *cameraNav = [segue destinationViewController];
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
