//
//  HomeworkCell.h
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
