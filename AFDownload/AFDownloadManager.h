//
//  AFDownloadManager.h
//  AFDownload
//
//  Created by gavin on 15/6/27.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"
#import "TableViewCell.h"

@interface AFDownloadManager : NSObject


+ (instancetype)sharedDownloadManager;




// 开始下载 : 遍历队列中 operationQueue

- (void)begingDownload ;

- (void)pauseDownload:(AFHTTPRequestOperation *)afop;

- (void)resumeDownload:(AFHTTPRequestOperation *)afop;

- (void)pauseAllDownload:(AFHTTPRequestOperation *)afop;

- (void)resumeAllDownload:(AFHTTPRequestOperation *)afop;


- (void)    download4:(NSString *)name
      withDownloadURL:(NSString *)url
 withDownloadSavePath:(NSString *)path
   withUIProgressView:(UIProgressView *)prg
withAFHTTPRequestOperation:(AFDownloadRequestOperation *)operation
 withCurrDownloadCell:(TableViewCell *)cell;

@end
