//
//  ViewController.m
//  AFDownload
//
//  Created by gavin on 15/6/24.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "TableViewCell.h"
#import "AFDownloadRequestOperation.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
    BOOL _nibsRegistered;
    
    NSArray *_cellName;
    NSArray *_urlArr;
    
    
    
    AFURLSessionManager * _manager;
    
    AFHTTPRequestOperation *_operation;      //创建请求管理（用于上传和下载）
    
    
    AFDownloadRequestOperation *_operationDownload;
    
    NSMutableDictionary *_operationList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

- (IBAction)beginAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)resumeAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _operationList = [[NSMutableDictionary alloc] init];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _cellName = @[@"Res1",@"Res2"];
    _urlArr = @[@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg",@"http://dl_dir2.qq.com/invc/xfspeed/qdesk/versetup/QDeskSetup_25_1277.exe"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 开始
- (IBAction)beginAction:(id)sender {
//    [self download];
    
    [self downloadStart];
}

// 暂停
- (IBAction)pauseAction:(id)sender {
    [self downloadPause];
}

// 继续
- (IBAction)resumeAction:(id)sender {
    [self downloadResume];
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
    
    __weak __typeof(self)weakSelf = self;
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGFloat progressfloat = ((float)totalBytesRead) / totalBytesExpectedToRead;
        [strongSelf.progress setProgress:progressfloat animated:YES];
    }];
    
    //请求管理判断请求结果
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //success
        NSLog(@"Finish and Download to: %@", filePath);
        
        
        // 请求成功之后把 operation 从list 中移除
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //error
        NSLog(@"Error: %@",error);
    }];
}



#pragma mark download parment

- (void)    download3:(NSString *)name
      withDownloadURL:(NSString *)url
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
        CGFloat progressfloat = ((float)totalBytesRead) / totalBytesExpectedToRead;
        [prg setProgress:progressfloat animated:YES];
        
        NSLog(@"%f",progressfloat);
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




- (void)    download4:(NSString *)name
      withDownloadURL:(NSString *)url
 withDownloadSavePath:(NSString *)path
   withUIProgressView:(UIProgressView *)prg
withAFHTTPRequestOperation:(AFDownloadRequestOperation *)operation
 withCurrDownloadCell:(TableViewCell *)cell;

{
    
    
    NSString *str = [NSString stringWithFormat:@"%@%@",@"%@/Documents/",name];
    
    NSString *filePath = [NSString stringWithFormat:str, NSHomeDirectory()];
    
    //打印文件保存的路径
    NSLog(@"%@",filePath);
    
    //创建请求管理
    operation = [[AFDownloadRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] targetPath:filePath shouldResume:YES];
    
    //添加下载请求（获取服务器的输出流）
//    _operationDownload.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progressfloat = ((float)totalBytesRead) / totalBytesExpectedToRead;
        [prg setProgress:progressfloat animated:YES];
        
        NSLog(@"%f",progressfloat);
    }];
    
    //请求管理判断请求结果
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //success
        NSLog(@"Finish and Download to: %@", filePath);
        cell.downloadState = 3;
        
        [_tableview reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //error
        NSLog(@"Error: %@",error);
    }];
    
    
    
    cell.cellOperation = operation;
    
    [operation start];
}




#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"TableViewCell";
     if (!_nibsRegistered) {
     UINib * nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
     [tableView registerNib:nib forCellReuseIdentifier:identifier];
     _nibsRegistered = YES;
     }
     
     TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.cellName.text = [_cellName objectAtIndex:indexPath.row];
    //0:未下载  1:下载中 2:暂停 3:完成
    NSArray *arr = @[@"下载",@"下载中",@"暂停",@"完成"];
    cell.cellState.text = [arr objectAtIndex:cell.downloadState];
    
    __weak __typeof(self)weakSelf = self;
    
    cell.cellDownloadCallBack = ^(TableViewCell *cell){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        switch (cell.downloadState) {
            case 0: // prepareing
            {
                AFHTTPRequestOperation *operation;
                [strongSelf download3:[_cellName objectAtIndex:indexPath.row]
                      withDownloadURL:[_urlArr objectAtIndex:indexPath.row]
                 withDownloadSavePath:nil
                   withUIProgressView:cell.cellPrg
           withAFHTTPRequestOperation:operation
                 withCurrDownloadCell:cell];

                cell.downloadState = 1;
                
                
                
//                AFDownloadRequestOperation *operation;
//                [strongSelf download4:[_cellName objectAtIndex:indexPath.row]
//                      withDownloadURL:[_urlArr objectAtIndex:indexPath.row]
//                 withDownloadSavePath:nil
//                   withUIProgressView:cell.cellPrg
//           withAFHTTPRequestOperation:operation
//                 withCurrDownloadCell:cell];
//                
//                cell.downloadState = 1;
                
            }
                break;
                
            case 1:// downloading
            {
                if (cell.cellOperation) {
                    AFHTTPRequestOperation *operation = cell.cellOperation;
                    [operation pause];
                    cell.downloadState = 2;
                }
            }
                break;
                
            case 2: // pauseing
            {
                if (cell.cellOperation) {
                    AFHTTPRequestOperation *operation = cell.cellOperation;
                    [operation resume];
                    cell.downloadState = 1;
                }
            }
                break;
            
            case 3:
            {
                NSLog(@"下载已经完成");
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"资源已经下载完成" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [al show];
            }
                break;
                
            default:
                break;
        }
        [strongSelf.tableview reloadData];
    };

    return cell;
}




















@end
