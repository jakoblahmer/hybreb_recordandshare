//
//  ListViewController.h
//  hybreb
//
//  Created by Jakob Lahmer on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface ListViewController : UIViewController {
	IBOutlet UITableView *videoTable;
	NSMutableArray *listOfItems;
	
	SBJsonParser *parser;
}

@property (nonatomic, retain) IBOutlet UITableView *videoTable;

@end
