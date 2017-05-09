//
//  DetailViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 2/16/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "DGActivityIndicatorView.h"
#import "CustomTableViewCell.h"
#import "BulletinPost.h"
#import "UIImageView+WebCache.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CustomTableViewCellDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSString *contentImage;
@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *postURL;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
