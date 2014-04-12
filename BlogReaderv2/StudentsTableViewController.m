//
//  StudentsTableViewController.m
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import "StudentsTableViewController.h"
#import "StudentsWebViewController.h"
#import <HTMLNode.h>
#import <HTMLParser.h>
#import <SAMCache/SAMCache.h>

@interface StudentsTableViewController ()
@property (nonatomic) NSMutableArray * blogPostURLArray;
@property (nonatomic) NSMutableArray * blogPostTitleArray;
@property (nonatomic) NSMutableArray * blogIconArray;
@property (nonatomic) NSMutableArray * blogThumbnailsArray;
@property (nonatomic) NSString * html;
@property (nonatomic) SAMCache * cache;
@end

@implementation StudentsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Method that is called the view is about to appear
 *
 *  @param animated If the view will be animated
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    self.cache = [[SAMCache alloc] initWithName:@"StudentCache"];
    self.blogThumbnailsArray = [NSMutableArray array];
    
    if ([self.cache objectExistsForKey:@"studentHTML"]) {
        [self.cache objectForKey:@"studentHTML" usingBlock:^(id<NSCopying> object) {
            self.html = (NSString *)object;
            
        }];
    } else {
        [self retrieveStudentPosts:@"http://programacionmovilesugr.blogspot.com.es/" WithBlock:^(NSString *information) {
            self.html = information;
            [self retrieveCleanPosts:self.html];
        }];
    }
    

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
    return [self.blogPostTitleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString * studentPost = [self.blogPostTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    if (![studentPost isEqualToString:@""]) {
        cell.textLabel.text = studentPost;
    } else {
        cell.textLabel.text = @"[Notice] No post by student";
    }
    
    
    
    UIImage *image = [self retrieveImageForUser:[self.blogIconArray objectAtIndex:indexPath.row]];
    cell.imageView.image = image;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath * path = [self.tableView indexPathForSelectedRow];

        StudentsWebViewController * webView = (StudentsWebViewController *)segue.destinationViewController;
        webView.urlString = [self.blogPostURLArray objectAtIndex:path.row];

    }
}


/**
 *  This method retrieves the html from the blog. The html is returned in a completion
 *  block as an NSString
 *  @param urlString  NSString The string that denotes the url
 *  @param completion NSString The html retrieved
 */
- (void) retrieveStudentPosts:(NSString *)urlString WithBlock:(void(^)(NSString *information))completion {
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSString * htmlContentString = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(htmlContentString);
        });
    }];
    [task resume];
}



#pragma mark - Helper Methods

/**
 *  This method retrieves the students posts from the blogspot site.
 *  The retrieval is done through parsing of the HTML
 *
 *
 *  @param html NSString The html from the page
 */
- (void) retrieveCleanPosts:(NSString *)html{
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:nil];
    
    HTMLNode *bodyNode = [parser body];
    NSArray *urlNodeArray = [bodyNode findChildrenOfClass:@"blog-title"];
    NSArray *postNodeArray = [bodyNode findChildrenOfClass:@"item-title"];
    NSArray *iconNodeArray = [bodyNode findChildrenOfClass:@"blog-icon"];
    
    self.blogIconArray = [NSMutableArray array];
    self.blogPostTitleArray = [NSMutableArray array];
    self.blogPostURLArray = [NSMutableArray array];
    
    if ([self.cache objectExistsForKey:@"studentIcons"]) {
        self.blogIconArray = [self.cache objectForKey:@"studentIcons"];
    } else {
        [self retrieveStudentIcon:&iconNodeArray :self.blogIconArray];
    }
    if ([self.cache objectExistsForKey:@"studentPosts"]) {
        self.blogPostTitleArray = [self.cache objectForKey:@"studentPosts"];
    } else {
        [self retrieveStudentPost:&postNodeArray :self.blogPostTitleArray];
    }
    if ([self.cache objectExistsForKey:@"studentUrls"]) {
        self.blogPostURLArray = [self.cache objectForKey:@"studentUrls"];
    } else {
        [self retrieveStudentUrl:&urlNodeArray :self.blogPostURLArray];
    }
    [self.tableView reloadData];
    
}
/**
 *  This helper method retrieves the student blog url and stores them in 
 * an NSMutableArray
 *
 *  @param urlNodeArray  NSArray The HTMLNode array that contains the url info
 *  @param urlStoreArray NSMutable Where the url will be stored
 */
- (void)retrieveStudentUrl:(NSArray **)urlNodeArray :(NSMutableArray *)urlStoreArray {
    for (HTMLNode * node in *urlNodeArray) {
        NSString * url = [[[node children] objectAtIndex:1] getAttributeNamed:@"href"];
        url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [urlStoreArray addObject:url];
    }
    
}
/**
 *  This helper method retrieves the student icon url and stores them in
 *  an NSMutableArray
 *  @param iconNodeArray  NSArray array of HTMLNode that contain the icon's url
 *  @param iconStoreArray NSMutableArray the array where the url strings will be stored
 */
