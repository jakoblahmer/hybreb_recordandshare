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
}
@property (nonatomic, retain) NSString *filePath;

@end
