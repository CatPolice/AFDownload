//
//  ZipManager.h
//  DownLoadManager
//
//  Created by gavin on 15/6/23.
//  Copyright (c) 2015年 11 111. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipManager : NSObject

+ (void)unZip:(NSString *)unZipFilePath withZipToFilePath:(NSString *)toFilePath;

@end
