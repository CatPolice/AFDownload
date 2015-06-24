//
//  ViewController.m
//  AFDownload
//
//  Created by gavin on 15/6/24.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
{
    AFURLSessionManager * _manager;
    
    AFHTTPRequestOperation *_operation;      //创建请求管理（用于上传和下载）
}

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
- (IBAction)beginAction:(id)sender;
- (IBAction)zanAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)beginAction:(id)sender {
    [self download];
}

- (IBAction)zanAction:(id)sender {
}

#pragma mark download

- (void)download{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"];
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




#pragma mark download 2

//开始下载（断点续传）
- (void)downloadStart
{
    [self download2];
    [_operation start];
}

//暂停下载（断点续传）
- (void)downloadPause
{
    [_operation pause];
}

//继续下载（断点续传）
- (void)downloadResume
{
    [_operation resume];
}




- (void)download2 {
    //方法二
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/QQ_V4.0.2.dmg", NSHomeDirectory()];
    
    //打印文件保存的路径
    NSLog(@"%@",filePath);
    
    //创建请求管理
    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"]]];
    
    //添加下载请求（获取服务器的输出流）
    _operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    //设置下载进度条
    __weak __typeof(self)weakSelf = self;
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //显示下载进度
        CGFloat progressfloat = ((float)totalBytesRead) / totalBytesExpectedToRead;
        [strongSelf.progress setProgress:progressfloat animated:YES];
        
        
    }];
    
    //请求管理判断请求结果
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功
        NSLog(@"Finish and Download to: %@", filePath);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求失败
        NSLog(@"Error: %@",error);
    }];

}






























@end
