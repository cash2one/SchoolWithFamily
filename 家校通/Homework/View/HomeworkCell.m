//
//  HomeworkCell.m
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "HomeworkCell.h"

@implementation HomeworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _scoreLabel.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
