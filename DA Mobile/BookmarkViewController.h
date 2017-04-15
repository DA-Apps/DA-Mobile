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

@interface BookmarkViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) RLMResults *savedPosts;

@end
