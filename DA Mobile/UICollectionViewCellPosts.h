//
//  UICollectionViewCellPosts.h
//  DA Mobile
//
//  Created by Yongyang Nie on 1/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCellPosts : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mainWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuWidth;
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIView *rightView;
@property BOOL canSwipe;
@property (nonatomic, strong) id delegate;

@end

@protocol UICollectionViewCellPostsDelegate <NSObject>

@optional

-(void)saveToBookMark:(UICollectionViewCellPosts *)cell;
-(void)removeBookMark:(UICollectionViewCellPosts *)cell;

@end
