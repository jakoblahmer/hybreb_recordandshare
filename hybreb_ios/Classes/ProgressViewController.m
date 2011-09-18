//
//  ProgressViewController.m
//  hybreb
//
//  Created by Matthias Steinböck on 07.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressViewController.h"
#import "ASIFormDataRequest.h"


@implementation ProgressViewController

@synthesize filePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibNameAndParams:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil facebook_name:(NSString *)fbb_name facebook_id:(NSString *)fbb_id facebook_email:(NSString *)fbb_email
{
	
	fb_id = fbb_id;
	fb_name = fbb_name;
	fb_email = fbb_email;

    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"progress view loaded. now uploading... %@", filePath);
    NSURL *url = [NSURL URLWithString:@"http://www.abendstille.at/hybreb_ios/add-video/1"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setFile:filePath forKey:@"video"];
    [request setDelegate:self];
	[request setPostValue:fb_name forKey:@"fb_name"];
	[request setPostValue:fb_id forKey:@"fb_id"];
	[request setPostValue:fb_email forKey:@"fb_email"];
    [request setUploadProgressDelegate:progressView];
    [request startAsynchronous];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// upload things


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"response: %@", responseString);
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
    
    //RecordViewController *rvc = (RecordViewController *)self.parentViewController;
    [[self parentViewController] dismissModalViewControllerAnimated:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"uplERROR: %@", error);
    [[self parentViewController] dismissModalViewControllerAnimated:NO];
}
@end
