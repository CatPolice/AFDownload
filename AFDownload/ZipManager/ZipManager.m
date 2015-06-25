//
//  ZipManager.m
//  DownLoadManager
//
//  Created by gavin on 15/6/23.
//  Copyright (c) 2015年 11 111. All rights reserved.
//

#import "ZipManager.h"

#import "zlib.h"
#import "ZipArchive.h"

@implementation ZipManager



+ (void)unZip:(NSString *)unZipFilePath withZipToFilePath:(NSString *)toFilePath{
    
    __block BOOL result;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        ZipArchive *za = [[ZipArchive alloc] init];
        
        if ([za UnzipOpenFile:unZipFilePath]) {
            result = [za UnzipFileTo:[self dataFilePath:@"toFilePath"] overWrite:YES];
            [za UnzipCloseFile];
        }
        

        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            if (result) {
                // 解压完成回归主线程处理
            }
        });
        
    });
    
}

+ (NSString *)dataFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


@end
