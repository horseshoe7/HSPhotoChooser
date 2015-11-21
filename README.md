# HSPhotoChooser

HSPhotoChooser is an attempt to make a drop-in storyboard to your project that allows you to choose a photo from the library or camera, crop it, then pass that back to the UIViewController that segued to it.

It comes with a pre-made storyboard that you can create a reference to.

## Features

- Easy, drop in code, you can use a storyboard reference.
- Choose an image from your Camera Roll or using the camera
- Image Cropping
- Option to create assets for your Camera Roll or NOT.  You can create assets from the cropped image too, if desired.  Or have it work completely independently of the Photos Library.
- Works with UIImage and/or PHAsset objects


## How it works

Clone the repo, run pod install, then have a look at the demo project.  You'll see in Main.storyboard that there is one view controller that will trigger a segue to the referenced Storyboard.  Then look in ViewController.m to see how this implementation is easy.  You just support a protocol method (for an unwind segue) and you can see how you work with the data there.

## License

MIT.

## Contact

Stephen O'Connor.  oconnor.freelance@gmail.com

