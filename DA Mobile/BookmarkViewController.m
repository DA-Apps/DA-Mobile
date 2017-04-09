//
//  BookmarkViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 4/9/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "BookmarkViewController.h"

@interface BookmarkViewController ()

@end

@implementation BookmarkViewController

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPostSmall" forIndexPath:indexPath];
    BulletinPost *post = [self.savedPosts objectAtIndex:indexPath.row];
    cell.title.text = post.title;
    cell.image.image = [UIImage imageWithData:post.image];
    cell.image.layer.cornerRadius = 5;
    cell.image.layer.masksToBounds = YES;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.savedPosts.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width, 160);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)viewDidAppear:(BOOL)animated{
    self.savedPosts = [BulletinPost allObjects];
    [self.collectionView reloadData];
    NSLog(@"%@", self.savedPosts);
    [super viewDidAppear:YES];

}

- (void)viewDidLoad {
        [super viewDidLoad];
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
