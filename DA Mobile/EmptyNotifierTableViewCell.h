//
//  EmptyNotifierTableViewCell.h
//  DA-Mobile
//
//  Created by Yongyang Nie on 10/19/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyNotifierTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;

@end
