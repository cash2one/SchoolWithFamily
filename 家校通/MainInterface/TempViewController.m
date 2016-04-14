//
//  TempViewController.m
//  家校通
//
//  Created by Sunny on 2/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "TempViewController.h"

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.tabBarController.selectedIndex) {
        case 0:
            self.view.backgroundColor = [UIColor redColor];
            break;
        case 1:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
        case 2:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
        case 3:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

@end
