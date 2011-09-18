//
//  RecordViewController.h
//  hybreb
//
//  Created by Jakob Lahmer on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "FBConnect.h"

@interface RecordViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBSessionDelegate, FBRequestDelegate> {

    Facebook *facebook;
	
//	IBOutlet UIButton* recordAndShareButton;
//	NSString *facebook_name;
//	NSString *facebook_id;
	
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSString *facebook_name;
@property (nonatomic, retain) NSString *facebook_id;

- (IBAction)recordButtonPressed:(id)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate;

+ (NSString*)fb_name;
+ (void)setFb_name:(NSString*)newFb_name;
+ (NSString*)fb_id;
+ (void)setFb_id:(NSString*)newFb_id;

@end
