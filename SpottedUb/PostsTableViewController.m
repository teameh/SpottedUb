//
//  PostsTableViewController.m
//  SpottedUb
//
//  Created by Tieme van Veen on 1/9/13.
//  Copyright (c) 2012 Tieme van Veen, Wout Hoekstra
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PostsTableViewController.h"
#import "AppDelegate.h"
#import "PostCell.h"
#import "FacebookManager.h"
#import "Post.h"
#import "NSDate+TimeAgo.h"

@interface PostsTableViewController ()

@end

@implementation PostsTableViewController
@synthesize posts;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosts:) name:SCSessionStateChangedNotification object:nil];
    
    _testTextView = [[UITextView alloc] initWithFrame:CGRectMake(2000, 0, 320, 480)];
    [_testTextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    _testTextView.font = [UIFont systemFontOfSize:14.0];
    [_testTextView setOpaque:NO];
    [_testTextView setAlpha:0.5];
    [_testTextView setUserInteractionEnabled:NO];
    
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:204./255. green:0./255. blue:0./255. alpha:1]];

    [[self tableView] setBackgroundColor:[UIColor colorWithRed:255./255. green:206./255. blue:206./255. alpha:1]];
    [[self tableView] setAllowsSelection:NO];
    [[self tableView] setAllowsSelectionDuringEditing:NO];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setScrollsToTop:YES];
    
    [[self view] addSubview:[self testTextView]];
    
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [[self refreshControl] setTintColor:[UIColor colorWithRed:204./255. green:0./255. blue:0./255. alpha:1]];
    [[self refreshControl] addTarget:self action:@selector(loadPosts:) forControlEvents:UIControlEventValueChanged];
    
    [[self loadMoreButton] setBackgroundImage:[[UIImage imageNamed:@"top_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 7, 6, 7)] forState:UIControlStateNormal];
    [[self loadMoreButton] setHidden:YES];
    
    [[self loadMoreSpinner] setAlpha:0];
    [[self loadMoreSpinner] stopAnimating];
}

- (void) loadPosts:(id)object{
    [self downloadPosts:NO];
}
- (IBAction)loadMorePosts:(id)sender {
    [self downloadPosts:YES];
    
    [[self loadMoreSpinner] startAnimating];

    [UIView animateWithDuration:0.3 animations:^() {
        [[self loadMoreSpinner] setAlpha:1];
    }];
 
}

- (IBAction)loadFullData:(id)sender {
}

- (void) downloadPosts:(BOOL)more{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[self refreshControl] beginRefreshing];
    
    [[FacebookManager defaultManager] getPosts:(BOOL)more withBlock:^(NSArray *newPosts) {
        
        self.posts = newPosts;
        [[self tableView] reloadData];
        [[self refreshControl] endRefreshing];
        
        if([[FacebookManager defaultManager] nextURL] != nil){
            [[self loadMoreButton] setHidden:NO];
        }else{
            [[self loadMoreButton] setHidden:YES];
        }
        
        [[self loadMoreSpinner] setAlpha:0];
        [[self loadMoreSpinner] stopAnimating];
        
    } failure:^(NSError *theError) {
        NSLog(@"Error: %@", [theError localizedDescription]);
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    if([[FBSession activeSession] isOpen]){
        
        NSLog(@"session is open");
        
        [self downloadPosts:NO];
        
    }else{
        
        NSLog(@"session not open");
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate checkAndShowLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    int width = self.view.frame.size.width - 8 - 16;
    self.testTextView.frame = CGRectMake(5000, 0, width, 400);
    
    Post *post = [[self posts] objectAtIndex:indexPath.row];
    self.testTextView.text = [post shortMessage];
    
    CGFloat height = self.testTextView.contentSize.height;
    
    int longer = 0;
    
    if([post fullData]){
        longer = 100;
    }
    
    return height + 33 + 10 + 26 + 3 + longer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self posts] count];
}

- (UIView  *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([[self posts] count] == 0){
        static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
        UIView *view = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];

        UIImageView *bgView = (UIImageView*)[view viewWithTag:123];
        [bgView setImage:[[UIImage imageNamed:@"top_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 7, 6, 7)]];
        return view;
    }
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([[self posts] count] == 0) ? 44 : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Post *post = [[self posts] objectAtIndex:indexPath.row];

    [[cell dateLabel] setText:[[post date] timeAgo]];
    [[cell postTextView] setText:[post shortMessage]];
    [[cell likeLabel] setText:[NSString stringWithFormat:@"%d", [post likes]]];
    [[cell commentLabel] setText:[NSString stringWithFormat:@"%d", [post comments]]];
    
    [[cell commentsButton] setTag:indexPath.row];
    [[cell likeButton] setTag:indexPath.row];
        
    if([post liked] == NO){
        [[cell likeButton] setTitle:@"Vind ik leuk" forState:UIControlStateNormal];
    }else{
        [[cell likeButton] setTitle:@"Geliked" forState:UIControlStateNormal];
    }
   
    DLog(@"likebutton %@ commentbutton %@",[[[cell likeButton] titleLabel] text], [[[cell commentsButton] titleLabel] text]);
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:255./255. green:206./255. blue:206./255. alpha:1]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}
- (IBAction)commentButtonPressed:(UIButton *)sender {
    
    Post *post = [[self posts] objectAtIndex:sender.tag];
    NSURL *url = [NSURL URLWithString:[@"fb://profile/" stringByAppendingString:[post plainPostID]]];
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];        
    }else{
        url = [NSURL URLWithString:[@"http://m.facebook.com/" stringByAppendingString:[post plainPostID]]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    //    [[PostManager defaultManager] getPostDetail:[post postID] index:sender.tag withBlock:^(NSArray *newPosts) {
//        NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//        [[self tableView] reloadRowsAtIndexPaths:@[path] withRowAnimation:15];
//    } failure:^(NSError *theError) {
//        //do nothing
//    }];
    
//    [post allData] objectForKey:<#(id)#>
    
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    int row = sender.tag;
    
    Post *post = [[self posts] objectAtIndex:row];
    
    [[FacebookManager defaultManager] likePost:post withBlock:^(id post) {

        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
        [[self tableView] reloadRowsAtIndexPaths:@[path] withRowAnimation:15];
            
    } failure:^(NSError *theError) {
        //do nothing
    }];
}
@end
