//
//  UICollectionViewCellPosts.h
//  DA Mobile
//
//  Created by Yongyang Nie on 1/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCellPosts : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UITextView *summery;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textHeight;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
