//
//  BlogPost.m
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

/**
 *  Returns a NSString description of the BlogPost object
 *
 *  @return NSString A NSString representation of a BlogPost
 */
- (NSString *)description {
    return [NSString stringWithFormat: @"Title: %@ | Image=%@ | Url=%@", self.title, self.image, self.urlString];
}
@end
