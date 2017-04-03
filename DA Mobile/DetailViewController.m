//
//  DetailViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 2/16/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

-(void)setShadowforView:(UIView *)view masksToBounds:(BOOL)masksToBounds{
    
    view.layer.cornerRadius = 15;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 3.0f);
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = masksToBounds;
}

- (void)viewDidLoad {
    
    self.contentView.text = self.contentString;
    self.imageView.image = self.contentImage;
    self.titleLabel.text = self.titleString;
    [self setShadowforView:self.contentView masksToBounds:NO];
    if (self.imageView.image == nil) {
        self.imageHeight.constant = 30;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
