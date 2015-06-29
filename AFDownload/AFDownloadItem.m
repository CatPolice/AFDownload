
//
//  AFDownloadItem.m
//  AFDownload
//
//  Created by gavin on 15/6/29.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "AFDownloadItem.h"

@implementation AFDownloadItem


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.url  forKey:@"url"];
    [aCoder encodeObject:self.progrees forKey:@"progrees"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.operation forKey:@"operation"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setUrl:[aDecoder decodeObjectForKey:@"url"]];
        [self setProgrees:[aDecoder decodeObjectForKey:@"progrees"]];
        [self setState:[aDecoder decodeObjectForKey:@"state"]];
        [self setOperation:[aDecoder decodeObjectForKey:@"operation"]];
    }
    return self;
}
@end
