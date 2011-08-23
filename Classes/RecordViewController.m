//
//  RecordViewController.m
//  hybreb
//
//  Created by Jakob Lahmer on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"


@implementation RecordViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction)recordButtonPressed:(id)sender {
	
	NSLog(@"Button pressed!");
	
	[self startCameraControllerFromViewController:self usingDelegate:self];
	
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate {
	
    if (([UIImagePickerController isSourceTypeAvailable:
		  
		  UIImagePickerControllerSourceTypeCamera] == NO)
		
		|| (delegate == nil)
		
		|| (controller == nil))
		
        return NO;
	
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
	
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	cameraUI.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
	
    // Displays controls for video
	cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
	
	
	// Hides the controls for moving & scaling pictures, or for
	
    // trimming movies. To instead show the controls, use YES.
	
    cameraUI.allowsEditing = NO;
	
	cameraUI.delegate = delegate;
	
	// show camera ui
	[controller presentModalViewController: cameraUI animated: YES];
	
    return YES;
	
}

// For responding to the user tapping Cancel.

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
	// remove from view
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
	
    [picker release];
	
}



// For responding to the user accepting a newly-captured picture or movie

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
	
	NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
	
    UIImage *originalImage, *editedImage, *imageToSave;
	
    // Handle a still image capture
	
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
		
		== kCFCompareEqualTo) {
		
		
		
        editedImage = (UIImage *) [info objectForKey:
								   
								   UIImagePickerControllerEditedImage];
		
        originalImage = (UIImage *) [info objectForKey:
									 
									 UIImagePickerControllerOriginalImage];
		
		
		
        if (editedImage) {
			
            imageToSave = editedImage;
			
        } else {
			
            imageToSave = originalImage;
			
        }
		
		
		
		// Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
		
    }
	
	
	
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
		
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
		
		// save in photo album
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
			
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
		}
		
		// @TODO
		// upload to page
    }
	
	// hide camera ui
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker release];
	
}




- (void)dealloc {
    [super dealloc];
}


@end
