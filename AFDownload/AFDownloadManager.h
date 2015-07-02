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

@property (nonatomic , strong) NSMutableDictionary *downloadDic;

+ (instancetype)sharedDownloadManager;


// 开始下载 : 遍历队列中 operationQueue

- (void)begingDownload ;

- (void)pauseDownload:(AFHTTPRequestOperation *)afop;

- (void)resumeDownload:(AFHTTPRequestOperation *)afop;

- (void)pauseAllDownload:(AFHTTPRequestOperation *)afop;

- (void)resumeAllDownload:(AFHTTPRequestOperation *)afop;


- (void)downloadQueueTask:(NSString *)name withDownloadURL:(NSString *)url
                                      withDownloadSavePath:(NSString *)path
                                        withUIProgressView:(UIProgressView *)prg
                                withAFHTTPRequestOperation:(AFDownloadRequestOperation *)operation
                                      withCurrDownloadCell:(UITableViewCell *)cell
                                           downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject , NSInteger state))success
                                             downloadError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))downloadError;



- (void)downloadSingleTask:(AFHTTPRequestOperation *)operation
                   withUrl:(NSString *)url
              withFilePath:(NSString *)filePath
            withUIProgress:(UIProgressView *)progress;



@end
