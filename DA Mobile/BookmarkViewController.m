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

#pragma mark - UITableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (self.savedPosts.count != 0) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm] deleteObject:[self.savedPosts objectAtIndex:indexPath.row]];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        [self.tableView reloadData];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deleted" message:@"You have deleted this post" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.savedPosts.count == 0) {
        EmptyNotifierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyNotifier" forIndexPath:indexPath];
        cell.icon.image = [UIImage imageNamed:@"Empty Box.png"];
        cell.mainTitle.text = @"No Saved Content";
        cell.secondTitle.text = @"You can bookmark posts in the bulletin tab";
        cell.userInteractionEnabled = NO;
        return cell;
    }else{
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellPostSmall" forIndexPath:indexPath];
        BulletinPost *post = [self.savedPosts objectAtIndex:indexPath.row];
        cell.title.text = post.title;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[self getPostImage:post.image]] placeholderImage:[UIImage imageNamed:@"ph_1.jpg"]];
        cell.image.layer.cornerRadius = 5;
        cell.image.layer.masksToBounds = YES;
        return cell;
    }
}

-(NSString *)getPostImage:(NSString *)imageLink{
    
    if (imageLink)
        return imageLink;
    else{
        int i = arc4random_uniform(6);
        return [NSString stringWithFormat:@"ph_%i.jpg", i];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.savedPosts.count == 0) {
        return self.tableView.bounds.size.height - 180;
    }
    return 145;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showDetail" sender:nil];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.savedPosts.count == 0)
        return 1;
    else
        return self.savedPosts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    self.savedPosts = [BulletinPost allObjects];
    [self.tableView reloadData];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
    }

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
