//
//  DetailViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 2/16/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController (){
    BOOL complete;
    NSTimer *loadingTimer;
}

@end

@implementation DetailViewController

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:self.contentImage] placeholderImage:[UIImage imageNamed:@"ph_1.jpg"]];
            cell.image.layer.cornerRadius = 5;
            cell.image.layer.masksToBounds = YES;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
            cell.title.text = self.titleString;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            cell.content.text = self.contentString;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
            cell.delegate = self;
            break;
        default:
            break;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 240;
            break;
        case 1:
            return 90;
            break;
        case 2:
            return self.contentString.length / 50 * 28 + 45;
            break;
        case 3:
            return 55;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - Private

-(void)loadFullPost{
    
    self.progressView.hidden = NO;
    self.table.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.postURL]]];
    self.progressView.progress = 0;
    complete = false;

    loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    complete = true;
}

-(void)timerCallback {
    
    if (complete) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [loadingTimer invalidate];
        }
        else {
            self.progressView.progress += 0.01;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.95) {
            self.progressView.progress = 0.95;
        }
    }
}

-(IBAction)save:(id)sender{
    [self savePosts:self.title withContent:self.contentString withImage:self.contentImage withLink:self.postURL];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post Saved" message:@"You have bookmarked this post" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePosts:(NSString *)title withContent: (NSString *)content withImage:(NSString *)image withLink:(NSString *)url{
    
    BulletinPost *post = [[BulletinPost alloc] init];
    post.title = title;
    post.content = content;
    post.image = image;
    post.postURL = url;
    
    if (![self contains:title]){
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:post];
        }];
    }
}

-(BOOL)contains:(NSString *)title {
    for (BulletinPost *post in [BulletinPost allObjects]){
        if ([post.title isEqualToString:title])
            return YES;
    }
    return NO;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    self.progressView.hidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
