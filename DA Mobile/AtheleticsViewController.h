//
//  AtheleticsViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 2/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtheleticsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *web;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;

@end
