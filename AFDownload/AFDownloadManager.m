//
//  AFDownloadManager.m
//  AFDownload
//
//  Created by gavin on 15/6/27.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "AFDownloadManager.h"

@implementation AFDownloadManager
{
    NSOperationQueue *_downloadQueue;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        [_downloadQueue setMaxConcurrentOperationCount:3];
        
//        _operationDictionary=[[NSMutableDictionary alloc]init];
//        _receviedBytesArray=[[NSMutableDictionary alloc]init];
    }
    return self;
}

+ (instancetype)sharedDownloadManager {
    static dispatch_once_t onceToken;
    static id sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}





- (void)    download4:(NSString *)name
      withDownloadURL:(NSString *)url
 withDownloadSavePath:(NSString *)path
   withUIProgressView:(UIProgressView *)prg
withAFHTTPRequestOperation:(AFDownloadRequestOperation *)operation
 withCurrDownloadCell:(TableViewCell *)cell

{
    
    
    NSString *str = [NSString stringWithFormat:@"%@%@",@"%@/Documents/",name];
    
    NSString *filePath = [NSString stringWithFormat:str, NSHomeDirectory()];
    
    //打印文件保存的路径
    NSLog(@"%@",filePath);
    
    //创建请求管理
    operation = [[AFDownloadRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] targetPath:filePath shouldResume:YES];
    
    //添加下载请求（获取服务器的输出流）
    //    _operationDownload.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        
        CGFloat progressfloat = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        NSLog(@"%f",progressfloat);
        
        [prg setProgress:progressfloat animated:YES];
        
    }];
    

    //请求管理判断请求结果
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //success
        NSLog(@"Finish and Download to: %@", filePath);
        cell.downloadState = 3;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //error
        NSLog(@"Error: %@",error);
    }];
    
    cell.cellOperation = operation;
    
    [_downloadQueue addOperation:operation];
    
//    [operation start];
}




- (void)begingDownload{}

- (void)pauseDownload:(AFHTTPRequestOperation *)afop{
    NSArray *arr = [_downloadQueue operations];
    
    for (AFDownloadRequestOperation *op in arr) {
        if ([op isEqual:afop]) {
            [op pause];
        }
    }
    
}

- (void)resumeDownload:(AFHTTPRequestOperation *)afop{
    NSArray *arr = [_downloadQueue operations];
    
    for (AFDownloadRequestOperation *op in arr) {
        if ([op isEqual:afop]) {
            [op resume];
        }
    }
}


- (void)pauseAllDownload:(AFHTTPRequestOperation *)afop{
    NSArray *arr = [_downloadQueue operations];
    if (! arr.count > 0) {
        return;
    }
    for (AFDownloadRequestOperation *op in arr) {
        [op pause];
    }
}


- (void)resumeAllDownload:(AFHTTPRequestOperation *)afop{
    NSArray *arr = [_downloadQueue operations];
    if (! arr.count > 0) {
        return;
    }
    for (AFDownloadRequestOperation *op in arr) {
        [op resume];
    }
}


@end
