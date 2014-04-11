//
//  BlogReaderv2Tests.m
//  BlogReaderv2Tests
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BlogReaderv2Tests : XCTestCase

@end

@implementation BlogReaderv2Tests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRegex
{
    NSString * string = @"#Hello";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [string substringWithRange:wordRange];
        NSLog(@"%@-> %@", word, string);
    }
    

}

- (void) testWordPressRegex
{
    NSArray * array = @[@"http://programacionconpdm.blogspot.com/favicon.ico",
                        @"http://josecolellapdm.wordpress.com/favicon.ico",
                        @"http://pdmapariciolopez.blogspot.com/favicon.ico",
                        @"http://josemlp.hosting-gratiss.com/favicon.ico",
                        @"http://rafaelgonzalezjimenez.blogspot.com/favicon.ico",
                        @"http://rmmvbs.blogspot.com/favicon.ico",
                        @"http://www.makingapps.es/favicon.ico",
                        @"http://habimaru.wordpress.com/favicon.ico",
                        @"http://themobileprogrammingblog.blogspot.com/favicon.ico",
                        @"http://applicatize.wordpress.com/favicon.ico"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^http:.+(wordpress).+\\.ico" options:0 error:nil];
    for (NSString * string in array) {
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        if (matches != nil) {
            for (NSTextCheckingResult *match in matches) {
                NSRange wordRange = [match rangeAtIndex:1];
                NSString* word = [string substringWithRange:wordRange];
                NSLog(@"%@-> %@", word, string);
            }
        } else {
            NSLog(@"Regex not found");
        }
    }


}


- (void) testBlogSpotRegex {
    NSArray * array = @[@"http://programacionconpdm.blogspot.com/favicon.ico",
                        @"http://josecolellapdm.wordpress.com/favicon.ico",
                        @"http://pdmapariciolopez.blogspot.com/favicon.ico",
                        @"http://josemlp.hosting-gratiss.com/favicon.ico",
                        @"http://rafaelgonzalezjimenez.blogspot.com/favicon.ico",
                        @"http://rmmvbs.blogspot.com/favicon.ico",
                        @"http://www.makingapps.es/favicon.ico",
                        @"http://habimaru.wordpress.com/favicon.ico",
                        @"http://themobileprogrammingblog.blogspot.com/favicon.ico",
                        @"http://applicatize.wordpress.com/favicon.ico"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^http:.+(blogspot).+\\.ico" options:0 error:nil];
    for (NSString * string in array) {
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        if (matches != nil) {
            for (NSTextCheckingResult *match in matches) {
                NSRange wordRange = [match rangeAtIndex:1];
                NSString* word = [string substringWithRange:wordRange];
                NSLog(@"%@-> %@", word, string);
            }
        } else {
            NSLog(@"Regex not found");
        }
    }
}

@end
