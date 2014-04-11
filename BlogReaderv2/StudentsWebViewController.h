//
//  StudentsWebViewController.h
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentsWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NSString * urlString;
@end
