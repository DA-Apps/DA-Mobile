/*
 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz
 Copyright (c) 2016-2017 Yongyang Nie
 
 */

#import "RearViewController.h"
#import "AtheleticsViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"


@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Menu", nil);
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *text = nil;
    if (row == 0)
        text = @"Home";
    else if (row == 1)
        text = @"DAInfo";
    else if (row == 2)
        text = @"Email";
    else if (row == 3)
        text = @"Canvas";
    else if (row == 4)
        text = @"Table Rotation";
    
    cell.textLabel.text = NSLocalizedString(text, nil);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return

    if (row == 0){
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    else if (row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dainfo.deerfield.edu/"]];
        
    }
    else if (row == 2){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mail.deerfield.edu/owa/"]];
    }
    else if (row == 3){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deerfield.instructure.com/"]];
    }
    else if (row == 4){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deerfield.edu/wp-content/uploads/2017/01/2017-Jan-Rotation-by-TABLE-2.pdf"]];
    }
    _presentedRow = row;  // <- store the presented row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
