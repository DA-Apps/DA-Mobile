//
//  DetailViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 2/16/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) UIImage *contentImage;
@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) NSString *titleString;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
