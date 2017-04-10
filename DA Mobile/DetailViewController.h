//
//  DetailViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 2/16/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"
#import "CustomTableViewCell.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImage *contentImage;
@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *postURL;

@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
