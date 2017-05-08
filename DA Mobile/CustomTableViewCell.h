//
//  CustomTableViewCell.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/9/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet id delegate;

@end

@protocol CustomTableViewCellDelegate <NSObject>

-(void)loadFullPost;

@end
