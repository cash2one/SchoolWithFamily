//
//  HomeworkDetailViewController.h
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkDetailViewController : UIViewController

@property (strong, nonatomic) NSString *homeworkId;
@property (strong, nonatomic) NSString *homeworkTitle;
@property (strong, nonatomic) NSString *uploader;
@property (strong, nonatomic) NSString *homeworkDetail;
@property (strong, nonatomic) NSString *uploadDate;
@property (strong, nonatomic) NSString *score;

@end
