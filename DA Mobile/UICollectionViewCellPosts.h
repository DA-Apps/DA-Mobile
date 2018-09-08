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
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *blurEffectView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageRightBound;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLeftBound;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleBgLeftBound;

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIView *rightView;

@property BOOL canSwipe;
@property BOOL menuOpened;
@property (nonatomic, strong) id delegate;

-(void)panAccessoryViewRight:(CGPoint)translation;
-(void)panAccessoryViewLeft:(CGPoint)translation;
-(void)beginPanAccessoryView:(CGPoint)translation;
-(void)endPanAccessoryView:(CGPoint)translation;

@end

@protocol UICollectionViewCellPostsDelegate <NSObject>

@optional

-(void)saveToBookMark:(UICollectionViewCellPosts *)cell;
-(void)removeBookMark:(UICollectionViewCellPosts *)cell;

@end
