//
//  UICollectionViewCellPosts.m
//  DA Mobile
//
//  Created by Yongyang Nie on 1/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "UICollectionViewCellPosts.h"

@implementation UICollectionViewCellPosts

-(IBAction)saveBookmark:(id)sender{
    
    if (self.canSwipe) {
        [self.delegate saveToBookMark:self];
        [UIView animateWithDuration:0.35 animations:^{
            self.menuWidth.constant = 0;
            self.bookmarkButton.alpha = 0.0f;
            [self layoutIfNeeded];
        }];
    }else{
        [self.delegate removeBookMark:self];
        [UIView animateWithDuration:0.35 animations:^{
            self.menuWidth.constant = 0;
            self.bookmarkButton.alpha = 0.0f;
            [self layoutIfNeeded];
        }];
    }
    
}

-(void)didSwipe:(UISwipeGestureRecognizer *)swipe{
    
    if (self.canSwipe) {
        [self.bookmarkButton setImage:[UIImage imageNamed:@"Bookmark-icon"] forState:UIControlStateNormal];
        [self.bookmarkButton setImage:[UIImage imageNamed:@"Bookmark-icon"] forState:UIControlStateSelected];
        self.rightView.backgroundColor = [UIColor colorWithRed:0/225.0 green:128.0/225.0 blue:0.0/225.0 alpha:1.0];
    }else{
        [self.bookmarkButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        [self.bookmarkButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateSelected];
        self.rightView.backgroundColor = [UIColor colorWithRed:211.0/225.0 green:0.0/225.0 blue:0.0/225.0 alpha:1.0];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView animateWithDuration:0.35 animations:^{
            self.menuWidth.constant = 120;
            self.bookmarkButton.alpha = 1.0f;
            [self layoutIfNeeded];
        }];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        [UIView animateWithDuration:0.35 animations:^{
            self.menuWidth.constant = 0;
            self.bookmarkButton.alpha = 0.0f;
            [self layoutIfNeeded];
        }];
    }
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.bookmarkButton.alpha = 0.0f;
    self.mainWidth.constant = [UIScreen mainScreen].bounds.size.width;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    
    // Initialization code
}

@end
