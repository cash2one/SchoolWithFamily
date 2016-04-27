//
//  HomeworkTableViewController.h
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkTableViewController : UITableViewController

@property (strong, nonatomic) id <ChangeStatusBarDelegate> delegate;

@end
