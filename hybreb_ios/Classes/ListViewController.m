//
//  ListViewController.m
//  hybreb
//
//  Created by Jakob Lahmer on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"


@implementation ListViewController

@synthesize videoTable;

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
	
	listOfItems = [[NSMutableArray alloc] init];
	
	// load data from url
	NSURL* url = [NSURL URLWithString:@"http://localhost/hybreb_ios/test.php"];
	NSError* error = nil;
	NSData* data = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if (error) {
		NSLog(@"Error %@, %@", error, [error userInfo]);
		// ... handle error
	}
	else {
		NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
		NSLog(@"Loaded data: %@", newStr);
	}
	
	
	[listOfItems addObject:@"test1"];
	[listOfItems addObject:@"test2"];
	[listOfItems addObject:@"test3"];
	[listOfItems addObject:@"test4"];
	
//	self.navigationItem.title = @"Videos";
	
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



// return number of elements in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [listOfItems count];
}


// views one row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	
	return cell;
}

- (void)dealloc {
	[listOfItems release];
    [super dealloc];
}


@end
