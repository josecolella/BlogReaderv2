//
//  BlogPost.h
//  BlogReaderv2
//
//  Created by Jose Colella on 07/04/2014.
//  Copyright (c) 2014 Jose Colella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogPost : NSObject
@property (nonatomic) NSString * blogUrlString;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * image;
@property (nonatomic) NSString * urlString;

- (NSString *)description;
@end
