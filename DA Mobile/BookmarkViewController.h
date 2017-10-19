//
//  BookmarkViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/9/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "BulletinPost.h"
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ContentTableViewCell.h"

@interface BookmarkViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) RLMResults *savedPosts;

@end
