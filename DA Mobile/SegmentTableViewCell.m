//
//  MenuTableViewHeader.m
//  DA-Mobile
//
//  Created by Yongyang Nie on 10/19/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "SegmentTableViewCell.h"

@implementation SegmentTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.segmentedControl addTarget:self action:@selector(selectSegmentControl:) forControlEvents:UIControlEventValueChanged];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)selectSegmentControl:(id)sender{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.delegate selectedToday];
    }else{
        [self.delegate selectedTomorrow];
    }
}

@end