- (void) retrieveStudentIcon:(NSArray **)iconNodeArray :(NSMutableArray *)iconStoreArray {
    for (HTMLNode * node in *iconNodeArray) {
        NSString * imageUrlString = [[node children][1] getAttributeNamed:@"data-lateloadsrc"];
        if (imageUrlString != nil) {
            [iconStoreArray addObject: imageUrlString];
        }
    }
}
/**
 *  This helper method retrieves the student's posts and stores them in
 *  an NSMutableArray
 *
 *  @param postNodeArray  NSArray the array of HTMLNode where the posts reside
 *  @param postStoreArray NSMutableArray the array where the posts will be stored
 */
- (void) retrieveStudentPost:(NSArray **)postNodeArray :(NSMutableArray *)postStoreArray {
    for (HTMLNode * node in *postNodeArray) {
        if([[node children] count] > 1) {
            NSString * post = [[[node children] objectAtIndex:1] contents];
            post = [post stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [postStoreArray addObject:post];
        }
    }
    
}


/**
 *  This method determines whether an NSString matches an NSRegularExpression
 *
 *  @param regex  NSRegularExpression the regex to use
 *  @param string NSString The string to search
 *
 *  @return YES if the regex can be matched NO otherwise
 */
- (BOOL) isRegex:(NSRegularExpression *)regex InString:(NSString *)string {
    BOOL isRegex = false;
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    if (matches != nil) {
        for (NSTextCheckingResult *match in matches) {
            NSRange wordRange = [match rangeAtIndex:1];
            NSString* word = [string substringWithRange:wordRange];
            if (word != nil) {
                isRegex = true;
            }
        }
    }
    
    return isRegex;
}

/**
 *  Returns whether a url string is a wordpress address
 *
 *  @param string NSString The blog url string
 *
 *  @return BOOL YES if blog is a wordpress address no otherwiser
 */
- (BOOL) isWordPressBlog:(NSString *)string {
    
    BOOL isWordPressBlog = false;
    
    NSRegularExpression *wordPressRegex = [NSRegularExpression regularExpressionWithPattern:@"^http:.+(wordpress).+\\.ico" options:0 error:nil];
    isWordPressBlog = [self isRegex:wordPressRegex InString:string];
    
    return isWordPressBlog;
}

/**
 *  Returns whether a url string is a blogspot address
 *
 *  @param string The url address of the blog
 *
 *  @return BOOL YES if blog is a blogspot address NO otherwiser
 */
- (BOOL) isBlogSpotBlog:(NSString *)string {
    BOOL isBlogSpotBlog = false;
    
    NSRegularExpression *blogSpotRegex = [NSRegularExpression regularExpressionWithPattern:@"^http:.+(blogspot).+\\.ico" options:0 error:nil];
    isBlogSpotBlog = [self isRegex:blogSpotRegex InString:string];
    return isBlogSpotBlog;
}

/**
 *  This method retrieves the thumbnail that corresponds to the 
 * user's blog
 *
 *  @param url NSString The string that corresponds to the url
 *
 *  @return UIImage The image that corresponds to the user
 */
- (UIImage *)retrieveImageForUser:(NSString *)url {
    
    UIImage *image = nil;
    
    if ([self isWordPressBlog:url]) {
        NSString * imageKey = [NSString stringWithFormat:@"wordpress_%lu",(unsigned long)[url hash]];
        if ([self.cache objectExistsForKey:imageKey]) {
            image = [UIImage imageWithData:[self.cache objectForKey:imageKey]];
        } else {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage * imageOriginal = [UIImage imageWithData:data];
            image = [UIImage imageWithCGImage:[imageOriginal CGImage] scale:(imageOriginal.scale * 0.3) orientation:imageOriginal.imageOrientation];
            NSData *imageData = UIImagePNGRepresentation(image);
            [self.cache setObject:imageData forKey:imageKey];
        }
    } else if([self isBlogSpotBlog:url]) {
        NSString * imageKey = [NSString stringWithFormat:@"blogspot_%lu",(unsigned long)[url hash]];
        if ([self.cache objectExistsForKey:imageKey]) {
            image = [UIImage imageWithData:[self.cache objectForKey:imageKey]];
        } else {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage * imageOriginal = [UIImage imageWithData:data];
            image = [UIImage imageWithCGImage:[imageOriginal CGImage] scale:(imageOriginal.scale * 0.3) orientation:imageOriginal.imageOrientation];
            NSData *imageData = UIImagePNGRepresentation(image);
            [self.cache setObject:imageData forKey:imageKey];
        }
    } else {
        image = [UIImage imageNamed:@"person"];
    }
    
    return image;
}


@end
