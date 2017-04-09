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
    [self.delegate saveToBookMark:self];
}

-(void)didSwipe:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView animateWithDuration:0.5 animations:^{
            self.menuWidth.constant = 150;
            self.bookmarkButton.alpha = 1.0f;
            [self layoutIfNeeded];
        }];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        [UIView animateWithDuration:0.5 animations:^{
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
