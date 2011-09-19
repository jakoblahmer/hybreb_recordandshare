//
//  RecordViewController.m
//  hybreb
//
//  Created by Jakob Lahmer on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"
#import "ProgressViewController.h"

//#import "Facebook.h"

@implementation RecordViewController

@synthesize facebook;


static NSString* fb_name;
static NSString* fb_id;
static NSString* fb_email;

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
	
    facebook = [[Facebook alloc] initWithAppId:@"123576421074972" andDelegate:self];
//	NSArray *perms = [NSArray arrayWithObjects: @"user_about_me", nil];
    NSArray* permissions = [[NSArray arrayWithObjects:@"email", nil] retain];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
	} else {
//		[facebook authorize:permissions];
		[self getUserInfo];
	}
	
	[permissions release];
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate {
	
	NSLog(@"here we go: %@ %@ %@", fb_name, fb_id, fb_email);
	
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

			NSLog(@"START USING THE VARS");
			
            ProgressViewController *pvc = [[ProgressViewController alloc] initWithNibNameAndParams:@"ProgressView" 
																			bundle:[NSBundle mainBundle] 
																			facebook_name:fb_name
																			facebook_id:fb_id
																			facebook_email:fb_email];
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
	NSLog(@"handleOpenURL");
	return [facebook handleOpenURL:url]; 
}

/**
 * Called when the user authorization the login dialog
 */
- (void)fbDidLogin {
	NSLog(@"did log in");
	NSLog(@"token %@", [facebook accessToken]);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
	[defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
	[defaults synchronize];
	
	// load user data after login
	[self getUserInfo];
}


/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)getUserInfo {
	NSLog(@"do @me request");
	[facebook requestWithGraphPath:@"me" andDelegate:self];
}


/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
	UIAlertView *alert = [[UIAlertView alloc]	initWithTitle:@"Facebook Login" 
												message:@"Bitte melde dich bei Facebook an um ein Video aufzunehmen!" 
												delegate:nil 
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	
	// if data could be loaded
	if([result objectForKey:@"name"] != NULL && [result objectForKey:@"id"] != NULL)	{
//		facebook_id = [result objectForKey:@"id"];
//		facebook_name = [result objectForKey:@"name"];
		
	
		[RecordViewController setFb_name: [result objectForKey:@"name"]];
		[RecordViewController setFb_id: [result objectForKey:@"id"]];
		[RecordViewController setFb_email: [result objectForKey:@"email"]];
		
		NSLog(@"you are logged in as %@", fb_name);
		NSLog(@"you are logged in with id %@", fb_id);
		NSLog(@"you are logged in with id %@", fb_email);
	
		[self startCameraControllerFromViewController:self usingDelegate:self];
	} else {
		UIAlertView *alert = [[UIAlertView alloc]	initWithTitle:@"Facebook Login" 
														message:@"Deine Benutzerdaten konnten nicht geladen werden, bitte authorisiere die App bei Facebook!" 
													   delegate:nil 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}

/** STATIC SETTER / GETTER **/

+ (NSString*)fb_name {
    return fb_name;
}

+ (NSString*)fb_id {
    return fb_id;
}

+ (NSString*)fb_email {
    return fb_email;
}

+ (void)setFb_name:(NSString*)newFb_name {
    if (fb_name != newFb_name) {
        [fb_name release];
        fb_name = [newFb_name copy];
    }
}


+ (void)setFb_id:(NSString*)newFb_id {
    if (fb_id != newFb_id) {
        [fb_id release];
        fb_id = [newFb_id copy];
    }
}

+ (void)setFb_email:(NSString*)newFb_email {
    if (fb_email != newFb_email) {
        [fb_email release];
        fb_email = [newFb_email copy];
    }
}


@end
