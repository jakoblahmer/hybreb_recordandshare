//
//  RecordViewController.m
//  hybreb
//
//  Created by Jakob Lahmer on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"
#import "ProgressViewController.h"
#import "Facebook.h"

@implementation RecordViewController

@synthesize facebook;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    facebook = [[Facebook alloc] initWithAppId:@"123576421074972" andDelegate:self];
    NSArray *perms = [NSArray arrayWithObjects: @"user_about_me", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ([facebook isSessionValid]) {
        [facebook requestWithGraphPath:@"me" andDelegate:self];
    } else {
        [facebook authorize:perms];
    }
    
    [perms release];
}


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
	
    // capture only 20 seconds
	[cameraUI setVideoMaximumDuration:20];
    
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
	
	// Handle a movie capture
	if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
		
		NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
		
		// save in photo album
		if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
			
			UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);

            ProgressViewController *pvc = [[ProgressViewController alloc] initWithNibName:@"ProgressView" bundle:[NSBundle mainBundle]];
            pvc.filePath = moviePath;
            //[self.navigationController pushViewController:pvc animated:YES];
            
            [[picker parentViewController] dismissModalViewControllerAnimated: NO];
            
            [self presentModalViewController: pvc animated: NO];
        } else {
            [[picker parentViewController] dismissModalViewControllerAnimated: YES];
        }
		
	} else {
        [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    }
	
	// hide camera ui
	[picker release];
}

- (void)dealloc {
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [facebook handleOpenURL:url]; 
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"you are logged in as %@", [result objectForKey:@"name"]);
}

@end
