//
//  ProfessorTableViewController.m
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import "ProfessorTableViewController.h"
#import "BlogPost.h"
#import "ProfessorWebViewController.h"
#import <SAMCache/SAMCache.h>

@interface ProfessorTableViewController ()
@property (nonatomic) NSString * apiKey;
@property (nonatomic) NSString * blogId;
@property (nonatomic) NSString * blogIdUrlString;
@property (nonatomic) NSString * blogPostUrlString;
@property (nonatomic) NSDictionary * blogInfo;
@property (nonatomic) NSArray * posts;
@property (nonatomic) SAMCache * cache;
@end

@implementation ProfessorTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Cache for storing images
    self.cache = [SAMCache sharedCache];
    
    self.cleanPosts = [NSMutableArray array];
    self.apiKey = @"AIzaSyAuCujN0sfT_DbZuX0vygVR6xFtZEuQ9Jk";
    
    self.blogIdUrlString = [NSString stringWithFormat: @"https://www.googleapis.com/blogger/v3/blogs/byurl?url=http://www.programacionmovilesugr.blogspot.com.es/&key=%@", self.apiKey];
    
    
    if ([self.cache objectExistsForKey:@"professorBlog"]) {
        [self.cache objectForKey:@"professorBlog" usingBlock:^(id<NSCopying> object) {
            self.blogInfo = (NSDictionary *)object;
            
            self.blogId = [self.blogId valueForKey:@"id"];
            self.blogPostUrlString = [NSString stringWithFormat:@"https:www.googleapis.com/blogger/v3/blogs/%@/posts?key=%@", self.blogId, self.apiKey];
            
            if ([self.cache objectExistsForKey:@"posts"]) {
                self.posts = [self.cache objectForKey:@"posts"];
                for (NSDictionary * info in self.posts) {
                    BlogPost * post = [[BlogPost alloc] init];
                    if (![[info valueForKey:@"title"] isEqualToString:@""]) {
                        post.title = [info valueForKey:@"title"];
                        post.urlString = [info valueForKey:@"url"];
                        post.image = [info valueForKeyPath:@"author.image.url"];
                        [self.cleanPosts addObject:post];
                    }
                }
                [self.tableView reloadData];
            }
        }];
    } else {
        [self retrieveUrl:self.blogIdUrlString WithBlock:^(NSDictionary *information) {
            self.blogInfo = information;
            //saving blog information
            [self.cache setObject:self.blogInfo forKey:@"professorBlog"];
            self.blogId = [self.blogInfo valueForKey:@"id"];
            self.blogPostUrlString = [NSString stringWithFormat:@"https://www.googleapis.com/blogger/v3/blogs/%@/posts?key=%@", self.blogId, self.apiKey];
            [self retrieveUrl:self.blogPostUrlString WithBlock:^(NSDictionary *information) {
                self.posts = [information valueForKey:@"items"];
                [self.cache setObject:self.posts forKey:@"posts"];
                for (NSDictionary * info in self.posts) {
                    BlogPost * post = [[BlogPost alloc] init];
                    if (![[info valueForKey:@"title"] isEqualToString:@""]) {
                        post.title = [info valueForKey:@"title"];
                        post.urlString = [info valueForKey:@"url"];
                        post.image = [info valueForKeyPath:@"author.image.url"];
                        [self.cleanPosts addObject:post];
                        
                    }
                    
                    
                }
                [self.tableView reloadData];
            }];
        }];
    }
    
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.cleanPosts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Post";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    BlogPost * post = [self.cleanPosts objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.image]]];
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath * path = [self.tableView indexPathForSelectedRow];
        ProfessorWebViewController * destinationController = (ProfessorWebViewController *)[segue destinationViewController];
        BlogPost * post = [self.cleanPosts objectAtIndex:path.row];
        NSURL * url = [NSURL URLWithString: post.urlString];
        destinationController.url = url;
    }
}



#pragma mark - Helper Methods


/**
 *  This methods helps in retrieving url contents and returning them in an NSDictionary type.
 * This is because the contents are from a RESTful API
 *
 *  @param urlString  NSString The url string
 *  @param completion NSDictionary An NSDictionary with all the contents from the site
 */
- (void) retrieveUrl:(NSString *)urlString WithBlock:(void(^)(NSDictionary *information))completion {
    NSURLSession * session  = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieve blog id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        } else {
            NSData * responseData = [NSData dataWithContentsOfURL:location];
            NSDictionary *infomation = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(infomation);
            });
        }
    }];
    [task resume];
}

@end
