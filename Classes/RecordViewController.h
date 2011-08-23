//
//  RecordViewController.h
//  hybreb
//
//  Created by Jakob Lahmer on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>


@interface RecordViewController : UIViewController {

}

- (IBAction)recordButtonPressed:(id)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate;


@end
