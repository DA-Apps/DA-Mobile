//
//  AtheleticsViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 2/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "AtheleticsViewController.h"

@interface AtheleticsViewController ()

@end

@implementation AtheleticsViewController

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://deerfield.edu/athletics/events/"]]];
    [self.indicator startAnimating];
    self.web.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
