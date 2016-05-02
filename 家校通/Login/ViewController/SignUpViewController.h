//
//  SignUpViewController.h
//  家校通
//
//  Created by Sunny on 5/2/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *signUpID;
@property (weak, nonatomic) IBOutlet UITextField *signUpPassword;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (strong, nonatomic) NSString *group;
- (IBAction)chooseGroup;
- (IBAction)signUp;
- (IBAction)canncel;

@end
