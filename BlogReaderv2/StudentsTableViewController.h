//
//  StudentsTableViewController.h
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentsTableViewController : UITableViewController

# pragma mark - Helper Method

- (void) retrieveStudentPosts:(NSString *)urlString WithBlock:(void(^)(NSString *information))completion;

@end
