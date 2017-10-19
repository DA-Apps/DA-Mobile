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

/*-(void)removeBookMark:(UICollectionViewCellPosts *)cell{
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObject:[self.savedPosts objectAtIndex:[self.collectionView indexPathForCell:cell].row]];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    [self.collectionView reloadData];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deleted" message:@"You have deleted this post" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}*/
-(void)saveToBookMark:(UICollectionViewCellPosts *)cell{
    
}

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellPostSmall" forIndexPath:indexPath];
    BulletinPost *post = [self.savedPosts objectAtIndex:indexPath.row];
    cell.title.text = post.title;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:post.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.image.layer.cornerRadius = 5;
    cell.image.layer.masksToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showDetail" sender:nil];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.savedPosts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    self.savedPosts = [BulletinPost allObjects];
    if (self.savedPosts.count == 0) {
        
    }else{
        
    }
    [self.tableView reloadData];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    
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
    
    DetailViewController *vc = (DetailViewController *)[segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    BulletinPost *post = [self.savedPosts objectAtIndex:indexPath.row];
    
    vc.contentString = post.content;
    vc.contentImage = post.image;
    vc.postURL = post.postURL;
    vc.titleString = post.title;
}

@end
