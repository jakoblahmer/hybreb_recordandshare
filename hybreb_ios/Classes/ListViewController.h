//
//  ListViewController.h
//  hybreb
//
//  Created by Jakob Lahmer on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    // the table view itself
	IBOutlet UITableView *videoTable;
    
    // list items read from json
	NSMutableArray *listOfItems;
    
    // movieController
    MPMoviePlayerController *movieController;
    
    // connection and parser for json loading the list
    NSURLConnection *theConnection;
	SBJsonParser *parser;
    
    // only on loading thread at once
	BOOL loading;
}

@property (nonatomic, retain) IBOutlet UITableView *videoTable;
@property (nonatomic, retain) MPMoviePlayerController *movieController;

- (void) loadData;
- (void)showMovie:(NSString*)movieURL;

@end
