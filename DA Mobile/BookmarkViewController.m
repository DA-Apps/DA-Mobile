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

#pragma mark - CollectionView Cell Delegate

-(void)removeBookMark:(UICollectionViewCellPosts *)cell{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObject:[self.savedPosts objectAtIndex:[self.collectionView indexPathForCell:cell].row]];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    [self.collectionView reloadData];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deleted" message:@"You have deleted this post" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)saveToBookMark:(UICollectionViewCellPosts *)cell{
    
}

#pragma mark - UITableView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width, 160);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPostSmall" forIndexPath:indexPath];
    BulletinPost *post = [self.savedPosts objectAtIndex:indexPath.row];
    cell.title.text = post.title;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:post.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.image.layer.cornerRadius = 5;
    cell.image.layer.masksToBounds = YES;
    cell.canSwipe = NO;
    cell.delegate = self;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.savedPosts.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showDetail" sender:nil];
    });
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    self.savedPosts = [BulletinPost allObjects];
    [self.collectionView reloadData];
    [super viewDidAppear:YES];

}

- (void)viewDidLoad {
    
    self.savedPosts = [BulletinPost allObjects];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = [segue destinationViewController];
        DetailViewController *vc = (DetailViewController *)[nav topViewController];
        NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
        BulletinPost *post = [self.savedPosts objectAtIndex:indexPath.section];

        vc.contentString = post.content;
        vc.contentImage = post.image;
        vc.postURL = post.postURL;
        vc.titleString = post.title;
    }
}

@end
