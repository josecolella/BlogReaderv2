//
//  ProfessorTableViewController.h
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessorTableViewController : UITableViewController
@property (nonatomic) NSMutableArray * cleanPosts;

#pragma mark - Helper Methods

/**
 *  This method retrieves url content with an asynchronous block. 
 *  This method returns an NSDictionary with the JSON content, since
 * this method is used to interact with a RESTful API
 *
 *  @param urlString  NSString The string that denotes the url
 *  @param completion NSDictionary The JSON content of the website
 */
- (void) retrieveUrl:(NSString *)urlString WithBlock:(void(^)(NSDictionary *information))completion;

@end
