//
//  ListViewController.h
//  hybreb
//
//  Created by Jakob Lahmer on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    // the table view itself
	IBOutlet UITableView *videoTable;
    
    // list items read from json
	NSMutableArray *listOfItems;
    
    // only on loading thread at once
	BOOL loading;
    
    NSURLConnection *theConnection;
	SBJsonParser *parser;
}

@property (nonatomic, retain) IBOutlet UITableView *videoTable;

-(void) loadData;

@end
