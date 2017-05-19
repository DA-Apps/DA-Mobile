//
//  PreferenceViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 5/17/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface PreferenceViewController : UIViewController <CustomTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) NSMutableArray *data;

@end
