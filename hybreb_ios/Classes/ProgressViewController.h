//
//  ProgressViewController.h
//  hybreb
//
//  Created by Matthias Steinböck on 07.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressViewController : UIViewController {
    IBOutlet UIProgressView *progressView;
    NSString *filePath;
	NSString *fb_name;
	NSString *fb_id;
	NSString *fb_email;
}
@property (nonatomic, retain) NSString *filePath;

- (id)initWithNibNameAndParams:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil facebook_name:(NSString *)fbb_name facebook_id:(NSString *)fbb_id facebook_email:(NSString *)fbb_email;

@end
