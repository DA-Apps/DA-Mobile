//
//  CustomTableViewCell.m
//  DA Mobile
//
//  Created by Yongyang Nie on 4/9/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

-(IBAction)switchClicked:(id)sender{
    [self.delegate switchNotification:self.customSwitch.isOn];
}

-(IBAction)loadFullPost:(id)sender{
    [self.delegate loadFullPost];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
