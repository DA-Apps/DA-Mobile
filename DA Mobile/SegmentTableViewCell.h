//
//  MenuTableViewHeader.h
//  DA-Mobile
//
//  Created by Yongyang Nie on 10/19/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) id delegate;

@end

@protocol SegmentTableViewCellDelegate <NSObject>

-(void)selectedToday;
-(void)selectedTomorrow;

@end
