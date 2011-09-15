//
//  ListViewController.m
//  hybreb
//
//  Created by Jakob Lahmer on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "ListViewController.h"


@implementation ListViewController

@synthesize videoTable;
@synthesize movieController;

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

    loading = NO;
    
    //[listOfItems retain];
    videoTable.delegate = self;
    
    // [self loadData];
    [super viewDidLoad];
}

- (void) loadData {
    if (loading) return;
	// reset items
    listOfItems = [[NSMutableArray alloc] init];
    
    
	// load data from url
	NSString* url = @"http://www.abendstille.at/hybreb_ios/list-videos/10";
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    loading = YES;
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


- (void)dealloc {
    NSLog(@"deallocating list");
	[listOfItems release];
	[parser release];
    [videoTable release];
    [super dealloc];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Connection didReceiveAuthenticationChallenge - should not happen: %@", challenge);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Connection didReceiveData of length: %u", data.length);
    
	// Parse the new chunk of data. The parser will append it to
	// its internal buffer, then parse from where it left off in
	// the last chunk.
    NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
    // TODO: insert check, if newStr == null, if so, try to load again
    NSLog(@"Loaded data: %@", newStr);
    
    parser = [[SBJsonParser alloc] init];
    
    NSArray *jsonData = [parser objectWithString:newStr];
    
    for (NSDictionary *dict in jsonData) {
        //NSLog(@"bla: %@ : %@ : %@ : %@", [dict objectForKey:@"name"], [dict objectForKey:@"author"], [dict objectForKey:@"length"], [dict objectForKey:@"url"]);
        [listOfItems addObject: dict];
    }
    
    [videoTable reloadData];
    loading = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}

#pragma mark Table View Data Source Methods


// return number of elements in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [listOfItems count];
}


// views one row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [self.videoTable dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	NSDictionary *cellValue = [listOfItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellValue objectForKey:@"name"];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"von %@ - %@ sec", [cellValue objectForKey:@"author"], [cellValue objectForKey:@"length"]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Item selected - %d", indexPath.row);
    NSLog(@"we have items: %d", [listOfItems count]); // does not work. bad access :(
    
    NSDictionary *myCell = [listOfItems objectAtIndex:indexPath.row];
    //NSLog(@"Showing video at %@", [cellValue objectForKey:@"name"]);
    if (myCell != NULL) {
        //NSEnumerator *mynum = [myCell keyEnumerator];
        //NSString *thisObject;
        //while (thisObject = [mynum nextObject])
        //{
        //    NSLog(@"thisObject: %@", thisObject);
        //}

        NSLog(@"loading vide from %@", [myCell objectForKey:@"url"]);
        
        [self showMovie:[myCell objectForKey:@"url"]];
    } else {
        NSLog(@"no cell value accessible :/");
    }
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[cellValue objectForKey:@"url"]]];
}

- (void)willEnterFullscreen:(NSNotification*)notification {
    NSLog(@"willEnterFullscreen");
}

- (void)enteredFullscreen:(NSNotification*)notification {
    NSLog(@"enteredFullscreen");
}

- (void)willExitFullscreen:(NSNotification*)notification {
    NSLog(@"willExitFullscreen");
}

- (void)exitedFullscreen:(NSNotification*)notification {
    NSLog(@"exitedFullscreen");
    [self.movieController.view removeFromSuperview];
    self.movieController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification*)notification {
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackFinished. Reason: Playback Ended");         
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackFinished. Reason: Playback Error");
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
    [self.movieController setFullscreen:NO animated:YES];
}

- (void)showMovie:(NSString*)movie {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    NSURL* movieURL =  [NSURL URLWithString:movie];
    self.movieController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    self.movieController.view.frame = self.view.frame;
    [self.view addSubview:movieController.view];
    [self.movieController setFullscreen:YES animated:YES];
    [self.movieController play];
}

@end
