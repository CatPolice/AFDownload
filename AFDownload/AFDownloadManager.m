//
//  AFDownloadManager.m
//  AFDownload
//
//  Created by gavin on 15/6/27.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "AFDownloadManager.h"

#define MAXOPERATIONCOUNT 5


@implementation AFDownloadManager
{
    AFURLSessionManager * _manager; // ios7 > ; download
    
    NSOperationQueue *_downloadQueue;
}

#pragma mark shared onceToken
+ (instancetype)sharedDownloadManager {
    static dispatch_once_t onceToken;
    static id sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

#pragma mark init
- (id)init
{
    self = [super init];
    
    if (self) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadDic = [[NSMutableDictionary alloc] init];
        
        [_downloadQueue setMaxConcurrentOperationCount:MAXOPERATIONCOUNT]; // set max operation count
        
//        _operationDictionary=[[NSMutableDictionary alloc]init];
//        _receviedBytesArray=[[NSMutableDictionary alloc]init];
    }
    return self;
}

#pragma mark download

- (void)downloadQueueTask:(NSString *)name withDownloadURL:(NSString *)url
                                      withDownloadSavePath:(NSString *)path
                                        withUIProgressView:(UIProgressView *)prg
                                withAFHTTPRequestOperation:(AFDownloadRequestOperation *)operation
                                      withCurrDownloadCell:(UITableViewCell *)cell
                                           downloadSuccess:(void (^)(NSInteger state))success
                                             downloadError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))downloadError

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
//        NSLog(@"%f",progressfloat);
        [prg setProgress:progressfloat animated:YES];
        
    }];
    

    //请求管理判断请求结果
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //success
        NSLog(@"Finish and Download to: %@", filePath);
        success(3);
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //error
        NSLog(@"Error: %@",error);
        [operation cancel];
        downloadError(operation , error);
    }];
    
    [_downloadQueue addOperation:operation];
    
    [self.downloadDic setObject:operation forKey:url];
    
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



#pragma mark single download

- (void)downloadSingleTask:(AFHTTPRequestOperation *)operation withUrl:(NSString *)url withFilePath:(NSString *)filePath
            withUIProgress:(UIProgressView *)progress{
//    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/QQ_V4.0.2.dmg", NSHomeDirectory()];
    
    //打印文件保存的路径
    NSLog(@"%@",filePath);
    
    //创建请求管理
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    //添加下载请求（获取服务器的输出流）
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progressfloat = ((float)totalBytesRead) / totalBytesExpectedToRead;
        [progress setProgress:progressfloat animated:YES];
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //success
        NSLog(@"Finish and Download to: %@", filePath);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //error
        NSLog(@"Error: %@",error);
    }];
    
    [operation start];
}



#pragma mark ios7 > ; download 

- (void)downloadIOS7:(NSString *)url{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
//    NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"];
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request
                                                                      progress:nil
                                                                   destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                                                                        inDomain:NSUserDomainMask appropriateForURL:nil
                                                                                                                          create:NO
                                                                                                                           error:nil];
                                                  
                                                  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                  
                                              } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                  
                                                  NSLog(@"File downloaded to: %@", filePath);
                                                  
                                              }];
    [downloadTask resume];
}




#pragma mark download progree BUG! Prudent use!
- (void) download3:(NSString *)name  withDownloadURL:(NSString *)url
                                withDownloadSavePath:(NSString *)path
                                  withUIProgressView:(UIProgressView *)prg
                          withAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation
                                withCurrDownloadCell:(TableViewCell *)cell;

{
    NSString *str = [NSString stringWithFormat:@"%@%@",@"%@/Documents/",name];
    
    NSString *filePath = [NSString stringWithFormat:str, NSHomeDirectory()];
    
    //打印文件保存的路径
    NSLog(@"%@",filePath);
    
    //创建请求管理
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    //添加下载请求（获取服务器的输出流）
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progressfloat = ((float)totalBytesRead) / (totalBytesExpectedToRead);
        [prg setProgress:progressfloat animated:YES];
        
        //        NSLog(@"%f",progressfloat);
        NSLog(@"%zd",bytesRead);
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
    
    [operation start];
}
@end
