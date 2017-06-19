//
//  UICollectionViewCellPosts.m
//  DA Mobile
//
//  Created by Yongyang Nie on 1/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "UICollectionViewCellPosts.h"

@interface UICollectionViewCellPosts ()

@property CGPoint startPoint;

@end

@implementation UICollectionViewCellPosts

-(void)panAccessoryViewLeft:(CGPoint)translation{
    self.menuWidth.constant = self.startPoint.x - translation.x;
    if (self.menuWidth.constant > 170) {
        [self endPanAccessoryView:translation];
    }
}

-(void)panAccessoryViewRight:(CGPoint)translation{
    self.menuWidth.constant = self.menuWidth.constant - ((translation.x - self.startPoint.x) / 2);
    if (self.menuWidth.constant > 170) {
        [self endPanAccessoryView:translation];
    }
}

-(void)beginPanAccessoryView:(CGPoint)translation{
    self.startPoint = translation;
    [self swipeCompletionHandler];
}
-(void)endPanAccessoryView:(CGPoint)translation{
    
    if (self.menuWidth.constant > 90) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:10.0 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.menuWidth.constant = 130;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.menuOpened = YES;
        }];
    }else{
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:5.0 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.menuWidth.constant = 0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.menuOpened = NO;
            
        }];
    }
}

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

-(void)swipeCompletionHandler{
    
    if (self.canSwipe) {
        [self.bookmarkButton setImage:[UIImage imageNamed:@"Bookmark-icon"] forState:UIControlStateNormal];
        [self.bookmarkButton setImage:[UIImage imageNamed:@"Bookmark-icon"] forState:UIControlStateSelected];
        self.rightView.backgroundColor = [UIColor colorWithRed:0/225.0 green:128.0/225.0 blue:0.0/225.0 alpha:1.0];
    }else{
        [self.bookmarkButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        [self.bookmarkButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateSelected];
        self.rightView.backgroundColor = [UIColor colorWithRed:211.0/225.0 green:0.0/225.0 blue:0.0/225.0 alpha:1.0];
    }
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.bookmarkButton.alpha = 0.0f;
    self.mainWidth.constant = [UIScreen mainScreen].bounds.size.width;
}

@end
