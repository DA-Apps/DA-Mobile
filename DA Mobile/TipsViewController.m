
//
//  TipsViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 5/23/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

-(void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"What can you do with DA Mobile?";
    page1.titleFont = [UIFont systemFontOfSize:35];
    page1.titlePositionY = 350;
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@"bg1@2x"];
    // custom

    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"intros_2"];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"intros_1"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.frame andPages:@[page1,page4,page3]];
    intro.delegate = self;
    [intro showInView:self.navigationController.view animateDuration:0.0];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
